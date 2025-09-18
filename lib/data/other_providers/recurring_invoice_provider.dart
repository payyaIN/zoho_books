import 'package:payzo_books/data/models/recurring_invoice_model/all_recurring_invoice_model.dart';
import 'package:payzo_books/data/repository/recurring_invoice/all_recurring_invoice_api.dart';
import 'package:payzo_books/import_data.dart';

class RecurringInvoiceNotifier
    extends StateNotifier<GetAllRecurringInvoiceModel?> {
  RecurringInvoiceNotifier() : super(null);

  void setRecurringInvoiceData(GetAllRecurringInvoiceModel invoiceModel) {
    state = invoiceModel;
  }

  void clearRecurringInvoiceData() {
    state = null;
  }
}

final recurringInvoiceProvider = StateNotifierProvider<RecurringInvoiceNotifier,
    GetAllRecurringInvoiceModel?>((ref) {
  return RecurringInvoiceNotifier();
});

final recurringInvoicePaginationProvider =
    StateProvider<RecurringInvoicePaginationParams>((ref) {
  return RecurringInvoicePaginationParams();
});

final hasMoreRecurringInvoicesProvider = Provider<bool>((ref) {
  final invoiceData = ref.watch(recurringInvoiceProvider);
  final pagination = ref.watch(recurringInvoicePaginationProvider);

  if (invoiceData == null) return false;

  final totalFetched = (pagination.pageNo + 1) * pagination.rowPerPage;
  return totalFetched < invoiceData.totalCount;
});

Future<void> loadMoreRecurringInvoices(WidgetRef ref) async {
  final currentPagination = ref.read(recurringInvoicePaginationProvider);
  final newPagination = RecurringInvoicePaginationParams(
    recInvId: currentPagination.recInvId,
    recInvOrderNumber: currentPagination.recInvOrderNumber,
    recInvStatus: currentPagination.recInvStatus,
    field: currentPagination.field,
    order: currentPagination.order,
    rowPerPage: currentPagination.rowPerPage,
    pageNo: currentPagination.pageNo + 1,
  );

  ref.read(recurringInvoicePaginationProvider.notifier).state = newPagination;

  final result = await ref
      .read(getRecurringInvoiceWithPaginationProvider(newPagination).future);

  final currentData = ref.read(recurringInvoiceProvider);
  if (currentData != null) {
    final updatedInvoices = [
      ...currentData.recInvoiceData,
      ...result.recInvoiceData,
    ];

    ref
        .read(recurringInvoiceProvider.notifier)
        .setRecurringInvoiceData(GetAllRecurringInvoiceModel(
          count: result.count,
          totalCount: result.totalCount,
          recInvoiceData: updatedInvoices,
        ));
  } else {
    ref.read(recurringInvoiceProvider.notifier).setRecurringInvoiceData(result);
  }
}
