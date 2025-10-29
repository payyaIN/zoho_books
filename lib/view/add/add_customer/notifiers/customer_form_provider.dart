// customer_form_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_customer/add_customer_model.dart';

import '../../../../import_data.dart';

/// Provider that stores the latest validation errors
final customerErrorsProvider = StateProvider<Map<String, String>>((ref) => {});

class CustomerFormNotifier extends StateNotifier<AddCustomerModel> {
  final Ref ref;
  CustomerFormNotifier(this.ref)
      : super(AddCustomerModel(
    primaryContact: PrimaryContact(firstName: '', lastName: ''),
    primaryContactArabic:
    PrimaryContactArabic(firstNameArabic: '', lastNameArabic: ''),
    customerType: 'BUSINESS',
    partyType: 'CUSTOMER',
    taxedOrganization: true,
    governmentEntity: true,
    companyName: '',
    companyNameArabic: '',
    displayName: '',
    emailAddress: '',
    phoneCode: '+966',
    phone: '',
    mobileCode: '+966',
    mobile: '',
    openingBalance: OpeningBalance(branch: null, currency: 1, amount: null),
    vatNumber: '',
    crNum: '',
    documents: [],
    remark: Remark(remark: ''),
    customFields: {},
    reportingTag: {},
    billingAddress: BillingAddress(
      countryRegion: '',
      buildingNumber: '',
      streetName: null,
      streetAddress: '',
      streetAddressArabic: '',
      city: '',
      cityArabic: '',
      state: null,
      zipCode: '',
    ),
    shippingAddress: ShippingAddress(
      countryRegion: '',
      buildingNumber: '',
      streetName: null,
      streetAddress: '',
      streetAddressArabic: '',
      city: '',
      cityArabic: '',
      state: null,
      zipCode: '',
    ),
    contactPersons: [],
    sameAddressFlag: false,
  ));

  // ----------------------
  // Top-level string updates
  // ----------------------
  void updateField(String key, String value) {
    switch (key) {
    // Primary contact (English)
      case 'firstName':
        state = state.copyWith(
          primaryContact: (state.primaryContact ?? PrimaryContact()).copyWith(
            firstName: value,
          ),
        );
        break;
      case 'secondName':
        state = state.copyWith(
          primaryContact: (state.primaryContact ?? PrimaryContact()).copyWith(
            lastName: value,
          ),
        );
        break;

    // Primary contact (Arabic)
      case 'firstNameArabic':
        state = state.copyWith(
          primaryContactArabic:
          (state.primaryContactArabic ?? PrimaryContactArabic()).copyWith(
            firstNameArabic: value,
          ),
        );
        break;
      case 'secondNameArabic':
        state = state.copyWith(
          primaryContactArabic:
          (state.primaryContactArabic ?? PrimaryContactArabic()).copyWith(
            lastNameArabic: value,
          ),
        );
        break;

    // Company / display
      case 'companyName':
        state = state.copyWith(companyName: value, displayName: value);
        break;
      case 'companyNameArabic':
        state = state.copyWith(companyNameArabic: value);
        break;
      case 'displayName':
        state = state.copyWith(displayName: value);
        break;

    // Email / phones
      case 'email':
      case 'emailAddress':
        state = state.copyWith(emailAddress: value);
        break;
      case 'phone':
      case 'workPhone':
        state = state.copyWith(phone: value);
        break;
      case 'phoneCode':
        state = state.copyWith(phoneCode: value);
        break;
      case 'mobile':
        state = state.copyWith(mobile: value);
        break;
      case 'mobileCode':
        state = state.copyWith(mobileCode: value);
        break;

    // VAT / CR
      case 'vatNumber':
        state = state.copyWith(vatNumber: value);
        break;
      case 'crNum':
        state = state.copyWith(crNum: value);
        break;

    // Opening balance: amount (string/dynamic), currencyId (num), branchId (dynamic)
      case 'openingAmount':
        final ob = state.openingBalance ?? OpeningBalance(branch: null, currency: 1, amount: null);
        final updatedOb = ob.copyWith(amount: value);
        state = state.copyWith(openingBalance: updatedOb);
        break;
      case 'currencyId':
        final ob2 = state.openingBalance ?? OpeningBalance(branch: null, currency: 1, amount: null);
        final num? currencyNum = num.tryParse(value);
        final updatedOb2 = ob2.copyWith(currency: currencyNum ?? ob2.currency);
        state = state.copyWith(openingBalance: updatedOb2);
        break;
      case 'branchId':
        final ob3 = state.openingBalance ?? OpeningBalance(branch: null, currency: 1, amount: null);
        final updatedOb3 = ob3.copyWith(branch: value);
        state = state.copyWith(openingBalance: updatedOb3);
        break;

      default:
        debugPrint('Unrecognized top-level updateField key: $key');
    }
  }

  // ----------------------
  // Billing / Shipping updates (map UI keys -> model fields)
  // ----------------------
  void updateBillingAddress(String key, String value) {
    final cur = state.billingAddress ?? BillingAddress();
    BillingAddress updated = cur;
    switch (key) {
      case 'country':
        updated = cur.copyWith(countryRegion: value);
        break;
      case 'building':
        updated = cur.copyWith(buildingNumber: value);
        break;
      case 'street':
        updated = cur.copyWith(streetAddress: value);
        break;
      case 'streetArabic':
        updated = cur.copyWith(streetAddressArabic: value);
        break;
      case 'city':
        updated = cur.copyWith(city: value);
        break;
      case 'cityArabic':
        updated = cur.copyWith(cityArabic: value);
        break;
      case 'state':
      // Try parse numeric id — if not numeric, keep previous numeric id (avoid assigning String to num?)
        final num? stateNum = num.tryParse(value);
        updated = cur.copyWith(state: stateNum ?? cur.state);
        break;
      case 'zip':
        updated = cur.copyWith(zipCode: value);
        break;
      default:
        debugPrint('Unknown billing key: $key');
    }
    state = state.copyWith(billingAddress: updated);
  }

  void updateShippingAddress(String key, String value) {
    final cur = state.shippingAddress ?? ShippingAddress();
    ShippingAddress updated = cur;
    switch (key) {
      case 'country':
        updated = cur.copyWith(countryRegion: value);
        break;
      case 'building':
        updated = cur.copyWith(buildingNumber: value);
        break;
      case 'street':
        updated = cur.copyWith(streetAddress: value);
        break;
      case 'streetArabic':
        updated = cur.copyWith(streetAddressArabic: value);
        break;
      case 'city':
        updated = cur.copyWith(city: value);
        break;
      case 'cityArabic':
        updated = cur.copyWith(cityArabic: value);
        break;
      case 'state':
        final num? stateNum = num.tryParse(value);
        updated = cur.copyWith(state: stateNum ?? cur.state);
        break;
      case 'zip':
        updated = cur.copyWith(zipCode: value);
        break;
      default:
        debugPrint('Unknown shipping key: $key');
    }
    state = state.copyWith(shippingAddress: updated);
  }

  // ----------------------
  // sameAddressFlag helper
  // ----------------------
  void updateSameAddressFlag(bool value) {
    if (value) {
      final b = state.billingAddress ?? BillingAddress();
      final newShipping = ShippingAddress(
        countryRegion: b.countryRegion,
        buildingNumber: b.buildingNumber,
        streetName: b.streetName,
        streetAddress: b.streetAddress,
        streetAddressArabic: b.streetAddressArabic,
        city: b.city,
        cityArabic: b.cityArabic,
        state: b.state,
        zipCode: b.zipCode,
      );
      state = state.copyWith(sameAddressFlag: true, shippingAddress: newShipping);
    } else {
      // When turning off, clear shipping fields (but keep billing as-is)
      state = state.copyWith(
        sameAddressFlag: false,
        shippingAddress: ShippingAddress(
          countryRegion: '',
          buildingNumber: '',
          streetName: null,
          streetAddress: '',
          streetAddressArabic: '',
          city: '',
          cityArabic: '',
          state: null,
          zipCode: '',
        ),
      );
    }
  }

  // ----------------------
  // Field-specific helper validators
  // ----------------------
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidKsaMobile(String mobile) {
    // KSA mobile: 9 digits starting with 5 (e.g. 5XXXXXXXX)
    final phoneRegex = RegExp(r'^5\d{8}$');
    return phoneRegex.hasMatch(mobile);
  }

  bool _isValidWorkPhone(String phone) {
    // accept 6-15 digits for landline/work numbers (loose)
    final regex = RegExp(r'^\d{6,15}$');
    return regex.hasMatch(phone);
  }

  bool _isValidVat(String vat) {
    // simple numeric check: 10-15 digits
    final regex = RegExp(r'^\d{10,15}$');
    return regex.hasMatch(vat);
  }

  bool _isValidCr(String cr) {
    // typical CR number length (Saudi) is 10 digits — adjust if needed
    final regex = RegExp(r'^\d{10}$');
    return regex.hasMatch(cr);
  }

  bool _isPositiveNumber(String s) {
    final d = double.tryParse(s);
    if (d == null) return false;
    return d > 0;
  }

  // ----------------------
  // Validation: builds errors map and writes to customerErrorsProvider
  // Returns true if valid (no errors), false if there are errors
  // ----------------------
  bool validateFields() {
    final errors = <String, String>{};

    // Customer type required
    if ((state.customerType ?? '').toString().trim().isEmpty) {
      errors['customerType'] = 'Customer type is required';
    }

    // Primary contact
    final firstName = state.primaryContact?.firstName ?? '';
    final lastName = state.primaryContact?.lastName ?? '';
    // if (firstName.trim().isEmpty) {
    //   errors['firstName'] = 'First name is required';
    // }
    // if (lastName.trim().isEmpty) {
    //   errors['secondName'] = 'Last name is required';
    // }

    // Primary contact (Arabic) — optional? your earlier spec required Arabic but user later listed companyNameArabic required
    // We'll validate Arabic names if present but not make them strictly required here (you can toggle if needed).
    // (keeping them optional to avoid breaking UX unless you want them mandatory)
    // If you want required, uncomment following lines:
    // if ((state.primaryContactArabic?.firstNameArabic ?? '').trim().isEmpty) {
    //   errors['firstNameArabic'] = 'First name (Arabic) is required';
    // }
    // if ((state.primaryContactArabic?.lastNameArabic ?? '').trim().isEmpty) {
    //   errors['secondNameArabic'] = 'Last name (Arabic) is required';
    // }

    // Company fields REQUIRED per request
    if ((state.companyName ?? '').trim().isEmpty) {
      errors['companyName'] = 'Company name is required';
    }
    if ((state.companyNameArabic ?? '').trim().isEmpty) {
      errors['companyNameArabic'] = 'Company name (Arabic) is required';
    }

    // // Email (still required by previous logic)
    // final email = (state.emailAddress ?? '').trim();
    // if (email.isEmpty) {
    //   errors['emailAddress'] = 'Email is required';
    // } else if (!_isValidEmail(email)) {
    //   errors['emailAddress'] = 'Invalid email';
    // }

    // // Mobile (required)
    // final mobile = (state.mobile ?? '').trim();
    // if (mobile.isEmpty) {
    //   errors['mobile'] = 'Mobile number is required';
    // } else if (!_isValidKsaMobile(mobile)) {
    //   errors['mobile'] = 'Invalid mobile number';
    // }

    // Work phone — optional but validated if provided
    final workPhone = (state.phone ?? '').trim();
    if (workPhone.isNotEmpty && !_isValidWorkPhone(workPhone)) {
      errors['workPhone'] = 'Invalid phone number';
    }

    // VAT & CR — required if taxedOrganization == true
    final vat = (state.vatNumber ?? '').trim();
    final cr = (state.crNum ?? '').trim();
    final taxed = state.taxedOrganization ?? false;
    if (taxed) {
      if (vat.isEmpty) {
        errors['vatNumber'] = 'VAT number is required';
      } else if (!_isValidVat(vat)) {
        errors['vatNumber'] = 'Invalid VAT number';
      }
      if (cr.isEmpty) {
        errors['crNum'] = 'Customer CR is required';
      } else if (!_isValidCr(cr)) {
        errors['crNum'] = 'Invalid CR number';
      }
    } else {
      // optional validation when provided
      if (vat.isNotEmpty && !_isValidVat(vat)) {
        errors['vatNumber'] = 'Invalid VAT number';
      }
      if (cr.isNotEmpty && !_isValidCr(cr)) {
        errors['crNum'] = 'Invalid CR number';
      }
    }

    // Opening amount — optional, if provided must be positive number
    final openingAmt = (state.openingBalance?.amount?.toString() ?? '').trim();
    if (openingAmt.isNotEmpty && !_isPositiveNumber(openingAmt)) {
      errors['openingAmount'] = 'Opening amount must be a positive number';
    }

    // Billing validations (dot keys to match UI) - required fields per user request:
    // country, state, city, cityArabic
    final b = state.billingAddress;
    if ((b?.countryRegion ?? '').toString().trim().isEmpty) {
      errors['billing.country'] = 'Billing country is required';
    }
    if ((b?.state ?? '').toString().trim().isEmpty) {
      errors['billing.state'] = 'Billing state is required';
    }
    if ((b?.city ?? '').toString().trim().isEmpty) {
      errors['billing.city'] = 'Billing city is required';
    }
    if ((b?.cityArabic ?? '').toString().trim().isEmpty) {
      errors['billing.cityArabic'] = 'Billing city (Arabic) is required';
    }

    // Shipping validations — required per request unless sameAddressFlag == true
    final s = state.shippingAddress;
    if (state.sameAddressFlag != true) {
      if ((s?.countryRegion ?? '').toString().trim().isEmpty) {
        errors['shipping.country'] = 'Shipping country is required';
      }
      if ((s?.state ?? '').toString().trim().isEmpty) {
        errors['shipping.state'] = 'Shipping state is required';
      }
      if ((s?.city ?? '').toString().trim().isEmpty) {
        errors['shipping.city'] = 'Shipping city is required';
      }
      if ((s?.cityArabic ?? '').toString().trim().isEmpty) {
        errors['shipping.cityArabic'] = 'Shipping city (Arabic) is required';
      }
    }

    // Persist errors to provider so UI can show them
    ref.read(customerErrorsProvider.notifier).state = errors;

    // return validity
    return errors.isEmpty;
  }

  // ----------------------
  // Clear / reset
  // ----------------------
  void clearForm() {
    state = AddCustomerModel(
      primaryContact: PrimaryContact(firstName: '', lastName: ''),
      primaryContactArabic:
      PrimaryContactArabic(firstNameArabic: '', lastNameArabic: ''),
      customerType: 'BUSINESS',
      partyType: 'CUSTOMER',
      taxedOrganization: true,
      governmentEntity: true,
      companyName: '',
      companyNameArabic: '',
      displayName: '',
      emailAddress: '',
      phoneCode: '+966',
      phone: '',
      mobileCode: '+966',
      mobile: '',
      openingBalance: OpeningBalance(branch: null, currency: 1, amount: null),
      vatNumber: '',
      crNum: '',
      documents: [],
      remark: Remark(remark: ''),
      customFields: {},
      reportingTag: {},
      billingAddress: BillingAddress(
        countryRegion: '',
        buildingNumber: '',
        streetName: null,
        streetAddress: '',
        streetAddressArabic: '',
        city: '',
        cityArabic: '',
        state: null,
        zipCode: '',
      ),
      shippingAddress: ShippingAddress(
        countryRegion: '',
        buildingNumber: '',
        streetName: null,
        streetAddress: '',
        streetAddressArabic: '',
        city: '',
        cityArabic: '',
        state: null,
        zipCode: '',
      ),
      contactPersons: [],
      sameAddressFlag: false,
    );
    ref.read(customerErrorsProvider.notifier).state = {};
  }
}

/// Provider for the form notifier
final customerFormProvider =
StateNotifierProvider<CustomerFormNotifier, AddCustomerModel>((ref) {
  return CustomerFormNotifier(ref);
});
