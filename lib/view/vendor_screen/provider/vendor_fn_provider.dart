import 'package:payzo_books/data/models/vendor_model_list/vendor_model.dart';
import 'package:payzo_books/import_data.dart';

class VendorSelectionNotifier extends StateNotifier<VendorModel?> {
  VendorSelectionNotifier() : super(null);

  void selectVendor(VendorModel vendor) {
    state = vendor;
  }

  void clearSelection() {
    state = null;
  }
}

final vendorSelectionProvider =
    StateNotifierProvider<VendorSelectionNotifier, VendorModel?>((ref) {
  return VendorSelectionNotifier();
});
