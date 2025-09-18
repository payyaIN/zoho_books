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
    final countryPhone = ref.read(countryPhoneProvider); // Returns a String
    final sameAsBilling = ref.read(sameAsBillingToggleProvider);
    final mobileCode = ref.read(countryPhoneMobileProvider); // Returns a String

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
        "amount": state.openingBalance['amount'],
      },
      "vatNumber": state.vatNumber,
      "documents": state.documents,
      "remark": {
        "remark": state.remark ?? "",
      },
      "customFields": state.customFields,
      "reportingTag": state.reportingTag,
      "billingAddress": {
        "countryRegion": state.billingAddress['country'],
        "buildingNumber": state.billingAddress['building'],
        "streetName": state.billingAddress['street'],
        "streetAddress": state.billingAddress['streetAddress'],
        "streetAddressArabic": state.billingAddress['streetAddressArabic'],
        "city": state.billingAddress['city'],
        "cityArabic": state.billingAddress['cityArabic'],
        "state": state.billingAddress['state'],
        "zipCode": state.billingAddress['zip'],
      },
      "shippingAddress": {
        "countryRegion": state.shippingAddress['country'],
        "buildingNumber": state.shippingAddress['building'],
        "streetName": state.shippingAddress['street'],
        "streetAddress": state.shippingAddress['streetAddress'],
        "streetAddressArabic": state.shippingAddress['streetAddressArabic'],
        "city": state.shippingAddress['city'],
        "cityArabic": state.shippingAddress['cityArabic'],
        "state": state.shippingAddress['state'],
        "zipCode": state.shippingAddress['zip'],
      },
      "contactPersons": [
        {
          "firstName": state.firstName,
          "lastName": state.secondName,
          "emailAddress": state.email,
          "cpMobCode": mobileCode,
          "mobileNo": int.tryParse(state.mobile) ?? 0,
          "events": []
        }
      ],
      "sameAddressFlag": sameAsBilling,
    };

    const url =
        'http://158.101.247.195/pb-process-service/api/process/register';

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
