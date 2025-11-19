import 'package:payzo_books/data/models/vendor_model_list/vendor_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_model.dart';

/// Provider to track if we're in edit mode for vendor
final updateVendorEditModeProvider = StateProvider<bool>((ref) => false);

/// Provider to hold the vendor partyId being edited
final updateVendorEditPartyIdProvider = StateProvider<int?>((ref) => null);

/// Provider to hold the full vendor data being edited
final updateVendorEditDataProvider =
    StateProvider<UpdateVendor?>((ref) => null);
final vendorEditDataProvider = StateProvider<Vendor?>((ref) => null);
