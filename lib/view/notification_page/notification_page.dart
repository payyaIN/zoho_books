import 'package:payzo_books/import_data.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsData = ref.watch(getNotificationsProvider);

    return Scaffold(
      appBar: reusableAppBar(
        context: context,
        title: AppText.notifications,
        showBackButton: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.filter_list),
        //     onPressed: () {
        //       _showFilterOptions(context, ref);
        //     },
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final repository = ref.watch(notificationRepository);
          await repository.fetchNotifications();
          ref.invalidate(getNotificationsProvider);
          return;
        },
        child: notificationsData.when(
          data: (data) {
            if (data.data.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No Notifications",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "You're all caught up!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: data.data.length,
              itemBuilder: (context, index) {
                final notification = data.data[index];

                String title = _determineNotificationTitle(notification);
                String timeAgo = _formatTimeAgo(
                    notification.timeAgo, notification.createdOn);
                bool isDelivery = notification.typeId == 9;
                bool isRead = notification.status == 1;

                return GestureDetector(
                  onTap: () {
                    if (notification.id != null) {
                      ref.read(selectedNotificationIdProvider.notifier).state =
                          notification.id;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailsPage(
                            typeId: '${notification.typeId}',
                            processId: '${notification.processId}',
                          ),
                        ),
                      );

                      if (!isRead && notification.id != null) {
                        ref.read(
                            markNotificationAsReadProvider(notification.id!)
                                .future);
                      }
                    }
                  },
                  child: NotificationTile(
                    title: title,
                    message:
                        notification.message ?? "You have a new notification",
                    timeAgo: timeAgo,
                    isDelivery: isDelivery,
                    isRead: isRead,
                  ),
                );
              },
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: AppColors.appMainColor,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.shade300,
                ),
                SizedBox(height: 16),
                Text(
                  "Failed to load notifications",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(getNotificationsProvider),
                  child: Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _determineNotificationTitle(NotificationData notification) {
    final message = notification.message?.toLowerCase() ?? '';

    if (message.contains("rejected")) {
      if (message.contains("invoice")) {
        return "Invoice Rejected";
      } else if (message.contains("bill")) {
        return "Bill Rejected";
      } else if (message.contains("rfq")) {
        return "RFQ Rejected";
      } else if (message.contains("quote") || message.contains("quotation")) {
        return "Quote Rejected";
      } else if (message.contains("order") || message.contains("po")) {
        return "Purchase Order Rejected";
      } else {
        return "Notification Rejected";
      }
    } else if (message.contains("approved")) {
      if (message.contains("invoice")) {
        return "Invoice Approved";
      } else if (message.contains("bill")) {
        return "Bill Approved";
      } else if (message.contains("rfq")) {
        return "RFQ Approved";
      } else if (message.contains("quote") || message.contains("quotation")) {
        return "Quote Approved";
      } else if (message.contains("order") || message.contains("po")) {
        return "Purchase Order Approved";
      } else {
        return "Notification Approved";
      }
    } else if (message.contains("completed")) {
      if (message.contains("invoice")) {
        return "Invoice Processed";
      } else if (message.contains("bill")) {
        return "Bill Processed";
      } else if (message.contains("rfq")) {
        return "RFQ Processed";
      } else if (message.contains("quote") || message.contains("quotation")) {
        return "Quote Processed";
      } else if (message.contains("order") || message.contains("po")) {
        return "Purchase Order Processed";
      } else {
        return "Process Completed";
      }
    } else if (message.contains("created") || message.contains("waiting")) {
      if (message.contains("invoice")) {
        return "Invoice Approval Required";
      } else if (message.contains("bill")) {
        return "Bill Approval Required";
      } else if (message.contains("rfq")) {
        return "RFQ Approval Required";
      } else if (message.contains("quote") || message.contains("quotation")) {
        return "Quote Approval Required";
      } else if (message.contains("order") || message.contains("po")) {
        return "Purchase Order Approval Required";
      } else {
        return "Approval Required";
      }
    } else if (message.contains("bill")) {
      return "New Bill Added";
    } else if (message.contains("invoice")) {
      return "Invoice Notification";
    } else if (message.contains("rfq")) {
      return "RFQ Notification";
    } else if (message.contains("quote") || message.contains("quotation")) {
      return "Quote Notification";
    } else if (message.contains("order") || message.contains("po")) {
      return "Purchase Order Notification";
    } else {
      return "Notification";
    }
  }

  String _formatTimeAgo(String? timeAgo, String? createdOn) {
    if (timeAgo != null && timeAgo.isNotEmpty) {
      return timeAgo;
    }

    if (createdOn != null) {
      final datePattern = RegExp(r'(\d{2}-\d{2}-\d{4})');
      final match = datePattern.firstMatch(createdOn);
      if (match != null) {
        return match.group(1) ?? "Recently";
      }
    }

    return "Recently";
  }

  void _showFilterOptions(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Filter Notifications"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: NotificationFilterType.values.map((type) {
            return ListTile(
              title: Text(getFilterName(type)),
              onTap: () {
                ref.read(notificationFilterProvider.notifier).state = type;
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
