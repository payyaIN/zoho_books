// // 📦 File: bill_mapper.dart
//
// import 'package:payzo_books/view/add/add_billls/model/add_bill_form_model.dart';
// import 'package:payzo_books/data/models/add_bills/get_item_model.dart';
// import 'package:payzo_books/data/models/add_invoice/get_tax_list_model.dart';
// import 'package:payzo_books/data/models/add_bills/get_all_accounts.dart';
// import 'package:payzo_books/data/models/add_bills/get_venor_list_model.dart';
// import 'package:payzo_books/data/models/add_bills/get_branch_list_model.dart';
// import 'package:payzo_books/data/models/add_bills/get_price_currency.dart';
// import 'package:payzo_books/data/models/add_bills/shipping_method_model.dart';
//
// import '../../import_data.dart';
//
// Map<String, dynamic> buildBillDtoFromForm({
//   required AddBillFormModel state,
//   required List<Item> itemList,
//   required List<Account> accountList,
//   required List<TaxInfo> taxOthers,
//   required List<DefaultTax> taxDefaults,
//   required List<VendorData> vendorList,
//   required List<BranchData> branchList,
//   required List<GetPriceCurrency> currencyList,
//   required List<ShippingMethodModel> shippingList,
// }) {
//   int? _findItemId(String? name) => itemList.firstWhere(
//         (e) => (e.itemName ?? '') == (name ?? ''),
//     orElse: () => Item(itemId: 0, itemName: ''),
//   ).itemId;
//
//   int _findAccountId(String? name) => accountList.firstWhere(
//         (e) => (e.accountName ?? '') == (name ?? ''),
//     orElse: () => Account(accountId: 0, accountName: ''),
//   ).accountId;
//
//   Map<String, dynamic> _buildTax(String? taxName) {
//     final match = [
//       ...taxOthers.map((t) => {'id': t.taxId, 'type': t.taxType, 'name': t.taxName}),
//       ...taxDefaults.map((t) => {'id': t.taxId, 'type': t.taxType, 'name': t.taxName}),
//     ].firstWhere(
//           (e) => (e['name'] ?? '') == (taxName ?? ''),
//       orElse: () => {'id': 0, 'type': 'default', 'name': ''},
//     );
//
//     return {
//       'taxId': match['id'] ?? 0,
//       'taxType': match['type'] ?? 'default',
//     };
//   }
//
//   int? _findVendorId(String? name) {
//     if (name == null || name.isEmpty) return null;
//     final id = vendorList.firstWhere(
//           (e) => (e.displayName ?? '') == name,
//       orElse: () => VendorData(partyId: 0, displayName: ''),
//     ).partyId;
//
//     if (id == 0) {
//       // let caller handle invalid vendor — still return null so DTO can be validated earlier
//       return null;
//     }
//     return id;
//   }
//
//   int? _findBranchId(String? name) => branchList.firstWhere(
//         (e) => (e.namePrimary ?? '') == (name ?? ''),
//     orElse: () => BranchData(branchId: 0, namePrimary: ''),
//   ).branchId;
//
//   num _findCurrencyId(String? value) => currencyList.firstWhere(
//         (e) => (e.currencyValue ?? '') == (value ?? ''),
//     orElse: () => GetPriceCurrency(currencyId: 0, currencyValue: ''),
//   ).currencyId ?? 0;
//
//   int? _findShippingId(String? name) => shippingList.firstWhere(
//         (e) => (e.shpmName ?? '') == (name ?? ''),
//     orElse: () => ShippingMethodModel(shpmId: 0, shpmName: ''),
//   ).shpmId;
//
//   // Build product details safely (skip invalid/empty lines)
//   final productDetails = state.itemDetails
//       .where((item) =>
//   (item.itemName?.isNotEmpty ?? false) &&
//       ((item.quantity ?? 0) > 0) &&
//       ((item.amount ?? 0) >= 0))
//       .map((item) {
//     final quantity = item.quantity ?? 0;
//     final amount = (item.amount ?? 0.0);
//     final totalAmount = amount * (quantity.toDouble());
//
//     return {
//       "billProdId": _findItemId(item.itemName),
//       "billProdName": item.itemName ?? '',
//       "billProdCatId": item.categoryId ?? 2,
//       "billProdDesc": item.description ?? '',
//       "billProdTax": _buildTax(item.taxType),
//       "billProdTaxExmptionReason": item.exemptionReason ?? '',
//       "billProdTaxDesc": item.taxDescription,
//       "billProdOthersDesc": item.othersDescription,
//       "billProdAccount": _findAccountId(item.account),
//       "billProdQuantity": quantity,
//       "billProdUnitId": item.unitId ?? 4,
//       "billProdUnitPrice": amount,
//       "billProdCustomerId": item.customerId ?? 0,
//       "billProdTotalAmount": totalAmount,
//       "billProdTaxAmount": item.taxAmount ?? 0.0,
//       "billProdDiscountAmount": item.discountAmount ?? 0.0,
//       "billProdDiscountPercentage": item.discountPercentage ?? 0.0,
//       "billProdDiscountType": (item.discountIsCurrency == true) ? 'FIXED' : 'PERCENTAGE',
//       "billProdOthersAmount": item.othersAmount ?? 0.0,
//     };
//   }).toList();
//
//   // Vendor id: prefer explicit vendorId in state; if missing, try name lookup (but don't throw)
//   final vendorId = state.vendorId ?? _findVendorId(state.vendor);
//
//   return {
//     "billVendorId": vendorId,
//     "billCustomerId": state.customerId,
//     "billBranchId": _findBranchId(state.branch),
//     "billInvoiceNumber": state.billRefNo ?? '',
//     "billOrderNumber": state.orderNo ?? '',
//     // keep full precision for dates & numbers
//     "billDate": state.billDate?.toIso8601String(),
//     "billDueDate": state.dueDate?.toIso8601String(),
//     "billShippingType": _findShippingId(state.shippingMethod),
//     "billCurrencyId": _findCurrencyId(state.currency),
//     "billOrgId": state.orgId,
//     "billCmpCr": state.cmpCr,
//     "billPaidThroughAcc": state.paidThroughAccount ?? null,
//     "billCustomerNotes": state.customerNotes ?? '',
//     "billTermsCondition": state.terms ?? '',
//     "billPaymentTerms": state.paymentTerms ?? '',
//     // preserve decimals (do NOT round)
//     "billAmount": state.subTotal ?? 0.0,
//     "billTotalAmount": state.total ?? 0.0,
//     "isModalShown": 1,
//     // discount fields (defaults kept safe)
//     "billDiscountType": state.discountType ?? 'FIXED',
//     "billDiscountPercentage": state.discountPercentage ?? 0,
//     "billDiscountAmount": state.discountAmount ?? 0.0,
//     // new flags (present in new API example) with safe defaults
//     "billType": state.billType ?? 1,
//     "billAdvance": state.billAdvance ?? false,
//     "billDelivery": state.billDelivery ?? false,
//     // item details as built above
//     "billProductDetails": productDetails,
//     // meta fields
//     "isIncoming": state.isIncoming ?? 0,
//     "billStatus": state.billStatus,
//     "billInfo": state.billInfo ?? '',
//     "billDiscountMethod": state.discountMethod ?? 'LINE_ITEM_DISCOUNT',
//     "taxMethod": state.taxMethod ?? 'TAX_EXCLUSIVE',
//     "isTaxInclusive": state.isTaxInclusive ?? false,
//   };
// }
