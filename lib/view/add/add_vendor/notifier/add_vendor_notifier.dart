import 'package:payzo_books/view/add/add_vendor/model/add_vendor_model.dart';

import '../../../../import_data.dart';

class VendorFormNotifier extends StateNotifier<AddVendorModel> {
  VendorFormNotifier()
      : super(AddVendorModel(
    salutation: '',
    firstName: '',
    secondName: '',
    companyName: '',
    firstNameArabic: '',
    secondNameArabic: '',
    companyNameArabic: '',
    email: '',
    mobile: '',
    workPhone: '',
    phoneCode: '+966',
    mobileCode: '+966',
    customerType: '',
    partyType: 'VENDOR',
    displayName: '',
    vatNumber: '',
    crNum: '',
    openingBalance: {
      'branch': null,
      'currency': 1,
      'amount': null,
    },
    documents: {
      'documentType': null,
      'file': [],
      'expirydate': '2025-04-16',
      'documentNumber': null,
    },
    remark: {'remark': ''},
    reportingTag: {},
    customFields: {},
    contactPersons: [],
    sameAddressFlag: false,
    billingAddress: {
      'country': '',
      'countryRegion': '',
      'state': '',
      'stateId': '',
      'building': '',
      'street': '',
      'city': '',
      'zip': '',
      'streetAddress': '',
      'streetAddressArabic': '',
      'cityArabic': '',
    },
    shippingAddress: {
      'country': '',
      'countryRegion': '',
      'state': '',
      'stateId': '',
      'building': '',
      'street': '',
      'city': '',
      'zip': '',
      'streetAddress': '',
      'streetAddressArabic': '',
      'cityArabic': '',
    },
  ));

  /// Generic updater
  void updateField(String key, String value) {
    switch (key) {
      case 'salutation':
        state = state.copyWith(salutation: value);
        break;
      case 'firstName':
        state = state.copyWith(firstName: value);
        break;
      case 'secondName':
        state = state.copyWith(secondName: value);
        break;
      case 'companyName':
        state = state.copyWith(companyName: value, displayName: value);
        break;
      case 'firstNameArabic':
        state = state.copyWith(firstNameArabic: value);
        break;
      case 'secondNameArabic':
        state = state.copyWith(secondNameArabic: value);
        break;
      case 'companyNameArabic':
        state = state.copyWith(companyNameArabic: value, displayName: value);
        break;
      case 'email':
        state = state.copyWith(email: value);
        break;
      case 'mobile':
        state = state.copyWith(mobile: value);
        break;
      case 'workPhone':
        state = state.copyWith(workPhone: value);
        break;
      case 'customerType':
        state = state.copyWith(customerType: value);
        break;
      case 'phoneCode':
        state = state.copyWith(phoneCode: value);
        break;
      case 'mobileCode':
        state = state.copyWith(mobileCode: value);
        break;
      case 'vatNumber':
        state = state.copyWith(vatNumber: value);
        break;
      case 'crNum':
      case 'crNumber':
        state = state.copyWith(crNum: value);
        break;
    }
  }

  /// Billing address update (handles same-as-shipping)
  void updateBillingAddress(String key, dynamic value) {
    final updatedBilling = {...state.billingAddress, key: value};
    final updatedShipping = state.sameAddressFlag
        ? {...state.shippingAddress, key: value}
        : state.shippingAddress;

    state = state.copyWith(
      billingAddress: updatedBilling,
      shippingAddress: updatedShipping,
    );
  }

  void updateShippingAddress(String key, dynamic value) {
    state = state.copyWith(
      shippingAddress: {...state.shippingAddress, key: value},
    );
  }

  void updateOpeningBalanceField(String key, dynamic value) {
    state = state.copyWith(
      openingBalance: {...state.openingBalance, key: value},
    );
  }

  void updateSameAddressFlag(bool value) {
    final updatedState = state.copyWith(sameAddressFlag: value);
    if (value) {
      state = updatedState.copyWith(shippingAddress: {...state.billingAddress});
    } else {
      state = updatedState;
    }
  }

  /// Private helper to validate an address map and populate errors map.
  /// NOTE: uses underscore keys to match UI (e.g. 'billing_country', 'shipping_zip').
  void _validateAddress(Map<String, dynamic> address, String prefix,
      Map<String, String> errors) {
    // Normalize values
    final zip = (address['zip'] ?? '').toString().trim();
    final country = (address['country'] ?? '').toString().trim();
    final stateName = (address['state'] ?? '').toString().trim();
    final stateId = (address['stateId'] ?? '').toString().trim();
    final city = (address['city'] ?? '').toString().trim();
    final cityArabic = (address['cityArabic'] ?? '').toString().trim();
    final streetAddress = (address['streetAddress'] ?? '').toString().trim();
    final building = (address['building'] ?? '').toString().trim();
    final street = (address['street'] ?? '').toString().trim();

    // country required
    if (country.isEmpty) {
      errors['${prefix}_country'] = 'Country is required.';
    }

    // state or stateId required
    if (stateName.isEmpty && stateId.isEmpty) {
      errors['${prefix}_state'] = 'State is required.';
    }

    // city required
    if (city.isEmpty) {
      errors['${prefix}_city'] = 'City is required.';
    }
    // city required
    if (cityArabic.isEmpty) {
      errors['${prefix}_cityArabic'] = 'City (Arabic) is required.';
    }

    // // require at least one of streetAddress / building / street
    // if (streetAddress.isEmpty && building.isEmpty && street.isEmpty) {
    //   errors['${prefix}_addressLine'] =
    //   'Provide Street, Building or Street Address.';
    // }

    // zip if provided should be digits between 3 and 10
    if (zip.isNotEmpty) {
      final zipRegex = RegExp(r'^\d{3,10}$');
      if (!zipRegex.hasMatch(zip)) {
        errors['${prefix}_zip'] = 'Zip must be 3–10 digits.';
      }
    }
  }

  /// Validation logic — builds errors map using underscore keys.
  void validateFieldsAndUpdateState() {
    final Map<String, String> errors = {};
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^5\d{8}$');

    // Basic company validations
    if (state.companyName.trim().isEmpty) {
      errors['companyName'] = 'Company Name is required.';
    }
    if (state.companyNameArabic.trim().isEmpty) {
      errors['companyNameArabic'] = 'Company Name (Arabic) is required.';
    }

    // (optional) uncomment/email/phone validation if needed
    // if (state.email.trim().isEmpty) {
    //   errors['email'] = 'Email is required.';
    // } else if (!emailRegex.hasMatch(state.email.trim())) {
    //   errors['email'] = 'Invalid Email address.';
    // }
    // if (state.mobile.trim().isEmpty || !phoneRegex.hasMatch(state.mobile)) {
    //   errors['mobile'] = 'Invalid Mobile number.';
    // }

    // Validate billing address and shipping address.
    // Use 'billing' / 'shipping' as prefix so keys match the UI: e.g. 'billing_city'
    _validateAddress(state.billingAddress, 'billing', errors);
    _validateAddress(state.shippingAddress, 'shipping', errors);

    // Attach errors back to state
    state = state.copyWith(errors: errors);
  }

  void clearForm() {
    state = VendorFormNotifier().state;
  }
}

final vendorFormProvider =
StateNotifierProvider<VendorFormNotifier, AddVendorModel>((ref) {
  return VendorFormNotifier();
});
