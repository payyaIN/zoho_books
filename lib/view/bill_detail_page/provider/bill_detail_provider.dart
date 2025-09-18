import 'package:payzo_books/data/models/bill_model/bill_detail_model.dart';
import 'package:payzo_books/data/models/bill_model/bill_model.dart';
import 'package:payzo_books/import_data.dart';

class BillDetailsNotifier extends StateNotifier<BillModel?> {
  BillDetailsNotifier() : super(null);

  void selectBill(BillModel billDetailModel) {
    state = billDetailModel;
  }

  void clearSelection() {
    state = null;
  }
}

final billSelectionProvider =
    StateNotifierProvider<BillDetailsNotifier, BillModel?>((ref) {
  return BillDetailsNotifier();
});

final selectedBillDetailProvider =
    StateProvider<BillDetailModel?>((ref) => null);

void setSelectedBillDetail(WidgetRef ref, BillDetailModel billDetail) {
  ref.read(selectedBillDetailProvider.notifier).state = billDetail;
}

BillDetailModel? getSelectedBillDetail(WidgetRef ref) {
  return ref.read(selectedBillDetailProvider);
}

final specificBillProvider =
    Provider.family<BillData?, BillModel?>((ref, model) {
  if (model == null || model.billData == null || model.billData!.isEmpty) {
    return null;
  }

  return model.billData![0];
});
