import 'package:http/http.dart' as http;
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import '../../../import_data.dart';
import 'package:http_parser/http_parser.dart';

class AddBillRepository {
  final Ref ref;
  AddBillRepository(this.ref);

  Future<Map<String, String>> _getHeaders() async {
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    if (sharedPrefs == null) {
      throw Exception('SharedPreferences not initialized');
    }

    String? accessToken =
        SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

    print('Access Token: $accessToken');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken ?? ''}',
      'TransactionId': 'djadajadjafjdbfsjkdb',
      'company-id': '1',
      'locale': 'en',
    };
  }

  Future<String> submitBill() async {
    final state = ref.read(addBillFormProvider);
    final url = Uri.parse('http://81.208.173.149/pb-process-service/bill/getBillModal');

    // ✅ Build product list to match expected structure
    final productDetails = state.itemDetails.map((item) {
      return {
        "billProdId": item.prodId,
        "billProdName": item.itemName ?? "",
        "billProdCatId": item.prodCatId,
        "billProdDesc": item.description ?? "",
        "billProdTax": {
          "taxId": 1,
          "taxType": item.taxType ?? "default",
        },
        "billProdTaxExmptionReason": item.exemptionReason ?? "",
        "billProdAccount": int.tryParse(item.account ?? '') ?? 0,
        "billProdQuantity": item.quantity ?? 0,
        "billProdUnitId": item.unitId ?? 1,
        "billProdUnitPrice": item.amount ?? 0.0,
        "billProdCustomerId": item.customerId,
        "billProdTotalAmount": ((item.quantity ?? 0) * (item.amount ?? 0)).toDouble(),
        "billProdTaxAmount": item.taxAmount ?? 0.0,
        "billProdDiscountAmount": item.discountAmount ?? 0.0,
        "billProdDiscountPercentage": item.discountPercentage ?? 0.0,
        "billProdDiscountType": "FIXED",
        "billProdOthersAmount": item.othersAmount ?? 0.0,
        "billProdTaxDesc": item.taxDescription,
        "billProdOthersDesc": item.othersDescription,
        "billPercentage": item.percentage,
      };
    }).toList();

    // ✅ Final payload matching required JSON exactly
    final payload = {
      "billVendorId": state.vendorId,
      "billCustomerId": state.customerId,
      "billBranchId": int.tryParse(state.branch ?? '') ?? 1,
      "billInvoiceNumber": state.billRefNo ?? "",
      "billOrderNumber": state.orderNo ?? "",
      "billDate": state.billDate?.toIso8601String(),
      "billDueDate": state.dueDate?.toIso8601String(),
      "billCurrencyId": int.tryParse(state.currency ?? '') ?? 8,
      "billPaymentTerms": state.paymentTerms ?? "",
      "billPaidThroughAcc": null,
      "billOrgId": state.orgId,
      "billCmpCr": state.cmpCr,
      "billCustomerNotes": state.customerNotes ?? "",
      "billTermsCondition": state.terms ?? "",
      "billAmount": state.total ?? 0.0,
      "billTotalAmount": state.total ?? 0.0,
      "isModalShown": 0,
      "billDiscountType": "FIXED",
      "billDiscountPercentage": 0,
      "billDiscountAmount": state.itemDetails.fold<double>(
        0.0,
            (sum, item) => sum + (item.discountAmount ?? 0.0),
      ),
      "billType": 1,
      "billAdvance": false,
      "billDelivery": false,
      "billProductDetails": productDetails,
      "isIncoming": 0,
      "billStatus": null,
      "billInfo": "adasdasd",
      "billDiscountMethod": "GLOBAL_DISCOUNT",
    };

    final headers = await _getHeaders();

    // ✅ Multipart request with `billDto` JSON part
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.files.add(
      http.MultipartFile.fromString(
        'billDto',
        jsonEncode(payload),
        filename: 'blob',
        contentType: MediaType('application', 'json'),
      ),
    );

    // ✅ If attachment exists, add it too
    final file = state.attachment;
    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint("🔁 Status Code: ${response.statusCode}");
    debugPrint("🔁 Body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['html'] ?? "<h3>No HTML Found</h3>";
    } else {
      throw Exception(
          'POST API call failed with status code: ${response.statusCode}\n${response.body}');
    }
  }
}

final addBillRepoProvider = Provider<AddBillRepository>((ref) {
  return AddBillRepository(ref);
});
