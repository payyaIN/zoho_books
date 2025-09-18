import 'package:payzo_books/data/repository/notification_api/approve_notification_api.dart';
import 'package:payzo_books/data/repository/purchase_order/get_order_details.dart';
import 'package:payzo_books/data/repository/quotes_api/quotes_details_api.dart';
import 'package:payzo_books/data/repository/rfq/get_rfq_details.dart';
import 'package:payzo_books/import_data.dart';

Future<bool> approveNotification({
  required BuildContext context,
  required WidgetRef ref,
  required int typeId,
  required int processId,
  required String itemType,
  required Future<void> Function() refreshAction,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: AppColors.appMainColor,
      ),
    ),
  );

  try {
    final result = await ref.read(approveNotificationProvider(
      ApproveNotificationParams(
        typeId: typeId,
        processId: processId,
      ),
    ).future);

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (result.isSuccess) {
      await refreshAction();
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess
              ? "$itemType approved successfully"
              : result.message.isNotEmpty
                  ? result.message
                  : "Failed to approve $itemType"),
          backgroundColor: result.isSuccess ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return result.isSuccess;
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    return false;
  }
}

Future<bool> approveInvoiceFromNotification(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  return approveNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'Invoice',
    refreshAction: () =>
        ref.refresh(getInvoiceDetailsProvider(processId).future),
  );
}

Future<bool> approveBillFromNotification(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  return approveNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'Bill',
    refreshAction: () => ref.refresh(getBillDetailsProvider(processId).future),
  );
}

Future<bool> approveRfqFromNotification(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  return approveNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'RFQ',
    refreshAction: () => ref.refresh(getRfqDetailsProvider(processId).future),
  );
}

Future<bool> approveQuoteFromNotification(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  return approveNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'Quote',
    refreshAction: () => ref.refresh(getQuoteDetailsProvider(processId).future),
  );
}

Future<bool> approveOrderFromNotification(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  return approveNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'Purchase Order',
    refreshAction: () => ref.refresh(getOrderDetailsProvider(processId).future),
  );
}
