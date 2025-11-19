// File: lib/view/update_vendor/update_vendor_repo.dart
// KEY CHANGES:
// 1. Uses original displayName to prevent "already exists" error
// 2. Includes addressId in billing and shipping addresses

import 'package:payzo_books/data/models/add_vendor/add_vendor_model.dart';
import 'package:payzo_books/data/models/vendor_model_list/vendor_model.dart';
import 'package:payzo_books/data/repository/add_vendor/get_state_list_repository.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_vendor/add_vendor.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_notifier.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_provider.dart';

class UpdateVendorRepository {
  final Ref ref;

  UpdateVendorRepository(this.ref);

  Future<VendorModel> updateVendor(int partyId) async {
    final state = ref.read(updateVendorFormProvider);
    final countryPhone = ref.read(countryPhoneProvider);
    final sameAsBilling = ref.read(sameAsBillingToggleProvider);
    final mobileCode = ref.read(countryPhoneMobileProvider);

    // ✅ Get original displayName to avoid "already exists" error
    // final originalDisplayName =
    //     ref.read(updateVendorOriginalDisplayNameProvider);

    debugPrint("🔍 Update Vendor State: ${state.toJson()}");
    debugPrint("🔍 Party ID: $partyId");
    // debugPrint("🔍 Original DisplayName: $originalDisplayName");
    debugPrint("🔍 Current DisplayName: ${state.displayName}");

    final vendorBody = {
      "primaryContact": {
        "firstName": state.firstName,
        "lastName": state.secondName,
      },
      "primaryContactArabic": {
        "firstNameArabic": state.firstNameArabic,
        "lastNameArabic": state.secondNameArabic,
      },
      "customerType": state.customerType,
      "partyType": state.partyType,
      "partyId": partyId.toString(),
      "companyName": state.companyName,
      "companyNameArabic": state.companyNameArabic,
      // ✅ CRITICAL FIX: Use original displayName to prevent "already exists" error
      "displayName": state.displayName,
      "emailAddress": state.email,
      "phoneCode": countryPhone,
      "phone": int.tryParse(state.workPhone) ?? 0,
      "mobileCode": mobileCode,
      "mobile": int.tryParse(state.mobile) ?? 0,
      "openingBalance": {
        "branch": state.openingBalance['branch'],
        "currency": state.openingBalance['currency'],
        "amount": state.openingBalance['amount']?.toString() ?? "0",
      },
      "vatNumber": state.vatNumber,
      "crNum": state.crNum,
      "documents": [],
      "remark": {"remark": state.remark['remark'] ?? ""},
      "customFields": state.customFields,
      "reportingTag": state.reportingTag,
      "billingAddress": {
        // ✅ CRITICAL: Include addressId for updates (from ViewParty API)
        "addressId": state.billingAddress['addressId'],
        "attention": null,
        "countryRegion": state.billingAddress['countryRegion'] ?? "KSA",
        "buildingNumber": state.billingAddress['building'],
        "streetName": null,
        "streetAddress": state.billingAddress['streetAddress'],
        "streetAddressArabic": state.billingAddress['streetAddressArabic'],
        "city": state.billingAddress['city'],
        "cityArabic": state.billingAddress['cityArabic'],
        "state": int.tryParse("${state.billingAddress['state']}") ?? 0,
        "zipCode": state.billingAddress['zip'],
      },
      "shippingAddress": {
        // ✅ CRITICAL: Include addressId for updates (from ViewParty API)
        "addressId": state.shippingAddress['addressId'],
        "attention": state.shippingAddress['attention'],
        "countryRegion": state.shippingAddress['countryRegion'] ?? "KSA",
        "buildingNumber": state.shippingAddress['building'],
        "streetName": null,
        "streetAddress": state.shippingAddress['streetAddress'],
        "streetAddressArabic": state.shippingAddress['streetAddressArabic'],
        "city": state.shippingAddress['city'],
        "cityArabic": state.shippingAddress['cityArabic'],
        "state": int.tryParse("${state.shippingAddress['state']}") ?? 0,
        "zipCode": state.shippingAddress['zip'],
      },
      "contactPersons": [
        {
          "firstName": state.firstName,
          "lastName": state.secondName,
          "emailAddress": state.email,
          "events": [],
          "cpMobCode": mobileCode,
          "mobileNo": state.mobile,
        }
      ],
      "taxedOrganization": false,
      "governmentEntity": false,
      "sameAddressFlag": sameAsBilling,
    };

    debugPrint("📤 Update Vendor Request Body:");
    debugPrint(jsonEncode(vendorBody));

    const url =
        'http://81.208.173.149/pb-process-service/api/process/updateVendor';

    final result = await ref.read(apiServiceProvider).postApi<VendorModel>(
          url: url,
          body: vendorBody,
          fromJson: (json) => VendorModel.fromJson(json as String),
        );

    debugPrint("📥 Update Vendor Response:");
    debugPrint("Status: ${result.status}");
    debugPrint("Error: ${result.error}");
    debugPrint("Error Msg: ${result.errorMsg}");
    debugPrint("Success Msg: ${result.successMsg}");

    return result;
  }
}

final updateVendorRepoProvider = Provider<UpdateVendorRepository>((ref) {
  return UpdateVendorRepository(ref);
});
