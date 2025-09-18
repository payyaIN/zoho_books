import 'package:payzo_books/data/repository/purchase_order/get_order_details.dart';
import 'package:payzo_books/data/repository/quotes_api/quotes_details_api.dart';
import 'package:payzo_books/data/repository/rfq/get_rfq_details.dart';
import 'package:payzo_books/import_data.dart';

Future<void> showRejectReasonDialog({
  required BuildContext context,
  required WidgetRef ref,
  required int typeId,
  required int processId,
  required String itemType,
  required Future<bool> Function(String reason) onRejectWithReason,
}) async {
  final reasonController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Reject $itemType'),
      content: TextField(
        controller: reasonController,
        decoration: InputDecoration(
          hintText: 'Enter rejection reason',
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final reason = reasonController.text.trim();
            if (reason.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a rejection reason')),
              );
              return;
            }
            Navigator.of(context).pop();
            onRejectWithReason(reason);
          },
          child: Text('Reject'),
        ),
      ],
    ),
  );
}

Future<bool> rejectNotification({
  required BuildContext context,
  required WidgetRef ref,
  required int typeId,
  required int processId,
  required String reason,
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
    final result = await ref.read(rejectNotificationProvider(
      RejectNotificationParams(
        typeId: typeId,
        processId: processId,
        reason: reason,
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
              ? "$itemType rejected successfully"
              : result.message.isNotEmpty
                  ? result.message
                  : "Failed to reject $itemType"),
          backgroundColor: result.isSuccess ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (result.isSuccess && context.mounted) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
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

Future<bool> rejectInvoiceFromNotification(BuildContext context, WidgetRef ref,
    int typeId, int processId, String reason) async {
  return rejectNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    reason: reason,
    itemType: 'Invoice',
    refreshAction: () =>
        ref.refresh(getInvoiceDetailsProvider(processId).future),
  );
}

Future<bool> rejectBillFromNotification(
    BuildContext context, WidgetRef ref, int typeId, int processId,
    {required String reason}) async {
  return rejectNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    reason: reason,
    itemType: 'Bill',
    refreshAction: () => ref.refresh(getBillDetailsProvider(processId).future),
  );
}

Future<bool> promptAndRejectInvoice(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  bool success = false;
  await showRejectReasonDialog(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'Invoice',
    onRejectWithReason: (reason) async {
      success = await rejectInvoiceFromNotification(
          context, ref, typeId, processId, reason);
      return success;
    },
  );
  return success;
}

Future<bool> promptAndRejectBill(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  bool success = false;
  await showRejectReasonDialog(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'Bill',
    onRejectWithReason: (reason) async {
      success = await rejectBillFromNotification(
          context, ref, typeId, processId,
          reason: reason);
      return success;
    },
  );
  return success;
}

Future<bool> rejectRfqFromNotification(BuildContext context, WidgetRef ref,
    int typeId, int processId, String reason) async {
  return rejectNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    reason: reason,
    itemType: 'RFQ',
    refreshAction: () => ref.refresh(getRfqDetailsProvider(processId).future),
  );
}

Future<bool> rejectQuoteFromNotification(BuildContext context, WidgetRef ref,
    int typeId, int processId, String reason) async {
  return rejectNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    reason: reason,
    itemType: 'Quote',
    refreshAction: () => ref.refresh(getQuoteDetailsProvider(processId).future),
  );
}

Future<bool> rejectOrderFromNotification(BuildContext context, WidgetRef ref,
    int typeId, int processId, String reason) async {
  return rejectNotification(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    reason: reason,
    itemType: 'Purchase Order',
    refreshAction: () => ref.refresh(getOrderDetailsProvider(processId).future),
  );
}

Future<bool> promptAndRejectRfq(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  bool success = false;
  await showRejectReasonDialog(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'RFQ',
    onRejectWithReason: (reason) async {
      success = await rejectRfqFromNotification(
          context, ref, typeId, processId, reason);
      return success;
    },
  );
  return success;
}

Future<bool> promptAndRejectQuote(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  bool success = false;
  await showRejectReasonDialog(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'Quote',
    onRejectWithReason: (reason) async {
      success = await rejectQuoteFromNotification(
          context, ref, typeId, processId, reason);
      return success;
    },
  );
  return success;
}

Future<bool> promptAndRejectOrder(
    BuildContext context, WidgetRef ref, int typeId, int processId) async {
  bool success = false;
  await showRejectReasonDialog(
    context: context,
    ref: ref,
    typeId: typeId,
    processId: processId,
    itemType: 'Purchase Order',
    onRejectWithReason: (reason) async {
      success = await rejectOrderFromNotification(
          context, ref, typeId, processId, reason);
      return success;
    },
  );
  return success;
}
