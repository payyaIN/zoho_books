import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/view/add_invoice/model/add_invoice_form_model.dart';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';

import '../../../import_data.dart';

class InvoiceFormNotifier extends StateNotifier<InvoiceFormModel> {
  InvoiceFormNotifier() : super(const InvoiceFormModel());

  void updateField(String key, dynamic value) {
    switch (key) {
      case 'customerName':
        state = state.copyWith(customerName: value);
        break;
      case 'customerId':
        state = state.copyWith(customerId: value);
        break;
      case 'branch':
        state = state.copyWith(branch: value);
        break;
      case 'branchId':
        state = state.copyWith(branchId: value);
        break;
      case 'invoiceRefNo':
        state = state.copyWith(invoiceRefNo: value);
        break;
      case 'orderNo':
        state = state.copyWith(orderNo: value);
        break;
      case 'invoiceDate':
        state = state.copyWith(invoiceDate: value);
        break;
      case 'expiryDate':
        state = state.copyWith(expiryDate: value);
        break;
      case 'supplyDate':
        state = state.copyWith(supplyDate: value);
        break;
      case 'shippingMethod':
        state = state.copyWith(shippingMethod: value);
        break;
      case 'shippingMethodId':
        state = state.copyWith(shippingMethodId: value);
        break;
      case 'bankAccount':
        state = state.copyWith(bankAccount: value);
        break;
      case 'bankAccountId':
        state = state.copyWith(bankAccountId: value);
        break;
      case 'currency':
        state = state.copyWith(currency: value);
        break;
      case 'currencyId':
        state = state.copyWith(currencyId: value);
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
      case 'account':
        state = state.copyWith(account: value);
        break;
      case 'companyCR':
        state = state.copyWith(companyCR: value);
        break;
      case 'orgId':
        state = state.copyWith(orgId: value);
        break;
      case 'advance':
        state = state.copyWith(advance: value);
        break;
      case 'delivery':
        state = state.copyWith(delivery: value);
        break;
      case 'invoiceNumber':
        state = state.copyWith(invoiceNumber: value);
        break;
      case 'attachment':
        state = state.copyWith(attachment: value);
        break;
    }
  }

  void updateItemField(int index, String key, dynamic value) {
    final updatedList = [...state.itemDetails];
    final current = updatedList[index];

    final updated = switch (key) {
      'prodId' => current.copyWith(prodId: value), // ✅ Added here
      'itemName' => current.copyWith(itemName: value),
      'account' => current.copyWith(account: value),
      'quantity' => current.copyWith(quantity: value),
      'unitType' => current.copyWith(unitType: value),
      'rateDate' => current.copyWith(rateDate: value as String),
      'taxType' => current.copyWith(taxType: value),
      'customerDate' => current.copyWith(customerDate: value as String),
      'amount' => current.copyWith(amount: value),
      'description' => current.copyWith(description: value),
      'exemptionReason' => current.copyWith(exemptionReason: value),
      'taxDescription' => current.copyWith(taxDescription: value),
      'othersDescription' => current.copyWith(othersDescription: value),
      'unitId' => current.copyWith(unitId: value),
      'customerId' => current.copyWith(customerId: value),
      'taxAmount' => current.copyWith(taxAmount: value),
      'discountAmount' => current.copyWith(discountAmount: value),
      'discountPercentage' => current.copyWith(discountPercentage: value),
      'othersAmount' => current.copyWith(othersAmount: value),
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
    const tax = 0.0;
    final total = subTotal + tax;
    state = state.copyWith(subTotal: subTotal, tax: tax, total: total);
  }

  bool validateForm() {
    final Map<String, String?> errors = {};

    if (state.customerName == null || state.customerName!.isEmpty) {
      errors['customerName'] = 'Customer Name is required';
    }

    if (state.branch == null || state.branch!.isEmpty) {
      errors['branch'] = 'Branch is required';
    }
    if (state.invoiceRefNo == null || state.invoiceRefNo!.isEmpty) {
      errors['invoiceRefNo'] = 'Invoice Reference Number is required';
    }
    if (state.invoiceDate == null || state.invoiceDate!.toString().isEmpty) {
      errors['invoiceDate'] = 'Invoice Date is required';
    }
    if (state.expiryDate == null || state.expiryDate!.toString().isEmpty) {
      errors['expiryDate'] = 'Expiry Date is required';
    }
    if (state.supplyDate == null || state.supplyDate!.toString().isEmpty) {
      errors['supplyDate'] = 'Supply Date is required';
    }
    if (state.shippingMethod == null || state.shippingMethod!.toString().isEmpty) {
      errors['shippingMethod'] = 'Shipping Method is required';
    }
    if (state.bankAccount == null || state.bankAccount!.toString().isEmpty) {
      errors['bankAccount'] = 'Bank Account is required';
    }
    if (state.currency == null || state.currency!.toString().isEmpty) {
      errors['currency'] = 'Price Currency is required';
    }
    // if (state.paymentTerms == null || state.paymentTerms!.toString().isEmpty) {
    //   errors['paymentTerms'] = 'Payment Terms is required';
    // }
    // if (state.customerNotes == null || state.customerNotes!.toString().isEmpty) {
    //   errors['customerNotes'] = 'Customer Notes is required';
    // }
    // if (state.terms == null || state.terms!.toString().isEmpty) {
    //   errors['terms'] = 'Terms and Conditions is required';
    // }

    if (state.itemDetails.any((item) => item.quantity == null || item.quantity == 0)) {
      errors['quantity'] = 'Quantity is required';
    }
    if (state.itemDetails.any((item) => item.amount == null || item.amount == 0.0)) {
      errors['amount'] = 'Amount must be greater than 0';
    }
    if (state.itemDetails.any((item) => item.itemName == null || item.itemName == '')) {
      errors['itemName'] = 'Item Name is required';
    }
    // if (state.itemDetails.any((item) => item.customerDate == null)) {
    //   errors['customerDate'] = 'Customer Date is required';
    // }
    if (state.itemDetails.any((item) => item.taxType == null || item.taxType == '')) {
      errors['taxType'] = 'Tax Type is required';
    }
    if (state.itemDetails.any((item) => item.rateDate == null ||item.rateDate==0)) {
      errors['rateDate'] = 'Rate  is required';
    }
    if (state.itemDetails.any((item) => item.unitType == null || item.unitType == '')) {
      errors['unitType'] = 'Unit Type is required';
    }
    if (state.itemDetails.any((item) => item.account == null || item.account == '')) {
      errors['account'] = 'Account is required';
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  bool validateItemFieldsOnly() {
    final Map<String, String?> errors = {};

    for (var item in state.itemDetails) {
      if (item.quantity == null || item.quantity == 0) {
        errors['quantity'] = 'Quantity is required';
      }
      if (item.itemName == null || item.itemName!.isEmpty) {
        errors['itemName'] = 'Item Name is required';
      }
      if (item.account == null || item.account!.isEmpty) {
        errors['account'] = 'Account is required';
      }
      if (item.unitType == null || item.unitType!.isEmpty) {
        errors['unitType'] = 'Unit Type is required';
      }
      if (item.rateDate == null) {
        errors['rateDate'] = 'Rate Date is required';
      }
      if (item.taxType == null || item.taxType!.isEmpty) {
        errors['taxType'] = 'Tax Type is required';
      }
      if (item.customerDate == null) {
        errors['customerDate'] = 'Customer Date is required';
      }
      if (item.amount == null || item.amount == 0.0) {
        errors['amount'] = 'Amount must be greater than 0';
      }
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  void clearForm() {
    state = const InvoiceFormModel();
  }
}

final invoiceFormProvider =
StateNotifierProvider<InvoiceFormNotifier, InvoiceFormModel>(
      (ref) => InvoiceFormNotifier(),
);

final addInvoiceNewLineProvider = StateProvider<int>((ref) => 1);
