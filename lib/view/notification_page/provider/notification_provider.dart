import 'package:payzo_books/data/models/notification_model/notification_model.dart';
import 'package:payzo_books/data/repository/notification_api/notification_api.dart';
import 'package:payzo_books/import_data.dart';

final selectedNotificationIdProvider = StateProvider<int?>((ref) => null);

enum NotificationFilterType {
  all,
  unread,
  signals,
  workflowRules,
  mentions,
  otherNotification
}

final notificationFilterProvider =
    StateProvider<NotificationFilterType>((ref) => NotificationFilterType.all);

final filteredNotificationsProvider = Provider<List<NotificationData>>((ref) {
  final notificationsAsync = ref.watch(getNotificationsProvider);
  final filterType = ref.watch(notificationFilterProvider);

  return notificationsAsync.maybeWhen(
    data: (data) {
      final notifications = data.data;

      switch (filterType) {
        case NotificationFilterType.unread:
          return notifications.where((n) => n.status == 0).toList();
        case NotificationFilterType.signals:
          return notifications.where((n) => n.typeId == 1).toList();
        case NotificationFilterType.workflowRules:
          return notifications.where((n) => n.typeId == 9).toList();
        case NotificationFilterType.mentions:
          return notifications
              .where((n) => n.message?.contains('@') ?? false)
              .toList();
        case NotificationFilterType.otherNotification:
          return notifications
              .where((n) => n.typeId != 1 && n.typeId != 9)
              .toList();
        case NotificationFilterType.all:
        default:
          return notifications;
      }
    },
    orElse: () => [],
  );
});

String getFilterName(NotificationFilterType filter) {
  switch (filter) {
    case NotificationFilterType.all:
      return 'All';
    case NotificationFilterType.unread:
      return 'Unread';
    case NotificationFilterType.signals:
      return 'Signals';
    case NotificationFilterType.workflowRules:
      return 'Workflow Rules';
    case NotificationFilterType.mentions:
      return 'Mentions';
    case NotificationFilterType.otherNotification:
      return 'Other Notification';
    default:
      return 'All';
  }
}
