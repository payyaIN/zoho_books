import 'package:payzo_books/data/models/add_vendor/add_vendor_model.dart';
import 'package:payzo_books/data/repository/add_vendor/get_state_list_repository.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_vendor/add_vendor.dart';
import 'package:payzo_books/view/add/add_vendor/notifier/add_vendor_notifier.dart';
class RegisterVendorRepository {
  final Ref ref;

  RegisterVendorRepository(this.ref);

  Future<RegisterVendorResponse> registerVendor() async {
    final state = ref.read(vendorFormProvider);
    final countryPhone = ref.read(countryPhoneProvider);
    final sameAsBilling = ref.read(sameAsBillingToggleProvider);
    final mobileCode = ref.read(countryPhoneMobileProvider);

    debugPrint("🔍 Vendor State: ${state.toJson()}");

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
      "companyName": state.companyName,
      "companyNameArabic": state.companyNameArabic,
      "displayName": state.displayName,
      "emailAddress": state.email,
      "phoneCode": countryPhone,
      "phone": int.tryParse(state.workPhone) ?? 0,
      "mobileCode": mobileCode,
      "mobile": int.tryParse(state.mobile) ?? 0,
      "openingBalance": {
        "branch": state.openingBalance['branch'],
        "currency": state.openingBalance['currency'],
        "amount": state.openingBalance['amount']?.toString() ?? "0", // ✅ string
      },
      "vatNumber": state.vatNumber,
      "crNum": state.crNum, // ✅ required
      "documents": [], // ✅ must be array
      "remark": {"remark": state.remark['remark'] ?? ""},
      "customFields": state.customFields,
      "reportingTag": state.reportingTag,
      "billingAddress": {
        "countryRegion": state.billingAddress['countryRegion'] ?? "KSA", // ✅ code
        "buildingNumber": state.billingAddress['building'],
        "streetName": null,
        "streetAddress": state.billingAddress['streetAddress'],
        "streetAddressArabic": state.billingAddress['streetAddressArabic'],
        "city": state.billingAddress['city'],
        "cityArabic": state.billingAddress['cityArabic'],
        "state": int.tryParse("${state.billingAddress['state']}") ?? 0,  // ✅ id
        "zipCode": state.billingAddress['zip'],
      },
      "shippingAddress": {
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
          "mobileNo": state.mobile, // ✅ string
        }
      ],
      "sameAddressFlag": sameAsBilling,
    };

    const url =
        'http://81.208.173.149/pb-process-service/api/process/register';

    return await ref.read(apiServiceProvider).postApi<RegisterVendorResponse>(
      url: url,
      body: vendorBody,
      fromJson: (json) => RegisterVendorResponse.fromJson(json),
    );
  }
}

final registerVendorRepoProvider = Provider<RegisterVendorRepository>((ref) {
  return RegisterVendorRepository(ref);
});
