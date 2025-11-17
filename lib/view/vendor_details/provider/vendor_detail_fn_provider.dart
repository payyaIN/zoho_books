import 'package:payzo_books/data/models/vendor_model_list/vendor_model.dart';
import 'package:payzo_books/import_data.dart';

class VendorDetailsNotifier extends StateNotifier<VendorModel?> {
  VendorDetailsNotifier() : super(null);

  void selectVendor(VendorModel vendorDetailModel) {
    state = vendorDetailModel;
  }

  void clearSelection() {
    state = null;
  }
}

final vendorSelectionProvider =
    StateNotifierProvider<VendorDetailsNotifier, VendorModel?>((ref) {
  return VendorDetailsNotifier();
});

final specificVendorProvider =
    Provider.family<Vendor?, VendorModel?>((ref, model) {
  if (model == null || model.response.response.isEmpty) {
    return null;
  }

  return model.response.response[0];
});
