import 'package:payzo_books/data/models/invoice_model/invoice_detail_model.dart';
import 'package:payzo_books/data/models/invoice_model/invoice_list_model.dart';
import 'package:payzo_books/import_data.dart';

class InvoiceDetailsNotifier extends StateNotifier<InvoiceModel?> {
  InvoiceDetailsNotifier() : super(null);

  void selectInvoice(InvoiceModel invoiceDetailModel) {
    state = invoiceDetailModel;
  }

  void clearSelection() {
    state = null;
  }
}

final invoiceSelectionProvider =
    StateNotifierProvider<InvoiceDetailsNotifier, InvoiceModel?>((ref) {
  return InvoiceDetailsNotifier();
});

final selectedInvoiceDetailProvider =
    StateProvider<InvoiceDetailModel?>((ref) => null);

void setSelectedInvoiceDetail(WidgetRef ref, InvoiceDetailModel invoiceDetail) {
  ref.read(selectedInvoiceDetailProvider.notifier).state = invoiceDetail;
}

InvoiceDetailModel? getSelectedInvoiceDetail(WidgetRef ref) {
  return ref.read(selectedInvoiceDetailProvider);
}

final specificInvoiceProvider =
    Provider.family<InvoiceData?, InvoiceModel?>((ref, model) {
  if (model == null ||
      model.invoiceData == null ||
      model.invoiceData!.isEmpty) {
    return null;
  }

  return model.invoiceData![0];
});
