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
  /// Validation logic — builds errors map using underscore keys.
  /// Validation logic — builds errors map using underscore keys.
  void validateFieldsAndUpdateState() {
    final Map<String, String> errors = {};
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^5\d{8}$'); // Saudi mobile: 9 digits starting with 5
    final saudiZipRegex = RegExp(r'^[1-9]\d{4}$'); // Saudi ZIP: 5 digits, cannot start with 0

    // ---------- Basic company validations (kept) ----------
    if (state.companyName.trim().isEmpty) {
      errors['companyName'] = 'Company Name is required.';
    }
    if (state.companyNameArabic.trim().isEmpty) {
      errors['companyNameArabic'] = 'Company Name (Arabic) is required.';
    }

    // ---------- Email (optional) ----------
    if (state.email.trim().isNotEmpty && !emailRegex.hasMatch(state.email.trim())) {
      errors['email'] = 'Invalid Email address.';
    }

    // ---------- OPTIONAL phone/mobile validation ----------
    // If empty -> no error. If typed -> must match pattern.
    final mobile = state.mobile.trim();
    final work = state.workPhone.trim();
    if (mobile.isNotEmpty && !phoneRegex.hasMatch(mobile)) {
      errors['mobile'] = 'Invalid Mobile number.';
    }
    if (work.isNotEmpty && !phoneRegex.hasMatch(work)) {
      errors['workPhone'] = 'Invalid Phone number.';
    }

    // ---------- VAT & CR (kept) ----------
    final vatRegex = RegExp(r'^\d{15}$'); // VAT 15 digits
    final crRegex = RegExp(r'^\d{10}$'); // CR 10 digits

    final vat = state.vatNumber.trim();
    final cr = state.crNum.trim();

    if (vat.isNotEmpty && !vatRegex.hasMatch(vat)) {
      errors['vatNumber'] = 'Invalid VAT number. Expected 15 digits.';
    }

    if (cr.isNotEmpty && !crRegex.hasMatch(cr)) {
      final msg = 'Invalid CR number. Expected 10 digits.';
      errors['crNum'] = msg;
      errors['crNumber'] = msg; // keep UI controller key mapping
    }

    // ---------- Building number: exactly 5 digits (billing & shipping) ----------
    final buildingRegex = RegExp(r'^\d{5}$');
    final billingBuilding = (state.billingAddress['building'] ?? '').toString().trim();
    final shippingBuilding = (state.shippingAddress['building'] ?? '').toString().trim();

    if (billingBuilding.isNotEmpty && !buildingRegex.hasMatch(billingBuilding)) {
      errors['billing_building'] = 'Building number must be exactly 5 digits.';
    }
    if (shippingBuilding.isNotEmpty && !buildingRegex.hasMatch(shippingBuilding)) {
      errors['shipping_building'] = 'Building number must be exactly 5 digits.';
    }

    // ---------- Min 3 characters rule for typed text fields ----------
    // Top-level text fields (if typed) must be at least 3 chars
    final topTextFields = <String, String>{
      'salutation': state.salutation,
      'firstName': state.firstName,
      'secondName': state.secondName,
      'companyName': state.companyName,
      'firstNameArabic': state.firstNameArabic,
      'secondNameArabic': state.secondNameArabic,
      'companyNameArabic': state.companyNameArabic,
      'displayName': state.displayName,
    };

    topTextFields.forEach((key, val) {
      final v = val.trim();
      if (v.isNotEmpty && v.length < 3) {
        // companyName already has required error above; this ensures min-length otherwise
        errors[key] = 'Must be at least 3 characters.';
      }
    });

    // Document number must be at least 3 chars if typed
    final docNumber = (state.documents['documentNumber'] ?? '').toString().trim();
    if (docNumber.isNotEmpty && docNumber.length < 3) {
      errors['documents_documentNumber'] = 'Document number must be at least 3 characters.';
    }

    // Opening balance amount: numeric and non-negative if typed
    final openingAmount = (state.openingBalance['amount'] ?? '').toString().trim();
    if (openingAmount.isNotEmpty) {
      final parsed = double.tryParse(openingAmount);
      if (parsed == null) {
        errors['openingBalance_amount'] = 'Opening amount must be a number.';
      } else if (parsed < 0) {
        errors['openingBalance_amount'] = 'Opening amount cannot be negative.';
      }
    }

    // ---------- Min length for billing & shipping text fields ----------
    // Exclude 'zip' and 'stateId' (zip handled separately below, state/stateId handled in _validateAddress)
    final excludedKeys = <String>{'zip', 'stateId'};
    void checkMinLength(Map<String, dynamic> addr, String prefix) {
      addr.forEach((k, v) {
        if (excludedKeys.contains(k)) return;
        final txt = (v ?? '').toString().trim();
        if (txt.isNotEmpty && txt.length < 3) {
          errors['${prefix}_$k'] = 'Must be at least 3 characters.';
        }
      });
    }
    checkMinLength(state.billingAddress, 'billing');
    checkMinLength(state.shippingAddress, 'shipping');

    // ---------- Run original address validations (this will add keys like billing_country, billing_state, billing_city, billing_cityArabic, billing_zip, etc.) ----------
    _validateAddress(state.billingAddress, 'billing', errors);
    _validateAddress(state.shippingAddress, 'shipping', errors);

    // ---------- Override/ensure ZIP uses Saudi ZIP rule (if user typed it) ----------
    final billingZip = (state.billingAddress['zip'] ?? '').toString().trim();
    final shippingZip = (state.shippingAddress['zip'] ?? '').toString().trim();

    if (billingZip.isNotEmpty && !saudiZipRegex.hasMatch(billingZip)) {
      errors['billing_zip'] = 'Invalid Saudi ZIP code (must be 5 digits and cannot start with 0).';
    }
    if (shippingZip.isNotEmpty && !saudiZipRegex.hasMatch(shippingZip)) {
      errors['shipping_zip'] = 'Invalid Saudi ZIP code (must be 5 digits and cannot start with 0).';
    }

    // ---------- Finish: write errors back to state ----------
    state = state.copyWith(errors: errors);
  }


  /// Clear billing country (and related state/stateId). If sameAddressFlag is true,
  /// shipping will be cleared too so UI stays in sync.
  void clearBillingCountry() {
    final updatedBilling = Map<String, dynamic>.from(state.billingAddress)
      ..['country'] = ''
      ..['countryRegion'] = ''
      ..['state'] = ''
      ..['stateId'] = '';

    // If billing==shipping, keep them synced
    final updatedShipping = state.sameAddressFlag
        ? Map<String, dynamic>.from(updatedBilling)
        : Map<String, dynamic>.from(state.shippingAddress);

    // copy errors and remove billing keys
    final newErrors = Map<String, String>.from(state.errors);
    newErrors.remove('billing_country');
    newErrors.remove('billing_state');

    state = state.copyWith(
      billingAddress: updatedBilling,
      shippingAddress: updatedShipping,
      errors: newErrors,
    );
  }

  /// Clear only billing state (state + stateId). If sameAddressFlag is true,
  /// clears shipping state too.
  void clearBillingState() {
    final updatedBilling = Map<String, dynamic>.from(state.billingAddress)
      ..['state'] = ''
      ..['stateId'] = '';

    final updatedShipping = state.sameAddressFlag
        ? (Map<String, dynamic>.from(state.shippingAddress)
      ..['state'] = ''
      ..['stateId'] = '')
        : Map<String, dynamic>.from(state.shippingAddress);

    final newErrors = Map<String, String>.from(state.errors);
    newErrors.remove('billing_state');

    state = state.copyWith(
      billingAddress: updatedBilling,
      shippingAddress: updatedShipping,
      errors: newErrors,
    );
  }

  /// Clear shipping country (and related state/stateId). If sameAddressFlag is true,
  /// billing will be cleared too so UI stays in sync.
  void clearShippingCountry() {
    final updatedShipping = Map<String, dynamic>.from(state.shippingAddress)
      ..['country'] = ''
      ..['countryRegion'] = ''
      ..['state'] = ''
      ..['stateId'] = '';

    final updatedBilling = state.sameAddressFlag
        ? Map<String, dynamic>.from(updatedShipping)
        : Map<String, dynamic>.from(state.billingAddress);

    final newErrors = Map<String, String>.from(state.errors);
    newErrors.remove('shipping_country');
    newErrors.remove('shipping_state');

    state = state.copyWith(
      shippingAddress: updatedShipping,
      billingAddress: updatedBilling,
      errors: newErrors,
    );
  }

  /// Clear only shipping state (state + stateId). If sameAddressFlag is true,
  /// clears billing state too.
  void clearShippingState() {
    final updatedShipping = Map<String, dynamic>.from(state.shippingAddress)
      ..['state'] = ''
      ..['stateId'] = '';

    final updatedBilling = state.sameAddressFlag
        ? (Map<String, dynamic>.from(state.billingAddress)
      ..['state'] = ''
      ..['stateId'] = '')
        : Map<String, dynamic>.from(state.billingAddress);

    final newErrors = Map<String, String>.from(state.errors);
    newErrors.remove('shipping_state');

    state = state.copyWith(
      shippingAddress: updatedShipping,
      billingAddress: updatedBilling,
      errors: newErrors,
    );
  }

  /// Convenience: clear both country & state for billing (and shipping when sameAddressFlag is true)
  void clearBillingLocation() {
    clearBillingCountry();
  }

  /// Convenience: clear both country & state for shipping (and billing when sameAddressFlag is true)
  void clearShippingLocation() {
    clearShippingCountry();
  }


  void clearForm() {
    state = VendorFormNotifier().state;
  }
}

final vendorFormProvider =
StateNotifierProvider<VendorFormNotifier, AddVendorModel>((ref) {
  return VendorFormNotifier();
});
