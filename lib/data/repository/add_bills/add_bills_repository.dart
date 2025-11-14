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

  /// Submit bill as multipart/form-data:
  /// Primary attempt: 'billDto' as a file-part (filename 'blob', content-type application/json).
  /// If the server rejects with 415/400 "Failed to read request", retries once sending
  /// billDto as a simple form field (`fields['billDto'] = jsonString`).
  Future<BillResponse> submitBill({
    required Map<String, dynamic> billDto,
    File? billAttach,
    required String token,
  }) async {
    final uri = Uri.parse('http://81.208.173.149/pb-process-service/bill/generateBillWf');

    // Encode DTO to JSON string
    final String jsonString;
    try {
      jsonString = jsonEncode(billDto);
    } catch (e, st) {
      debugPrint('❌ Failed to encode billDto: $e\n$st');
      rethrow;
    }

    debugPrint('📤 Submitting Bill DTO (initial attempt as multipart file-part) length=${jsonString.length}');
    debugPrint('📤 billDto JSON preview: ${jsonString.length > 1200 ? jsonString.substring(0, 1200) + " ... (truncated)" : jsonString}');

    // First attempt: send billDto as multipart FILE part (filename 'blob')
    http.Response response = await _sendMultipart(
      uri: uri,
      jsonString: jsonString,
      billAttach: billAttach,
      token: token,
      billDtoAsFilePart: true,
    );

    // If server returns 415 (Unsupported Media Type) or 400 with "Failed to read request",
    // attempt a single retry where billDto is sent as a form field instead of file-part.
    if (response.statusCode == 415 ||
        (response.statusCode == 400 && response.body.toLowerCase().contains('failed to read request'))) {
      debugPrint('⚠️ Server responded with ${response.statusCode}. Retrying with billDto as form field (fields["billDto"])...');

      // debug info from first response
      debugPrint('📥 First attempt HTTP ${response.statusCode}');
      debugPrint('📥 First attempt Body: ${response.body}');

      // Retry
      response = await _sendMultipart(
        uri: uri,
        jsonString: jsonString,
        billAttach: billAttach,
        token: token,
        billDtoAsFilePart: false, // send as fields['billDto']
      );
    } else {
      debugPrint('📥 First attempt HTTP ${response.statusCode}');
      debugPrint('📥 First attempt Body: ${response.body}');
    }

    // If still non-success, parse and throw
    if (response.statusCode < 200 || response.statusCode >= 300) {
      try {
        final parsed = jsonDecode(response.body);
        final serverMsg = (parsed is Map)
            ? (parsed['detail']?.toString() ?? parsed['message']?.toString() ?? response.body)
            : response.body;
        throw Exception('Server error (${response.statusCode}): $serverMsg');
      } catch (e) {
        throw Exception('Server returned status ${response.statusCode}: ${response.body}');
      }
    }

    // Parse JSON response safely
    Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Failed to decode response body: ${response.body}');
      throw Exception('Invalid JSON response from server (status: ${response.statusCode})');
    }

    // Business-level code check
    final serverCode = (jsonResponse['code'] ?? '').toString().toUpperCase();
    if (serverCode.isNotEmpty && serverCode != 'SUCCESS') {
      final msg = jsonResponse['message']?.toString() ?? 'Bill generation failed.';
      throw Exception(msg);
    }

    // Normalize details to avoid null/list casting issues
    if (jsonResponse['details'] == null || jsonResponse['details'] is! List) {
      jsonResponse['details'] = <dynamic>[];
    }

    final billResponse = BillResponse.fromJson(jsonResponse);

    if (billResponse.details == null || billResponse.details!.isEmpty) {
      debugPrint('⚠️ Warning: Bill generated but no details returned.');
    }

    return billResponse;
  }

  /// Helper: build and send multipart with option to add billDto as file-part or as field.
  Future<http.Response> _sendMultipart({
    required Uri uri,
    required String jsonString,
    File? billAttach,
    required String token,
    required bool billDtoAsFilePart,
  }) async {
    final request = http.MultipartRequest('POST', uri);

    // Provide required headers but DO NOT set Content-Type (MultipartRequest sets it).
    request.headers.addAll({
      'authorization': 'Bearer $token',
      'company-id': '1',
      'locale': 'en',
      'Accept': 'application/json',
    });

    // Add billDto either as file-part (filename 'blob') or as a regular form field.
    if (billDtoAsFilePart) {
      request.files.add(
        http.MultipartFile.fromString(
          'billDto',
          jsonString,
          filename: 'blob',
          contentType: MediaType('application', 'json'),
        ),
      );
      debugPrint('🔁 Added billDto as file-part "billDto" (filename=blob, content-type=application/json)');
    } else {
      // Some backends expect JSON payload inside a form-field (not a file part)
      request.fields['billDto'] = jsonString;
      debugPrint('🔁 Added billDto as form-field "billDto" (string JSON)');
    }

    // Attach file as 'billAttach' and also add second part 'file' (compatibility)
    if (billAttach != null && await billAttach.exists()) {
      try {
        final ext = billAttach.path.split('.').last.toLowerCase();
        final MediaType contentType;
        if (ext == 'pdf') {
          contentType = MediaType('application', 'pdf');
        } else if (ext == 'png') {
          contentType = MediaType('image', 'png');
        } else if (ext == 'jpg' || ext == 'jpeg') {
          contentType = MediaType('image', 'jpeg');
        } else if (ext == 'gif') {
          contentType = MediaType('image', 'gif');
        } else {
          contentType = MediaType('application', 'octet-stream');
        }

        final filename = billAttach.path.split(Platform.pathSeparator).last;

        // Primary name
        request.files.add(await http.MultipartFile.fromPath(
          'billAttach',
          billAttach.path,
          contentType: contentType,
          filename: filename,
        ));

        // Secondary name (some endpoints look for 'file')
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          billAttach.path,
          contentType: contentType,
          filename: filename,
        ));

        debugPrint('📎 Attached file: $filename (as billAttach + file) contentType=$contentType');
      } catch (e, st) {
        debugPrint('❌ Failed adding attachment: $e\n$st');
        rethrow;
      }
    } else {
      debugPrint('📎 No attachment supplied.');
    }

    // Send and convert to http.Response
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    debugPrint('📥 HTTP ${response.statusCode} ${response.reasonPhrase}');
    debugPrint('📥 Body: ${response.body}');
    return response;
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
/// (unchanged mapper from earlier)
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

  final vendorId = state.vendorId ?? _findVendorId(state.vendor);

  return {
    "billVendorId": vendorId,
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
    "billPaidThroughAcc": state.paidThroughAccount ?? null,
    "billCustomerNotes": state.customerNotes ?? '',
    "billTermsCondition": state.terms ?? '',
    "billPaymentTerms": state.paymentTerms ?? '',
    "billAmount": state.subTotal ?? 0.0,
    "billTotalAmount": state.total ?? 0.0,
    "isModalShown": 1,
    "billDiscountType": state.discountType ?? 'FIXED',
    "billDiscountPercentage": state.discountPercentage ?? 0,
    "billDiscountAmount": state.discountAmount ?? 0.0,
    "billType": state.billType ?? 1,
    "billAdvance": state.billAdvance ?? false,
    "billDelivery": state.billDelivery ?? false,
    "billProductDetails": productDetails,
    "isIncoming": state.isIncoming ?? 0,
    "billStatus": state.billStatus,
    "billInfo": state.billInfo ?? '',
    "billDiscountMethod": state.discountMethod ?? 'LINE_ITEM_DISCOUNT',
    "taxMethod": state.taxMethod ?? 'TAX_EXCLUSIVE',
    "isTaxInclusive": state.isTaxInclusive ?? false,
  };
}
