import 'package:http/http.dart' as http;
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import '../../../import_data.dart';

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
    final url = Uri.parse(
        'http://81.208.173.149/pb-process-service/bill/getBillModal');

    final productDetails = state.itemDetails.map((item) {
      return {
        "billProdId": 1,
        "billProdName": item.itemName ?? "Sample Product",
        "billProdCatId": 1,
        "billProdDesc": "Description",
        "billProdTax": {"taxId": 1, "taxType": "non-taxable"},
        "billProdTaxExmptionReason": "Reason",
        "billProdAccount": int.tryParse(item.account ?? '') ?? 0,
        "billProdQuantity": item.quantity ?? 0,
        "billProdUnitId": int.tryParse(item.unitType ?? '') ?? 0,
        "billProdUnitPrice": item.amount ?? 0.0,
        "billProdCustomerId": 1,
        "billProdTotalAmount":
            ((item.quantity ?? 0) * (item.amount ?? 0)).toInt(),
        "billProdTaxAmount": 0,
        "billProdDiscountAmount": null,
        "billProdDiscountPercentage": null,
        "billProdOthersAmount": null,
        "billProdTaxDesc": null,
        "billProdOthersDesc": null,
      };
    }).toList();

    final payload = {
      "billVendorId": int.tryParse(state.vendor ?? '') ?? 0,
      "billCustomerId": null,
      "billBranchId": int.tryParse(state.branch ?? '') ?? 1,
      "billInvoiceNumber": state.billRefNo,
      "billOrderNumber": state.orderNo,
      "billDate": state.billDate?.toIso8601String(),
      "billDueDate": state.dueDate?.toIso8601String(),
      "billShippingType": int.tryParse(state.shippingMethod ?? '') ?? 3,
      "billCurrencyId": int.tryParse(state.currency ?? '') ?? 1,
      "billPaymentTerms": state.terms,
      "billOrgId": null,
      "billCmpCr": null,
      "billCustomerNotes": state.customerNotes,
      "billTermsCondition": state.terms,
      "billAmount": state.total?.toInt() ?? 0,
      "billTotalAmount": state.total?.toInt() ?? 0,
      "isModalShown": 0,
      "billDiscountPercentage": 0,
      "billProductDetails": productDetails,
      "billAttachFile": null
    };

    final headers = await _getHeaders();

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    // Important: this sets `billDto` field as JSON string (not file)
    request.fields['billDto'] = jsonEncode(payload);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint("🔁 Status Code: ${response.statusCode}");
    debugPrint("🔁 Body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['html'] ?? "<h3>No HTML Found</h3>";
    } else {
      throw Exception(
          'POST API call failed with status code: ${response.statusCode}');
    }
  }
}

final addBillRepoProvider = Provider<AddBillRepository>((ref) {
  return AddBillRepository(ref);
});
