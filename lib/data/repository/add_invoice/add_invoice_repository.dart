import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:payzo_books/data/services/shared_preference_service.dart';
import 'package:payzo_books/view/add_invoice/model/add_invoice_form_model.dart';

class InvoiceRepository {
  Future<Map<String, dynamic>> submitInvoiceWithAttachment({
    required Map<String, dynamic> invoiceDto,
    File? file, // ✅ Make this optional
  }) async {
    final uri = Uri.parse(
      'http://158.101.247.195/pb-process-service/invoice/generateInvoiceWf',
    );

    final request = http.MultipartRequest('POST', uri);

    // 🛡️ Token and headers
    final accessToken = SharedPreferencesHelper.getString('access_token');

    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'multipart/form-data',
      'TransactionId': '345345345',
      'company-id': '1',
      'Accept': 'application/json',
    });

    // 📎 Attach JSON and File
    request.files.add(
      http.MultipartFile.fromString(
        'invoiceDto',
        jsonEncode(invoiceDto),
        filename: 'invoice.json',
        contentType: MediaType('application', 'json'),
      ),
    );

    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'invoiceAttach',
          file.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }


    print('🔼 Submitting invoice...');
    print('Headers: ${request.headers}');
    print('Body: ${jsonEncode(invoiceDto)}');

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    print("📥 Status Code: ${response.statusCode}");
    print("📥 Body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed with status code ${response.statusCode}');
    }

    final responseData = jsonDecode(response.body);

    if (responseData['code'] != 'SUCCESS') {
      throw Exception('Invoice generation failed: ${responseData['message']}');
    }

    return responseData;
  }


  /// ✅ Build JSON as required in your working Postman format
  // ✅ Corrected invoice JSON builder based on working payload
  Map<String, dynamic> buildInvoiceJson(InvoiceFormModel state) {
    final item = state.itemDetails.first;
    final total = (item.amount ?? 0) * (item.quantity ?? 0);

    return {
      "invCustomerId": state.customerId ?? 0,
      "invOrgId": state.orgId == 1 ? null : state.orgId,
      "invBranchId": 2, // ✅ updated from 1
      "invBankAccId": 19, // ✅ updated from 50
      "invPaymentTerms": state.paymentTerms ?? '',
      "invProductDetails": [
        {
          "invProdId": item.prodId ?? 0,
          "invProdCatId": item.prodCatId ?? 1, // Add this in your ItemDetail model if needed
          // "invProdTax": {"taxId": 1, "taxType": "default"},
          "invProdTax": {
            "taxId": 1,
            "taxType": "default", // ← not "out-of-scope"
          },
          "invProdTaxExmptionReason": item.exemptionReason ?? '',
          "invProdQuantity": item.quantity ?? 0,
          "invProdUnitId": item.unitId ?? 1,
          "invProdDiscountAmount": 0,
          "invProdOthersAmount": 0,
          "invProdName": item.itemName ?? 'Unknown',
          "invProdUnitPrice": item.amount ?? 0,
          "invProdTaxAmount": item.taxAmount ?? total,
          "invProdOthersDesc": item.othersDescription,
          "invProdDesc": item.description ?? '',
          "invProdTaxDesc": item.taxDescription,
          "invProdTotalAmount": total,
          "invProdDiscountPercentage": item.discountPercentage,
          "invPercentage": item.percentage
        }
      ],
      "invCustomerNotes": state.customerNotes ?? '',
      "invTermsAndConditions": state.terms ?? '',
      "invShippingType": 3, // ✅ match correct shipping type
      "invOrderNumber": state.orderNo ?? '',
      "invDate": state.invoiceDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      "invSupplyDate": state.supplyDate?.toIso8601String() ?? DateTime.now().add(Duration(days: 30)).toIso8601String(),
      "invDueDate": state.expiryDate?.toIso8601String() ?? DateTime.now().add(Duration(days: 39)).toIso8601String(),
      "invType": 1,
      "invAdvance": false,
      "invDelivery": false,
      "invAmount": total,
      "invPercentage": null,
      "invTotalAmount": total,
      "invCurrency": 1, // ✅ updated from 4 or 7
      "isModalShown": 0, // ✅ corrected from 1
      "invNumber": state.invoiceRefNo ?? "INV${DateTime.now().millisecondsSinceEpoch}"
    };
  }
}

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository();
});
