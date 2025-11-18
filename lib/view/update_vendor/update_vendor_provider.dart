import 'package:payzo_books/data/models/vendor_model_list/vendor_model.dart';
import 'package:payzo_books/data/models/view_party/view_party_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_model.dart';

/// Provider to track if we're in edit mode for vendor
final updateVendorEditModeProvider = StateProvider<bool>((ref) => false);

/// Provider to hold the vendor partyId being edited
final updateVendorEditPartyIdProvider = StateProvider<int?>((ref) => null);

/// Provider to hold the full vendor data being edited (LEGACY - UpdateVendor model)
final updateVendorEditDataProvider =
    StateProvider<UpdateVendor?>((ref) => null);

/// Provider to hold basic vendor data from listing (Vendor model)
final vendorEditDataProvider = StateProvider<Vendor?>((ref) => null);

/// ✅ NEW: Provider to hold COMPLETE vendor data from viewParty API
/// This is the PRIMARY source of data for editing - it has all fields including addressId
final viewPartyEditDataProvider =
    StateProvider<ViewPartyResponseData?>((ref) => null);

/// ✅ NEW: Provider to store original displayName to avoid "already exists" error
/// The update API checks displayName uniqueness, so we need to send the original
/// displayName back even if other fields are edited
final updateVendorOriginalDisplayNameProvider =
    StateProvider<String?>((ref) => null);
