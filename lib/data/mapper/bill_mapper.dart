// 📦 File: bill_mapper.dart

import 'package:payzo_books/view/add/add_billls/model/add_bill_form_model.dart';
import 'package:payzo_books/data/models/add_bills/get_item_model.dart';
import 'package:payzo_books/data/models/add_invoice/get_tax_list_model.dart';
import 'package:payzo_books/data/models/add_bills/get_all_accounts.dart';
import 'package:payzo_books/data/models/add_bills/get_venor_list_model.dart';
import 'package:payzo_books/data/models/add_bills/get_branch_list_model.dart';
import 'package:payzo_books/data/models/add_bills/get_price_currency.dart';
import 'package:payzo_books/data/models/add_bills/shipping_method_model.dart';

import '../../import_data.dart';
Map<String, dynamic> buildBillDtoFromForm({
  required AddBillFormModel state,
  required List<Item> itemList,
  required List<Account> accountList,
  required List<TaxInfo> taxOthers,
  required List<DefaultTax> taxDefaults,
  required List<VendorData> vendorList,
  required List<BranchData> branchList,
  required List<GetPriceCurrency> currencyList,
  required List<ShippingMethodModel> shippingList,
}) {
  int? _findItemId(String? name) => itemList.firstWhere(
        (e) => e.itemName == name,
    orElse: () => Item(itemId: 0, itemName: ''),
  ).itemId;

  int _findAccountId(String? name) => accountList.firstWhere(
        (e) => e.accountName == name,
    orElse: () => Account(accountId: 0, accountName: ''),
  ).accountId;

  Map<String, dynamic> _buildTax(String? taxName) {
    final match = [
      ...taxOthers.map((t) => {'id': t.taxId, 'type': t.taxType, 'name': t.taxName}),
      ...taxDefaults.map((t) => {'id': t.taxId, 'type': t.taxType, 'name': t.taxName}),
    ].firstWhere(
            (e) => e['name'] == taxName,
        orElse: () => {'id': 0, 'type': 'default', 'name': ''}
    );

    return {
      'taxId': match['id'],
      'taxType': match['type'],
    };
  }

  int? _findVendorId(String? name) {
    final id = vendorList.firstWhere(
          (e) => e.displayName == name,
      orElse: () => VendorData(partyId: 0, displayName: ''),
    ).partyId;

    if (id == 0) {
      throw Exception("⚠️ Invalid vendor selected.");
    }

    debugPrint("🧾 Selected Vendor: ${state.vendor}");
    debugPrint("✅ Available Vendors: ${vendorList.map((v) => v.displayName).toList()}");

    return id;
  }

  int? _findBranchId(String? name) => branchList.firstWhere(
        (e) => e.namePrimary == name,
    orElse: () => BranchData(branchId: 0, namePrimary: ''),
  ).branchId;

  num _findCurrencyId(String? value) => currencyList.firstWhere(
        (e) => e.currencyValue == value,
    orElse: () => GetPriceCurrency(currencyId: 0, currencyValue: ''),
  ).currencyId ?? 0;

  int? _findShippingId(String? name) => shippingList.firstWhere(
        (e) => e.shpmName == name,
    orElse: () => ShippingMethodModel(shpmId: 0, shpmName: ''),
  ).shpmId;

  return {
    "billVendorId": state.vendorId,
    "billCustomerId": state.customerId,
    "billBranchId": _findBranchId(state.branch),
    "billInvoiceNumber": state.billRefNo ?? '',
    "billOrderNumber": state.orderNo ?? '',
    "billDate": state.billDate?.toIso8601String(),
    "billDueDate": state.dueDate?.toIso8601String(),
    "billShippingType": _findShippingId(state.shippingMethod),
    "billCurrencyId": _findCurrencyId(state.currency),
    "billOrgId": state.orgId,
    "billCmpCr": state.cmpCr,
    "billPaidThroughAcc": null,             // ✅ added new
    "billCustomerNotes": state.customerNotes ?? '',
    "billTermsCondition": state.terms ?? '',
    "billPaymentTerms": state.paymentTerms ?? '',
    "billAmount": (state.subTotal).round(),
    "billTotalAmount": (state.total).round(),
    "isModalShown": 1,
    "billDiscountPercentage": 0,
    "billType": 1,                          // ✅ added new
    "billAdvance": false,                   // ✅ added new
    "billDelivery": false,                  // ✅ added new
    "billProductDetails": state.itemDetails
        .where((item) =>
    (item.itemName?.isNotEmpty ?? false) &&
        (item.quantity ?? 0) > 0 &&
        (item.amount ?? 0) > 0)
        .map((item) {
      final quantity = item.quantity ?? 0;
      final amount = item.amount ?? 0.0;

      return {
        "billProdId": _findItemId(item.itemName),
        "billProdName": item.itemName ?? '',
        "billProdCatId": 2, // You can make this dynamic later if needed
        "billProdDesc": item.description ?? '',
        "billProdTax": _buildTax(item.taxType),
        "billProdTaxExmptionReason": item.exemptionReason ?? '',
        "billProdTaxDesc": item.taxDescription,
        "billProdOthersDesc": item.othersDescription,
        "billProdAccount": _findAccountId(item.account),
        "billProdQuantity": quantity,
        "billProdUnitId": item.unitId ?? 4,
        "billProdUnitPrice": amount,
        "billProdCustomerId": item.customerId ?? 0,
        "billProdTotalAmount": amount * quantity,
        "billProdTaxAmount": item.taxAmount ?? 0,
        "billProdDiscountAmount": item.discountAmount ?? 0,
        "billProdDiscountPercentage": item.discountPercentage,
        "billProdOthersAmount": item.othersAmount ?? 0,
      };
    }).toList(),
  };
}

