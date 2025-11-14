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
  /// Clear billing country (and reset related fields). When sameAddressFlag is true,
  /// shipping will be updated to match billing (cleared too). Also removes related errors
  /// and resets UI labels to "Tap to Select".
  void clearBillingCountry() {
    final clearedBilling = (state.billingAddress ?? BillingAddress()).copyWith(
      countryRegion: '',
      state: null,
    );

    // remove billing related errors (dot-notation keys used in this notifier)
    final newErrors = Map<String, String>.from(ref.read(customerErrorsProvider));
    newErrors.remove('billing.country');
    newErrors.remove('billing.state');
    ref.read(customerErrorsProvider.notifier).state = newErrors;

    // Reset UI label providers to default text
    ref.read(billingCountryLabelProvider.notifier).state = 'Tap to Select';
    ref.read(billingStateLabelProvider.notifier).state = 'Tap to Select';

    if (state.sameAddressFlag == true) {
      // Build an equivalent ShippingAddress cleared object
      final clearedShipping = ShippingAddress(
        countryRegion: clearedBilling.countryRegion,
        buildingNumber: clearedBilling.buildingNumber ?? '',
        streetName: clearedBilling.streetName,
        streetAddress: clearedBilling.streetAddress ?? '',
        streetAddressArabic: clearedBilling.streetAddressArabic ?? '',
        city: clearedBilling.city ?? '',
        cityArabic: clearedBilling.cityArabic ?? '',
        state: clearedBilling.state,
        zipCode: clearedBilling.zipCode ?? '',
      );

      state = state.copyWith(
        billingAddress: clearedBilling,
        shippingAddress: clearedShipping,
      );

      // Reset shipping UI labels as well when same-as-billing is enabled
      ref.read(shippingCountryLabelProvider.notifier).state = 'Tap to Select';
      ref.read(shippingStateLabelProvider.notifier).state = 'Tap to Select';
    } else {
      state = state.copyWith(billingAddress: clearedBilling);
    }
  }

  /// Clear billing state only (keep country). If sameAddressFlag is true, also clear shipping state.
  /// Also resets the state label provider to "Tap to Select".
  void clearBillingState() {
    final updatedBilling = (state.billingAddress ?? BillingAddress()).copyWith(
      state: null,
    );

    final newErrors = Map<String, String>.from(ref.read(customerErrorsProvider));
    newErrors.remove('billing.state');
    ref.read(customerErrorsProvider.notifier).state = newErrors;

    // Reset UI state label provider
    ref.read(billingStateLabelProvider.notifier).state = 'Tap to Select';

    if (state.sameAddressFlag == true) {
      final updatedShipping = (state.shippingAddress ?? ShippingAddress()).copyWith(
        state: null,
      );
      state = state.copyWith(
        billingAddress: updatedBilling,
        shippingAddress: updatedShipping,
      );

      // Mirror reset to shipping label
      ref.read(shippingStateLabelProvider.notifier).state = 'Tap to Select';
    } else {
      state = state.copyWith(billingAddress: updatedBilling);
    }
  }

  /// Clear shipping country (and reset related fields). When sameAddressFlag is true,
  /// billing will be cleared to match shipping. Also removes related errors and resets UI labels
  /// to "Tap to Select".
  void clearShippingCountry() {
    final clearedShipping = (state.shippingAddress ?? ShippingAddress()).copyWith(
      countryRegion: '',
      state: null,
    );

    final newErrors = Map<String, String>.from(ref.read(customerErrorsProvider));
    newErrors.remove('shipping.country');
    newErrors.remove('shipping.state');
    ref.read(customerErrorsProvider.notifier).state = newErrors;

    // Reset UI label providers to default text
    ref.read(shippingCountryLabelProvider.notifier).state = 'Tap to Select';
    ref.read(shippingStateLabelProvider.notifier).state = 'Tap to Select';

    if (state.sameAddressFlag == true) {
      final clearedBilling = BillingAddress(
        countryRegion: clearedShipping.countryRegion,
        buildingNumber: clearedShipping.buildingNumber ?? '',
        streetName: clearedShipping.streetName,
        streetAddress: clearedShipping.streetAddress ?? '',
        streetAddressArabic: clearedShipping.streetAddressArabic ?? '',
        city: clearedShipping.city ?? '',
        cityArabic: clearedShipping.cityArabic ?? '',
        state: clearedShipping.state,
        zipCode: clearedShipping.zipCode ?? '',
      );

      state = state.copyWith(
        shippingAddress: clearedShipping,
        billingAddress: clearedBilling,
      );

      // Reset billing UI labels as well when same-as-billing is enabled
      ref.read(billingCountryLabelProvider.notifier).state = 'Tap to Select';
      ref.read(billingStateLabelProvider.notifier).state = 'Tap to Select';
    } else {
      state = state.copyWith(shippingAddress: clearedShipping);
    }
  }

  /// Clear shipping state only (keep country). If sameAddressFlag is true, also clear billing state.
  /// Also resets the state label provider to "Tap to Select".
  void clearShippingState() {
    final updatedShipping = (state.shippingAddress ?? ShippingAddress()).copyWith(
      state: null,
    );

    final newErrors = Map<String, String>.from(ref.read(customerErrorsProvider));
    newErrors.remove('shipping.state');
    ref.read(customerErrorsProvider.notifier).state = newErrors;

    // Reset UI state label provider
    ref.read(shippingStateLabelProvider.notifier).state = 'Tap to Select';

    if (state.sameAddressFlag == true) {
      final updatedBilling = (state.billingAddress ?? BillingAddress()).copyWith(
        state: null,
      );
      state = state.copyWith(
        shippingAddress: updatedShipping,
        billingAddress: updatedBilling,
      );

      // Mirror reset to billing label
      ref.read(billingStateLabelProvider.notifier).state = 'Tap to Select';
    } else {
      state = state.copyWith(shippingAddress: updatedShipping);
    }
  }

  /// Convenience: clear both country & state for billing (and shipping when sameAddressFlag is true)
  void clearBillingLocation() {
    clearBillingCountry();
    clearBillingState();
  }

  /// Convenience: clear both country & state for shipping (and billing when sameAddressFlag is true)
  void clearShippingLocation() {
    clearShippingCountry();
    clearShippingState();
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
  /// Validate form fields and populate customerErrorsProvider.
  /// Returns true when there are no errors.
  /// Validate form fields and populate customerErrorsProvider.
  /// Returns true when there are no errors.
  /// Validate form fields and populate customerErrorsProvider.
  /// Returns true when there are no errors.
  bool validateFields() {
    final errors = <String, String>{};

    // -----------------------
    // Regexes (updated)
    // -----------------------
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final ksaMobileRegex = RegExp(r'^5\d{8}$'); // 9 digits starting with 5
    final workPhoneRegex = RegExp(r'^\d{6,15}$');
    final vatRegex = RegExp(r'^\d{10,15}$');
    final crRegex = RegExp(r'^\d{10}$');

    // Building: exactly 4 digits (Saudi) — per your update
    final buildingRegex = RegExp(r'^\d{4}$');

    // Saudi ZIP: 5 digits, cannot start with 0
    final saudiZipRegex = RegExp(r'^[1-9]\d{4}$');

    // Arabic-only regex for typed Arabic fields (letters + spaces)
    final arabicOnlyRegex = RegExp(
      r'^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s]+$',
    );

    // -----------------------
    // Customer type
    // -----------------------
    if ((state.customerType ?? '').toString().trim().isEmpty) {
      errors['customerType'] = 'Customer type is required';
    }

    // -----------------------
    // Primary contact (optional fields; require min length if typed)
    // -----------------------
    final firstName = state.primaryContact?.firstName ?? '';
    final lastName = state.primaryContact?.lastName ?? '';
    if (firstName.trim().isNotEmpty && firstName.trim().length < 3) {
      errors['firstName'] = 'First name must be at least 3 characters.';
    }
    if (lastName.trim().isNotEmpty && lastName.trim().length < 3) {
      errors['secondName'] = 'Last name must be at least 3 characters.';
    }

    // Primary contact Arabic (if typed, min length)
    final firstNameAr = state.primaryContactArabic?.firstNameArabic ?? '';
    final lastNameAr = state.primaryContactArabic?.lastNameArabic ?? '';
    if (firstNameAr.trim().isNotEmpty && firstNameAr.trim().length < 3) {
      errors['firstNameArabic'] = 'First name (Arabic) must be at least 3 characters.';
    }
    if (lastNameAr.trim().isNotEmpty && lastNameAr.trim().length < 3) {
      errors['secondNameArabic'] = 'Last name (Arabic) must be at least 3 characters.';
    }

    // -----------------------
    // Company fields (required per spec)
    // -----------------------
    if ((state.companyName ?? '').trim().isEmpty) {
      errors['companyName'] = 'Company name is required';
    } else if ((state.companyName ?? '').trim().length > 0 &&
        (state.companyName ?? '').trim().length < 3) {
      errors['companyName'] = 'Company name must be at least 3 characters';
    }

    if ((state.companyNameArabic ?? '').trim().isEmpty) {
      errors['companyNameArabic'] = 'Company name (Arabic) is required';
    } else if ((state.companyNameArabic ?? '').trim().length > 0 &&
        (state.companyNameArabic ?? '').trim().length < 3) {
      errors['companyNameArabic'] = 'Company name (Arabic) must be at least 3 characters';
    }

    // displayName if typed must be min 3
    if ((state.displayName ?? '').trim().isNotEmpty &&
        (state.displayName ?? '').trim().length < 3) {
      errors['displayName'] = 'Display name must be at least 3 characters';
    }

    // -----------------------
    // Email (optional): validate if typed
    // -----------------------
    final email = (state.emailAddress ?? '').trim();
    if (email.isNotEmpty && !emailRegex.hasMatch(email)) {
      errors['email'] = 'Invalid email address';
    }

    // -----------------------
    // Mobile / Phone (optional): validate if typed
    // -----------------------
    final mobile = (state.mobile ?? '').trim();
    if (mobile.isNotEmpty && !ksaMobileRegex.hasMatch(mobile)) {
      errors['mobile'] = 'Invalid mobile number';
    }

    final workPhone = (state.phone ?? '').trim();
    if (workPhone.isNotEmpty && !workPhoneRegex.hasMatch(workPhone)) {
      errors['phone'] = 'Invalid phone number';
    }

    // -----------------------
    // VAT & CR validation
    // -----------------------
    final taxed = state.taxedOrganization ?? false;
    final vat = (state.vatNumber ?? '').trim();
    final cr = (state.crNum ?? '').trim();

    if (taxed) {
      if (vat.isEmpty) {
        errors['vatNumber'] = 'VAT number is required';
      } else if (!vatRegex.hasMatch(vat)) {
        errors['vatNumber'] = 'Invalid VAT number';
      }

      if (cr.isEmpty) {
        errors['crNum'] = 'Customer CR is required';
      } else if (!crRegex.hasMatch(cr)) {
        errors['crNum'] = 'Invalid CR number';
      }
    } else {
      if (vat.isNotEmpty && !vatRegex.hasMatch(vat)) {
        errors['vatNumber'] = 'Invalid VAT number';
      }
      if (cr.isNotEmpty && !crRegex.hasMatch(cr)) {
        errors['crNum'] = 'Invalid CR number';
      }
    }

    // -----------------------
    // Opening balance: numeric & non-negative
    // -----------------------
    final openingAmtStr = (state.openingBalance?.amount?.toString() ?? '').trim();
    if (openingAmtStr.isNotEmpty) {
      final parsed = double.tryParse(openingAmtStr);
      if (parsed == null) {
        errors['openingBalance.amount'] = 'Opening amount must be a number';
      } else if (parsed < 0) {
        errors['openingBalance.amount'] = 'Opening amount cannot be negative';
      }
    }

    // -----------------------
    // Billing address checks
    // Required: country, state, city, cityArabic
    // Optional checks applied when the field is typed
    // NOTE: keys are aligned with UI field keys (building, street, streetArabic, city, cityArabic, zip)
    // -----------------------
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

    // building number (optional) — must be exactly 4 digits when provided
    final billingBuilding = (b?.buildingNumber ?? '').toString().trim();
    if (billingBuilding.isNotEmpty && !buildingRegex.hasMatch(billingBuilding)) {
      errors['billing.building'] = 'Building number must be exactly 4 digits';
    }

    // street (optional) must be >= 3 chars when provided
    final billingStreet = (b?.streetAddress ?? '').toString().trim();
    if (billingStreet.isNotEmpty && billingStreet.length < 3) {
      errors['billing.street'] = 'Street must be at least 3 characters.';
    }

    // street (Arabic) (optional) must be Arabic-only and >= 3 chars when provided
    final billingStreetAr = (b?.streetAddressArabic ?? '').toString().trim();
    if (billingStreetAr.isNotEmpty) {
      if (billingStreetAr.length < 3) {
        errors['billing.streetArabic'] = 'Street (Arabic) must be at least 3 characters.';
      } else if (!arabicOnlyRegex.hasMatch(billingStreetAr)) {
        errors['billing.streetArabic'] = 'Street (Arabic) must contain only Arabic letters and spaces.';
      }
    }

    // city length (optional extra check — although required above)
    final billingCity = (b?.city ?? '').toString().trim();
    if (billingCity.isNotEmpty && billingCity.length < 3) {
      errors['billing.city'] = 'City must be at least 3 characters.';
    }

    // city Arabic (optional) must be Arabic-only and >= 3 if provided
    final billingCityAr = (b?.cityArabic ?? '').toString().trim();
    if (billingCityAr.isNotEmpty) {
      if (billingCityAr.length < 3) {
        errors['billing.cityArabic'] = 'City (Arabic) must be at least 3 characters.';
      } else if (!arabicOnlyRegex.hasMatch(billingCityAr)) {
        errors['billing.cityArabic'] = 'City (Arabic) must contain only Arabic letters and spaces.';
      }
    }

    // zip (if typed) -> Saudi ZIP rule
    final billingZip = (b?.zipCode ?? '').toString().trim();
    if (billingZip.isNotEmpty && !saudiZipRegex.hasMatch(billingZip)) {
      errors['billing.zip'] = 'Invalid Saudi ZIP code (5 digits, cannot start with 0)';
    }

    // -----------------------
    // Shipping address checks (if sameAddressFlag != true)
    // Apply same optional rules as billing (keys aligned to UI)
    // -----------------------
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

    // shipping building (optional) must be exactly 4 digits when provided
    final shippingBuilding = (s?.buildingNumber ?? '').toString().trim();
    if (shippingBuilding.isNotEmpty && !buildingRegex.hasMatch(shippingBuilding)) {
      errors['shipping.building'] = 'Building number must be exactly 4 digits';
    }

    // shipping street (optional)
    final shippingStreet = (s?.streetAddress ?? '').toString().trim();
    if (shippingStreet.isNotEmpty && shippingStreet.length < 3) {
      errors['shipping.street'] = 'Street must be at least 3 characters.';
    }

    // shipping street Arabic (optional)
    final shippingStreetAr = (s?.streetAddressArabic ?? '').toString().trim();
    if (shippingStreetAr.isNotEmpty) {
      if (shippingStreetAr.length < 3) {
        errors['shipping.streetArabic'] = 'Street (Arabic) must be at least 3 characters.';
      } else if (!arabicOnlyRegex.hasMatch(shippingStreetAr)) {
        errors['shipping.streetArabic'] = 'Street (Arabic) must contain only Arabic letters and spaces.';
      }
    }

    // shipping city length (optional)
    final shippingCity = (s?.city ?? '').toString().trim();
    if (shippingCity.isNotEmpty && shippingCity.length < 3) {
      errors['shipping.city'] = 'City must be at least 3 characters.';
    }

    // shipping city Arabic (optional)
    final shippingCityAr = (s?.cityArabic ?? '').toString().trim();
    if (shippingCityAr.isNotEmpty) {
      if (shippingCityAr.length < 3) {
        errors['shipping.cityArabic'] = 'City (Arabic) must be at least 3 characters.';
      } else if (!arabicOnlyRegex.hasMatch(shippingCityAr)) {
        errors['shipping.cityArabic'] = 'City (Arabic) must contain only Arabic letters and spaces.';
      }
    }

    // shipping zip (if typed)
    final shippingZip = (s?.zipCode ?? '').toString().trim();
    if (shippingZip.isNotEmpty && !saudiZipRegex.hasMatch(shippingZip)) {
      errors['shipping.zip'] = 'Invalid Saudi ZIP code (5 digits, cannot start with 0)';
    }

    // -----------------------
    // Documents: each documentNumber if present must be at least 3 chars
    // -----------------------
    try {
      if (state.documents is List && (state.documents as List).isNotEmpty) {
        for (var i = 0; i < (state.documents as List).length; i++) {
          final doc = (state.documents as List)[i];
          if (doc is Map && doc.containsKey('documentNumber')) {
            final dn = (doc['documentNumber'] ?? '').toString().trim();
            if (dn.isNotEmpty && dn.length < 3) {
              errors['documents.$i.documentNumber'] = 'Document number must be at least 3 characters.';
            }
          }
        }
      } else if (state.documents is Map) {
        final dn = (state.documents![1] ?? '').toString().trim();
        if (dn.isNotEmpty && dn.length < 3) {
          errors['documents.documentNumber'] = 'Document number must be at least 3 characters.';
        }
      }
    } catch (_) {
      // ignore document structure problems - do not crash validation
    }

    // -----------------------
    // Persist and print errors
    // -----------------------
    ref.read(customerErrorsProvider.notifier).state = errors;

    if (errors.isEmpty) {
      debugPrint('✅ validateFields: no validation errors found.');
    } else {
      debugPrint('❌ validateFields: validation errors found (${errors.length}):');
      errors.forEach((key, msg) {
        debugPrint('  • $key -> $msg');
      });
    }

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
