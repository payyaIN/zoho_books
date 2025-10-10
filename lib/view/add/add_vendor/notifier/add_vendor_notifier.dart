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
      'country': '',        // UI display name
      'countryRegion': '',  // API code (KSA)
      'state': '',          // UI display name
      'stateId': '',        // API ID
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

  /// Validation logic
  void validateFieldsAndUpdateState() {
    final Map<String, String> errors = {};
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^5\d{8}$');

    if (state.firstName.trim().isEmpty) {
      errors['firstName'] = 'First Name is required.';
    }
    if (state.secondName.trim().isEmpty) {
      errors['secondName'] = 'Last Name is required.';
    }
    if (state.companyName.trim().isEmpty) {
      errors['companyName'] = 'Company Name is required.';
    }
    if (state.firstNameArabic.trim().isEmpty) {
      errors['firstNameArabic'] = 'First Name (Arabic) is required.';
    }
    if (state.secondNameArabic.trim().isEmpty) {
      errors['secondNameArabic'] = 'Last Name (Arabic) is required.';
    }
    if (state.companyNameArabic.trim().isEmpty) {
      errors['companyNameArabic'] = 'Company Name (Arabic) is required.';
    }
    if (state.email.trim().isEmpty) {
      errors['email'] = 'Email is required.';
    } else if (!emailRegex.hasMatch(state.email.trim())) {
      errors['email'] = 'Invalid Email address.';
    }
    if (state.mobile.trim().isEmpty || !phoneRegex.hasMatch(state.mobile)) {
      errors['mobile'] = 'Invalid Mobile number.';
    }
    if (state.crNum.trim().isEmpty) {
      errors['crNum'] = 'CR Number is required.';
    }
    if (state.vatNumber.trim().isEmpty) {
      errors['vatNumber'] = 'VAT Number is required.';
    }

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
