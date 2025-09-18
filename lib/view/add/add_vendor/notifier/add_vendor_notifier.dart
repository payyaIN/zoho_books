import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/country_list/get_country_list_model.dart';
import 'package:payzo_books/data/models/add_vendor/get_state_list_model.dart';
import 'package:payzo_books/data/models/get_total_recievables.dart';
import 'package:payzo_books/data/repository/add_vendor/get_country_list_repository.dart';
import 'package:payzo_books/data/repository/add_vendor/get_state_list_repository.dart';
import 'package:payzo_books/data/repository/get_total_recievables_repository.dart';
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
          // ✅ Added
          mobileCode: '+966',
          // ✅ Added
          customerType: '',
          partyType: 'VENDOR',
          displayName: '',
          vatNumber: '', // ✅ Added
          crNum: '', // ✅ Added
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
            'state': '',
            'building': '',
            'street': '',
            'city': '',
            'zip': '',
            'streetAddress': '', // ✅ Added
            'streetAddressArabic': '', // ✅ Added
            'cityArabic': '', // ✅ Added
            'countryRegion': '' // ✅ Added
          },
          shippingAddress: {
            'country': '',
            'state': '',
            'building': '',
            'street': '',
            'city': '',
            'zip': '',
            'streetAddress': '', // ✅ Added
            'streetAddressArabic': '', // ✅ Added
            'cityArabic': '', // ✅ Added
            'countryRegion': '' // ✅ Added
          },
        ));

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
        state = state.copyWith(phoneCode: value); // ✅
        break;
      case 'mobileCode':
        state = state.copyWith(mobileCode: value); // ✅
        break;
      case 'vatNumber':
        state = state.copyWith(vatNumber: value); // ✅ Added
        break;
      case 'crNum':
        state = state.copyWith(crNum: value); // ✅ Added
        break;
    }
  }

  void updateBillingAddress(String key, String value) {
    final updatedBilling = {...state.billingAddress, key: value};
    final updatedShipping = state.sameAddressFlag
        ? {...state.shippingAddress, key: value}
        : state.shippingAddress;

    state = state.copyWith(
      billingAddress: updatedBilling,
      shippingAddress: updatedShipping,
    );
  }

  void updateShippingAddress(String key, String value) {
    state = state.copyWith(
      shippingAddress: {...state.shippingAddress, key: value},
    );
  }

  void updateContactPersons(List<Map<String, dynamic>> list) {
    state = state.copyWith(contactPersons: list);
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
    if (state.firstName.trim().isEmpty) {
      errors['firstNameArabic'] = 'First Name is required.';
    }
    if (state.secondName.trim().isEmpty) {
      errors['secondNameArabic'] = 'Last Name is required.';
    }
    if (state.companyName.trim().isEmpty) {
      errors['companyNameArabic'] = 'Company Name is required.';
    }
    if (state.email.trim().isEmpty) {
      errors['email'] = 'Email is required.';
    } else if (!emailRegex.hasMatch(state.email.trim())) {
      errors['email'] = 'Please enter a valid email address.';
    }

    final mobile = state.mobile.trim();
    if (mobile.isEmpty) {
      errors['mobile'] = 'Mobile number is required.';
    } else if (!phoneRegex.hasMatch(mobile)) {
      errors['mobile'] = 'Invalid Mobile number';
    }

    final workPhone = state.workPhone.trim();
    if (workPhone.isNotEmpty && !phoneRegex.hasMatch(workPhone)) {
      errors['workPhone'] = 'Invalid Work phone';
    }

    if (state.billingAddress['country']?.trim().isEmpty ?? true) {
      errors['billing_country'] = 'Country is required.';
    }
    if (state.billingAddress['building']?.trim().isEmpty ?? true) {
      errors['billing_building'] = 'Building Number is required.';
    }
    if (state.billingAddress['state']?.trim().isEmpty ?? true) {
      errors['billing_state'] = 'State is required.';
    }
    if (state.billingAddress['street']?.trim().isEmpty ?? true) {
      errors['billing_street'] = 'Street is required.';
    }
    if (state.billingAddress['city']?.trim().isEmpty ?? true) {
      errors['billing_city'] = 'City is required.';
    }
    if (state.billingAddress['zip']?.trim().isEmpty ?? true) {
      errors['billing_zip'] = 'Zip is required.';
    }
    if (state.billingAddress['streetAddress']?.trim().isEmpty ?? true) {
      errors['billing_streetAddress'] = 'Street Address is required.';
    }
    if (state.billingAddress['cityArabic']?.trim().isEmpty ?? true) {
      errors['billing_cityArabic'] = 'City (Arabic) is required.';
    }

    if (state.shippingAddress['country']?.trim().isEmpty ?? true) {
      errors['shipping_country'] = 'Country is required.';
    }
    if (state.shippingAddress['building']?.trim().isEmpty ?? true) {
      errors['shipping_building'] = 'Building Number is required.';
    }
    if (state.shippingAddress['state']?.trim().isEmpty ?? true) {
      errors['shipping_state'] = 'State is required.';
    }
    if (state.shippingAddress['street']?.trim().isEmpty ?? true) {
      errors['shipping_street'] = 'Street is required.';
    }
    if (state.shippingAddress['city']?.trim().isEmpty ?? true) {
      errors['shipping_city'] = 'City is required.';
    }
    if (state.shippingAddress['zip']?.trim().isEmpty ?? true) {
      errors['shipping_zip'] = 'Zip is required.';
    }
    if (state.shippingAddress['streetAddress']?.trim().isEmpty ?? true) {
      errors['shipping_streetAddress'] = 'Street Address is required.';
    }
    if (state.shippingAddress['cityArabic']?.trim().isEmpty ?? true) {
      errors['shipping_cityArabic'] = 'City (Arabic) is required.';
    }
    if (state.crNum.trim().isEmpty) {
      errors['crNum'] = 'CR Number is required.';
    }

    state = state.copyWith(errors: errors);
  }

  void clearForm() {
    state = AddVendorModel(
      salutation: '',
      firstName: '',
      secondName: '',
      companyName: '',
      email: '',
      mobile: '',
      workPhone: '',
      phoneCode: '+966',
      // ✅
      mobileCode: '+966',
      // ✅
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
        'state': '',
        'building': '',
        'street': '',
        'city': '',
        'zip': '',
        'streetAddress': '',
        'streetAddressArabic': '',
        'cityArabic': '',
        'countryRegion': ''
      },
      shippingAddress: {
        'country': '',
        'state': '',
        'building': '',
        'street': '',
        'city': '',
        'zip': '',
        'streetAddress': '',
        'streetAddressArabic': '',
        'cityArabic': '',
        'countryRegion': ''
      },
      firstNameArabic: '',
      secondNameArabic: '',
      companyNameArabic: '',
    );
  }

  // Accessors
  String get billingCountry => state.billingAddress['country'] ?? '';

  String get billingState => state.billingAddress['state'] ?? '';

  String get billingBuilding => state.billingAddress['building'] ?? '';

  String get billingStreet => state.billingAddress['street'] ?? '';

  String get billingCity => state.billingAddress['city'] ?? '';

  String get billingZip => state.billingAddress['zip'] ?? '';

  String get billingStreetAddress => state.billingAddress['streetAddress'] ?? '';

  String get billingStreetAddressArabic => state.billingAddress['streetAddressArabic'] ?? '';

  String get billingCityArabic => state.billingAddress['cityArabic'] ?? '';

  String get shippingCountry => state.shippingAddress['country'] ?? '';

  String get shippingState => state.shippingAddress['state'] ?? '';

  String get shippingBuilding => state.shippingAddress['building'] ?? '';

  String get shippingStreet => state.shippingAddress['street'] ?? '';

  String get shippingCity => state.shippingAddress['city'] ?? '';

  String get shippingZip => state.shippingAddress['zip'] ?? '';

  String get shippingStreetAddress => state.shippingAddress['streetAddress'] ?? '';

  String get shippingStreetAddressArabic => state.shippingAddress['streetAddressArabic'] ?? '';

  String get shippingCityArabic => state.shippingAddress['cityArabic'] ?? '';
}

final vendorFormProvider =
    StateNotifierProvider<VendorFormNotifier, AddVendorModel>((ref) {
  return VendorFormNotifier();
});

final getCountryList = FutureProvider<GetCountryListModel>((ref) async {
  final repository = ref.watch(getCountryListProvider);
  return repository.fetchData();
});
