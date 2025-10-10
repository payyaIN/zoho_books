import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/data/models/add_customer/add_customer_api_model.dart';
import 'package:payzo_books/view/add/add_customer/notifiers/customer_form_provider.dart';

import '../../../import_data.dart';

final countryCodeCustomerProvider = StateProvider<String>((ref) => '179');
final countryPhoneCustomerProvider = StateProvider<String>((ref) => '+966');
final countryCodeCustomerMobileProvider = StateProvider<String>((ref) => '179');
final countryPhoneCustomerMobileProvider = StateProvider<String>((ref) => '+966');
final countryFlagCustomerProvider = StateProvider<String>((ref) => 'sa');
final countryFlagCustomerMobileProvider = StateProvider<String>((ref) => 'sa');

class RegisterCustomerRepository {
  final Ref ref;

  RegisterCustomerRepository(this.ref);

  Future<AddCustomerApiModel> registerCustomer() async {
    final state = ref.read(customerFormProvider);
    debugPrint("🧾 Customer State: ${state.toJson()}");

    final customerBody = {
      "primaryContact": {
        "firstName": state.firstName,
        "lastName": state.secondName,
      },
      "customerType": state.customerType.toUpperCase(),
      "partyType": "CUSTOMER",
      "companyName": state.companyName,
      "displayName": state.companyName,
      "emailAddress": state.email,
      "phoneCode": state.phoneCode,
      "phone": state.workPhone,
      "mobileCode": state.mobileCode,
      "mobile": state.mobile,
      "openingBalance": {
        "branch": state.branchId,
        "currency": state.currencyId,
        "amount": state.openingAmount.toString(), // always string
      },
      "documents": {
        "documentType": null,
        "file": [],
        "expirydate": state.expiryDate,
        "documentNumber": null,
      },
      "remark": {
        "remark": state.remark,
      },
      "customFields": {},
      "reportingTag": {},
      "billingAddress": {
        "countryRegion":state.billingAddress['country'],
        "buildingNumber": state.billingAddress['building'],
        "streetName": null,
        "streetAddress": state.billingAddress['street'],
        "city": state.billingAddress['city'],
        "state": state.billingAddress['state'],
        "zipCode": state.billingAddress['zip'],
      },
      "shippingAddress": {
        "countryRegion": state.shippingAddress['country'],
        "buildingNumber": state.shippingAddress['building'],
        "streetName": null,
        "streetAddress": state.shippingAddress['street'],
        "city": state.shippingAddress['city'],
        "state": state.shippingAddress['state'],
        "zipCode": state.shippingAddress['zip'],
      },
      "contactPersons": [
        {
          "firstName": state.firstName,
          "lastName": state.secondName,
          "emailAddress": state.email,
          "cpMobCode": state.mobileCode,
          "mobileNo": state.mobile,
          "events": []
        }
      ],
      "sameAddressFlag": true
    };

    const url = 'http://81.208.173.149/pb-process-service/api/process/register';

    return await ref.read(apiServiceProvider).postApi<AddCustomerApiModel>(
      url: url,
      body: customerBody,
      fromJson: (json) => AddCustomerApiModel.fromJson(json),
    );
  }
}

final registerCustomerRepoProvider = Provider<RegisterCustomerRepository>((ref) {
  return RegisterCustomerRepository(ref);
});

final openingBalanceProvider = StateProvider<String>((ref) {
  return 'SAR';
});

final openingAmountProvider = StateProvider<String>((ref) {
  return 'Tap to Select';
});
