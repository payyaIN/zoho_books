import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/view/add/add_billls/model/add_bill_form_model.dart';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';

import '../../../../import_data.dart';

class AddBillFormNotifier extends StateNotifier<AddBillFormModel> {
  AddBillFormNotifier() : super(const AddBillFormModel());

  void updateField(String key, dynamic value) {
    switch (key) {
      case 'vendor':
        state = state.copyWith(vendor: value);
        break;
      case 'vendorId':
        state = state.copyWith(vendorId: value);
        break;
      case 'branch':
        state = state.copyWith(branch: value);
        break;
      case 'billRefNo':
        state = state.copyWith(billRefNo: value);
        break;
      case 'orderNo':
        state = state.copyWith(orderNo: value);
        break;
      case 'billDate':
        state = state.copyWith(billDate: value);
        break;
      case 'dueDate':
        state = state.copyWith(dueDate: value);
        break;
      case 'shippingMethod':
        state = state.copyWith(shippingMethod: value);
        break;
      case 'currency':
        state = state.copyWith(currency: value);
        break;
      case 'paymentTerms':
        state = state.copyWith(paymentTerms: value);
        break;
      case 'customerNotes':
        state = state.copyWith(customerNotes: value);
        break;
      case 'terms':
        state = state.copyWith(terms: value);
        break;
      case 'attachment':
        state = state.copyWith(attachment: value as File);
        break;
      case 'customerId':
        state = state.copyWith(customerId: value);
        break;
      case 'orgId':
        state = state.copyWith(orgId: value);
        break;
      case 'cmpCr':
        state = state.copyWith(cmpCr: value);
        break;
    }
  }

  void updateItemField(int index, String key, dynamic value) {
    final updatedList = [...state.itemDetails];
    final current = updatedList[index];

    final updated = switch (key) {
      'itemName' => current.copyWith(itemName: value),
      'account' => current.copyWith(account: value),
      'quantity' => current.copyWith(quantity: value),
      'unitType' => current.copyWith(unitType: value),
      'rateDate' => current.copyWith(rateDate: value),
      'taxType' => current.copyWith(taxType: value),
      'customerDate' => current.copyWith(customerDate: value),
      'amount' => current.copyWith(amount: value),
      'discountAmount' => current.copyWith(discountAmount: value),
      'discountPercentage' => current.copyWith(discountPercentage: value),
      'exemptionReason' => current.copyWith(exemptionReason: value),
      'taxDescription' => current.copyWith(taxDescription: value),
      'othersDescription' => current.copyWith(othersDescription: value),
      'othersAmount' => current.copyWith(othersAmount: value),
      'unitId' => current.copyWith(unitId: value),
      'customerId' => current.copyWith(customerId: value),
      'taxAmount' => current.copyWith(taxAmount: value),
      _ => current,
    };

    updatedList[index] = updated;
    state = state.copyWith(itemDetails: updatedList);
    _recalculateTotal();
  }

  void addNewItem() {
    final updatedList = [...state.itemDetails, const ItemDetail()];
    state = state.copyWith(itemDetails: updatedList);
    _recalculateTotal();
  }

  void removeItem(int index) {
    final updatedList = [...state.itemDetails]..removeAt(index);
    state = state.copyWith(itemDetails: updatedList);
    _recalculateTotal();
  }

  void _recalculateTotal() {
    final subTotal = state.itemDetails.fold<double>(
      0.0,
      (sum, item) => sum + (item.amount ?? 0.0) * (item.quantity ?? 0),
    );
    final tax = 0.0;
    final total = subTotal + tax;
    state = state.copyWith(subTotal: subTotal, tax: tax, total: total);
  }

  void validateForm() {
    final Map<String, String?> errors = {};

    if (state.vendor == null || state.vendor!.isEmpty) {
      errors['vendor'] = 'Vendor is required';
    }
    if (state.vendorId == null || state.vendorId == 0) {
      errors['vendor'] = 'Vendor selection is invalid';
    }
    if (state.branch == null || state.branch!.isEmpty) {
      errors['branch'] = 'Branch is required';
    }
    if (state.billRefNo == null || state.billRefNo!.isEmpty) {
      errors['billRefNo'] = 'Bill reference number is required';
    }
    // if (state.orderNo == null || state.orderNo!.isEmpty) {
    //   errors['orderNo'] = 'Order Number is required';
    // }
    if (state.billDate == null) {
      errors['billDate'] = 'Bill date is required';
    }
    if (state.dueDate == null) {
      errors['dueDate'] = 'Due date is required';
    }
    if (state.shippingMethod == null || state.shippingMethod!.isEmpty) {
      errors['shippingMethod'] = 'Shipping method is required';
    }
    if (state.currency == null || state.currency!.isEmpty) {
      errors['currency'] = 'Currency is required';
    }
    // if (state.paymentTerms == null || state.paymentTerms!.isEmpty) {
    //   errors['paymentTerms'] = 'Payment terms are required';
    // }
    // if (state.customerNotes == null || state.customerNotes!.isEmpty) {
    //   errors['customerNotes'] = 'Customer notes are required';
    // }
    for (var item in state.itemDetails) {
      if (item.quantity == null || item.quantity == 0) {
        errors['quantity'] = 'Quantity is required';
      }
      if (item.itemName == null || item.itemName!.isEmpty) {
        errors['itemName'] = 'Item name is required';
      }
      if (item.account == null || item.account!.isEmpty) {
        errors['account'] = 'Account is required';
      }
      if (item.unitType == null || item.unitType!.isEmpty) {
        errors['unitType'] = 'Unit type is required';
      }
      if (item.rateDate == null || item.rateDate == 0) {
        errors['rateDate'] = 'Rate is required';
      }
      if (item.taxType == null || item.taxType!.isEmpty) {
        errors['taxType'] = 'Tax type is required';
      }
      if (item.customerDate == null) {
        errors['customerDate'] = 'Customer date is required';
      }
      if (item.amount == null || item.amount == 0.0) {
        errors['amount'] = 'Amount must be greater than 0';
      }
    }
    state = state.copyWith(errors: errors);
  }

  bool validateLastItemFields() {
    final Map<String, String?> errors = {};
    if (state.itemDetails.isEmpty) return true;

    final item = state.itemDetails.last;

    if (item.quantity == null || item.quantity == 0) {
      errors['quantity'] = 'Quantity is required';
    }
    if (item.itemName == null || item.itemName!.isEmpty) {
      errors['itemName'] = 'Item name is required';
    }
    if (item.account == null || item.account!.isEmpty) {
      errors['account'] = 'Account is required';
    }
    if (item.unitType == null || item.unitType!.isEmpty) {
      errors['unitType'] = 'Unit type is required';
    }
    if (item.rateDate == null || item.rateDate == 0) {
      errors['rateDate'] = 'Rate is required';
    }

    if (item.taxType == null || item.taxType!.isEmpty) {
      errors['taxType'] = 'Tax type is required';
    }
    if (item.customerDate == null || item.customerDate.toString().isEmpty) {
      errors['customerDate'] = 'Customer details are required';
    }

    if (item.amount == null || item.amount == 0.0) {
      errors['amount'] = 'Amount must be greater than 0';
    }

    if (errors.isNotEmpty) {
      state = state.copyWith(errors: errors);
      return false;
    }

    return true;
  }

  void clearForm() {
    state = const AddBillFormModel();
  }
}

final addBillFormProvider =
    StateNotifierProvider<AddBillFormNotifier, AddBillFormModel>(
  (ref) => AddBillFormNotifier(),
);

final addNewLineProvider = StateProvider<int>((ref) => 1);
