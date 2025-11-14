// lib/data/providers/generate_bill_providers.dart
// Combined: GenerateBillRepository + providers + updated DTO builder (buildBillDtoFromForm)

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:payzo_books/data/models/add_bills/generate_bill_response.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/view/add/add_billls/model/add_bill_form_model.dart';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';
import 'package:payzo_books/data/models/add_bills/get_item_model.dart';
import 'package:payzo_books/data/models/add_invoice/get_tax_list_model.dart';
import 'package:payzo_books/data/models/add_bills/get_all_accounts.dart';
import 'package:payzo_books/data/models/add_bills/get_venor_list_model.dart';
import 'package:payzo_books/data/models/add_bills/get_branch_list_model.dart';
import 'package:payzo_books/data/models/add_bills/get_price_currency.dart';
import 'package:payzo_books/data/models/add_bills/shipping_method_model.dart';

import 'package:payzo_books/data/repository/add_bills/get_all_bills_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_item_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/shipping_method_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';

import 'package:payzo_books/import_data.dart'; // adjust path if required
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';

/// ------------------------- Repository -------------------------
class GenerateBillRepository {
  final BaseApiService apiService;

  GenerateBillRepository(this.apiService);

  Future<BillResponse> submitBill({
    required Map<String, dynamic> billDto,
    File? billAttach,
    required String token,
  }) async {
    final uri = Uri.parse('http://81.208.173.149/pb-process-service/bill/generateBillWf');

    // Build multipart request
    final request = http.MultipartRequest('POST', uri);

    // Important: DO NOT set Content-Type header here; MultipartRequest will set it with boundary.
    request.headers.addAll({
      'authorization': 'Bearer $token',
      'company-id': '1',
      'locale': 'en',
    });

    // Add billDto JSON as a part named 'billDto' with filename 'blob'
    request.files.add(
      http.MultipartFile.fromString(
        'billDto',
        jsonEncode(billDto),
        contentType: MediaType('application', 'json'),
        filename: 'blob',
      ),
    );

    // If there's an attachment, add it using BOTH common field names to maximize backend compatibility:
    // - 'billAttach' (used in some examples)
    // - 'file' (common generic name)
    if (billAttach != null && await billAttach.exists()) {
      final ext = billAttach.path.split('.').last.toLowerCase();
      final MediaType contentType;
      if (ext == 'pdf') {
        contentType = MediaType('application', 'pdf');
      } else if (ext == 'png') {
        contentType = MediaType('image', 'png');
      } else if (ext == 'jpg' || ext == 'jpeg') {
        contentType = MediaType('image', 'jpeg');
      } else {
        contentType = MediaType('application', 'octet-stream');
      }

      // Add as 'billAttach'
      request.files.add(
        await http.MultipartFile.fromPath(
          'billAttach',
          billAttach.path,
          contentType: contentType,
          filename: billAttach.path.split(Platform.pathSeparator).last,
        ),
      );

      // Also add as 'file' (some backends expect this field name)
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          billAttach.path,
          contentType: contentType,
          filename: billAttach.path.split(Platform.pathSeparator).last,
        ),
      );
    }

    debugPrint('📤 Submitting Bill DTO: ${jsonEncode(billDto)}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('📥 HTTP ${response.statusCode} ${response.reasonPhrase}');
    debugPrint('📥 Body: ${response.body}');

    // Handle non-2xx responses with attempt to parse body for helpful message
    if (response.statusCode < 200 || response.statusCode >= 300) {
      try {
        final parsed = jsonDecode(response.body);
        final serverMsg = parsed is Map && parsed['message'] != null ? parsed['message'].toString() : response.body;
        throw Exception('Server error (${response.statusCode}): $serverMsg');
      } catch (e) {
        // If parsing fails, throw raw body
        throw Exception('Server returned status ${response.statusCode}: ${response.body}');
      }
    }

    // Parse JSON response
    Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Failed to decode response body: ${response.body}');
      throw Exception('Invalid JSON response from server (status: ${response.statusCode})');
    }

    // Business-level error handling (optional)
    final serverCode = (jsonResponse['code'] ?? '').toString().toUpperCase();
    if (serverCode.isNotEmpty && serverCode != 'SUCCESS') {
      final msg = jsonResponse['message']?.toString() ?? 'Bill generation failed.';
      throw Exception(msg);
    }

    // Normalize details to empty list if null or not a list
    if (jsonResponse['details'] == null || jsonResponse['details'] is! List) {
      jsonResponse['details'] = <dynamic>[];
    }

    final billResponse = BillResponse.fromJson(jsonResponse);

    if (billResponse.details == null || billResponse.details!.isEmpty) {
      debugPrint('⚠️ Warning: Bill generated but no details returned.');
    }

    return billResponse;
  }
}

/// ------------------------- Providers -------------------------

final generateBillRepositoryProvider = Provider<GenerateBillRepository>((ref) {
  return GenerateBillRepository(ref.read(apiServiceProvider));
});

final generateBillProvider = FutureProvider.family<BillResponse, File?>((ref, file) async {
  final state = ref.read(addBillFormProvider);

  final itemList = await ref.read(fetchItemListProvider.future);
  final accountList = await ref.read(fetchAccountListProvider.future);
  final taxList = await ref.read(fetchAllTaxesProvider.future);
  final vendorList = (await ref.read(getVendorList.future)).response?.response ?? [];
  final branchList = (await ref.read(fetchBranchListProvider.future)).data ?? [];
  final currencyList = await ref.read(fetchPriceCurrencyProvider.future);
  final shippingList = await ref.read(fetchShippingMethodsProvider.future);

  final dto = buildBillDtoFromForm(
    state: state,
    itemList: itemList,
    accountList: accountList,
    taxOthers: taxList.others,
    taxDefaults: taxList.defaultTax,
    vendorList: vendorList,
    branchList: branchList,
    currencyList: currencyList,
    shippingList: shippingList,
  );

  final token = SharedPreferencesHelper.getString('access_token');
  if (token == null || token.isEmpty) throw Exception('❌ Missing access token.');

  return ref.read(generateBillRepositoryProvider).submitBill(
    billDto: dto,
    billAttach: file,
    token: token,
  );
});

final billNameIdProvider = StateProvider<int>((ref) => 0);

/// ------------------------- Updated DTO builder -------------------------
/// (This replaces the older mapper; paste this into bill_mapper.dart if you keep mappers separate)

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
        (e) => (e.itemName ?? '') == (name ?? ''),
    orElse: () => Item(itemId: 0, itemName: ''),
  ).itemId;

  int _findAccountId(String? name) => accountList.firstWhere(
        (e) => (e.accountName ?? '') == (name ?? ''),
    orElse: () => Account(accountId: 0, accountName: ''),
  ).accountId;

  Map<String, dynamic> _buildTax(String? taxName) {
    final combined = [
      ...taxOthers.map((t) => {'id': t.taxId, 'type': t.taxType, 'name': t.taxName}),
      ...taxDefaults.map((t) => {'id': t.taxId, 'type': t.taxType, 'name': t.taxName}),
    ];
    final match = combined.firstWhere(
          (e) => (e['name'] ?? '') == (taxName ?? ''),
      orElse: () => {'id': 0, 'type': 'default', 'name': ''},
    );

    return {
      'taxId': match['id'] ?? 0,
      'taxType': match['type'] ?? 'default',
    };
  }

  int? _findVendorId(String? name) {
    if (name == null || name.isEmpty) return null;
    final id = vendorList.firstWhere(
          (e) => (e.displayName ?? '') == name,
      orElse: () => VendorData(partyId: 0, displayName: ''),
    ).partyId;

    if (id == 0) {
      // let caller handle invalid vendor — still return null so DTO can be validated earlier
      return null;
    }
    return id;
  }

  int? _findBranchId(String? name) => branchList.firstWhere(
        (e) => (e.namePrimary ?? '') == (name ?? ''),
    orElse: () => BranchData(branchId: 0, namePrimary: ''),
  ).branchId;

  num _findCurrencyId(String? value) => currencyList.firstWhere(
        (e) => (e.currencyValue ?? '') == (value ?? ''),
    orElse: () => GetPriceCurrency(currencyId: 0, currencyValue: ''),
  ).currencyId ?? 0;

  int? _findShippingId(String? name) => shippingList.firstWhere(
        (e) => (e.shpmName ?? '') == (name ?? ''),
    orElse: () => ShippingMethodModel(shpmId: 0, shpmName: ''),
  ).shpmId;

  // Build product details safely (skip invalid/empty lines)
  final productDetails = state.itemDetails
      .where((item) =>
  (item.itemName?.isNotEmpty ?? false) &&
      ((item.quantity ?? 0) > 0) &&
      ((item.amount ?? 0) >= 0))
      .map((item) {
    final quantity = item.quantity ?? 0;
    final amount = (item.amount ?? 0.0);
    final totalAmount = amount * (quantity.toDouble());

    return {
      "billProdId": _findItemId(item.itemName),
      "billProdName": item.itemName ?? '',
      "billProdCatId": item.prodCatId ?? 2,
      "billProdDesc": item.description ?? '',
      "billProdTax": _buildTax(item.taxType),
      "billProdTaxExmptionReason": item.exemptionReason ?? '',
      "billProdTaxDesc": item.taxDescription ?? '',
      "billProdOthersDesc": item.othersDescription ?? '',
      "billProdAccount": _findAccountId(item.account),
      "billProdQuantity": quantity,
      "billProdUnitId": item.unitId ?? 4,
      "billProdUnitPrice": amount,
      "billProdCustomerId": item.customerId ?? 0,
      "billProdTotalAmount": totalAmount,
      "billProdTaxAmount": item.taxAmount ?? 0.0,
      "billProdDiscountAmount": item.discountAmount ?? 0.0,
      "billProdDiscountPercentage": item.discountPercentage ?? 0.0,
      "billProdDiscountType": (item.discountIsCurrency == true) ? 'FIXED' : 'PERCENTAGE',
      "billProdOthersAmount": item.othersAmount ?? 0.0,
    };
  }).toList();

  // Vendor id: prefer explicit vendorId in state; if missing, try name lookup (but don't throw)
  final vendorId = state.vendorId ?? _findVendorId(state.vendor);

  return {
    "billVendorId": vendorId,
    "billCustomerId": state.customerId,
    "billBranchId": _findBranchId(state.branch),
    "billInvoiceNumber": state.billRefNo ?? '',
    "billOrderNumber": state.orderNo ?? '',
    // keep full precision for dates & numbers
    "billDate": state.billDate?.toIso8601String(),
    "billDueDate": state.dueDate?.toIso8601String(),
    "billShippingType": _findShippingId(state.shippingMethod),
    "billCurrencyId": _findCurrencyId(state.currency),
    "billOrgId": state.orgId,
    "billCmpCr": state.cmpCr,
    "billPaidThroughAcc": state.paidThroughAccount ?? null,
    "billCustomerNotes": state.customerNotes ?? '',
    "billTermsCondition": state.terms ?? '',
    "billPaymentTerms": state.paymentTerms ?? '',
    // preserve decimals (do NOT round)
    "billAmount": state.subTotal ?? 0.0,
    "billTotalAmount": state.total ?? 0.0,
    "isModalShown": 1,
    // discount fields (defaults kept safe)
    "billDiscountType": state.discountType ?? 'FIXED',
    "billDiscountPercentage": state.discountPercentage ?? 0,
    "billDiscountAmount": state.discountAmount ?? 0.0,
    // new flags (present in new API example) with safe defaults
    "billType": state.billType ?? 1,
    "billAdvance": state.billAdvance ?? false,
    "billDelivery": state.billDelivery ?? false,
    // item details as built above
    "billProductDetails": productDetails,
    // meta fields
    "isIncoming": state.isIncoming ?? 0,
    "billStatus": state.billStatus,
    "billInfo": state.billInfo ?? '',
    "billDiscountMethod": state.discountMethod ?? 'LINE_ITEM_DISCOUNT',
    "taxMethod": state.taxMethod ?? 'TAX_EXCLUSIVE',
    "isTaxInclusive": state.isTaxInclusive ?? false,
  };
}
