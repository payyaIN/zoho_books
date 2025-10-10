import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_customer/add_customer_model.dart';

import '../../../../import_data.dart';

class CustomerFormNotifier extends StateNotifier<AddCustomerModel> {
  CustomerFormNotifier()
      : super(AddCustomerModel(
          customerType: 'Business',
          salutation: '',
          firstName: '',
          firstNameArabic: '',
          secondName: '',
          secondNameArabic: '',
          companyName: '',
          companyNameArabic: '',
          email: '',
          mobile: '',
          workPhone: '',
          phoneCode: '+966',
          mobileCode: '+966',
          cpPhnCode: '+966',
          cpMobCode: '+966',
          openingAmount: '',
          currencyId: 1,
          branchId: 1,
          expiryDate: '2025-04-05',
          documentType: '',
          documentNumber: '',
          remark: '',
          billingAddress: {
            'country': '',
            'state': '',
            'building': '',
            'street': '',
            'streetArabic': '',
            'city': '',
            'cityArabic': '',
            'zip': ''
          },
          shippingAddress: {
            'country': '',
            'state': '',
            'building': '',
            'street': '',
            'streetArabic': '',
            'city': '',
            'cityArabic': '',
            'zip': ''
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
        state = state.copyWith(companyName: value);
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
      case 'phoneCode':
        state = state.copyWith(phoneCode: value);
        break;
      case 'mobileCode':
        state = state.copyWith(mobileCode: value);
        break;
      case 'cpPhnCode':
        state = state.copyWith(cpPhnCode: value);
        break;
      case 'cpMobCode':
        state = state.copyWith(cpMobCode: value);
        break;
      case 'openingAmount':
        state = state.copyWith(openingAmount: value);
        break;
      case 'currencyId':
        state = state.copyWith(currencyId: int.tryParse(value) ?? 1);
        break;
      case 'branchId':
        state = state.copyWith(branchId: int.tryParse(value) ?? 1);
        break;
      case 'expiryDate':
        state = state.copyWith(expiryDate: value);
        break;
      case 'documentType':
        state = state.copyWith(documentType: value);
        break;
      case 'documentNumber':
        state = state.copyWith(documentNumber: value);
        break;
      case 'remark':
        state = state.copyWith(remark: value);
        break;
    }
  }

  void updateBillingAddress(String key, String value) {
    state = state.copyWith(
      billingAddress: {...state.billingAddress, key: value},
    );
  }

  void updateShippingAddress(String key, String value) {
    state = state.copyWith(
      shippingAddress: {...state.shippingAddress, key: value},
    );
  }

  void updateCustomerType(String value) {
    state = state.copyWith(customerType: value);
  }

  void clearForm() {
    state = AddCustomerModel(
      customerType: 'Business',
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
      cpPhnCode: '+966',
      cpMobCode: '+966',
      openingAmount: '1,000',
      currencyId: 1,
      branchId: 1,
      expiryDate: '2025-04-05',
      documentType: '',
      documentNumber: '',
      remark: '',
      billingAddress: {
        'country': '',
        'state': '',
        'building': '',
        'street': '',
        'city': '',
        'zip': ''
      },
      shippingAddress: {
        'country': '',
        'state': '',
        'building': '',
        'street': '',
        'city': '',
        'zip': ''
      },
    );
  }

  /// ✅ Add validation for required fields
  void validateFields() {
    final Map<String, String> errors = {};
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (state.firstName.trim().isEmpty) {
      errors['firstName'] = 'First name is required';
    }

    if (state.secondName.trim().isEmpty) {
      errors['secondName'] = 'Last name is required';
    }

    if (state.companyName.trim().isEmpty) {
      errors['companyName'] = 'Company name is required';
    }
    if (state.firstNameArabic.trim().isEmpty) {
      errors['firstName'] = 'First name in Arabic is required';
    }

    if (state.secondNameArabic.trim().isEmpty) {
      errors['secondName'] = 'Last name in Arabic is required';
    }

    if (state.companyNameArabic.trim().isEmpty) {
      errors['companyName'] = 'Company name in Arabic is required';
    }

    if (state.email.trim().isEmpty) {
      errors['email'] = 'Email is required.';
    } else if (!emailRegex.hasMatch(state.email.trim())) {
      errors['email'] = 'Please enter a valid email address.';
    }

    if (state.mobile.trim().isEmpty) {
      errors['mobile'] = 'Mobile number is required';
    } else if (!RegExp(r'^5\d{8}$').hasMatch(state.mobile.trim())) {
      errors['mobile'] = 'Enter a valid mobile number ';
    }
    if (state.workPhone.trim().isEmpty) {
    } else if (!RegExp(r'^5\d{8}$').hasMatch(state.workPhone.trim())) {
      errors['workPhone'] = 'Enter a valid mobile number';
    }
    // Billing Address
    if (state.billingAddress['country']?.trim().isEmpty ?? true) {
      errors['billing.country'] = 'Billing country is required';
    }
    if (state.billingAddress['building']?.trim().isEmpty ?? true) {
      errors['billing.building'] = 'Building number is required';
    }
    if (state.billingAddress['street']?.trim().isEmpty ?? true) {
      errors['billing.street'] = 'Street address is required';
    }
    if (state.billingAddress['city']?.trim().isEmpty ?? true) {
      errors['billing.city'] = 'City is required';
    }
    if (state.billingAddress['state']?.trim().isEmpty ?? true) {
      errors['billing.state'] = 'State is required';
    }
    if (state.billingAddress['zip']?.trim().isEmpty ?? true) {
      errors['billing.zip'] = 'Zip code is required';
    }

    // Shipping Address
    if (state.shippingAddress['country']?.trim().isEmpty ?? true) {
      errors['shipping.country'] = 'Shipping country is required';
    }
    if (state.shippingAddress['building']?.trim().isEmpty ?? true) {
      errors['shipping.building'] = 'Building number is required';
    }
    if (state.shippingAddress['street']?.trim().isEmpty ?? true) {
      errors['shipping.street'] = 'Street address is required';
    }
    if (state.shippingAddress['city']?.trim().isEmpty ?? true) {
      errors['shipping.city'] = 'City is required';
    }
    if (state.shippingAddress['state']?.trim().isEmpty ?? true) {
      errors['shipping.state'] = 'State is required';
    }
    if (state.shippingAddress['zip']?.trim().isEmpty ?? true) {
      errors['shipping.zip'] = 'Zip code is required';
    }

    state = state.copyWith(errors: errors);
  }
}

final customerFormProvider =
    StateNotifierProvider<CustomerFormNotifier, AddCustomerModel>((ref) {
  return CustomerFormNotifier();
});
