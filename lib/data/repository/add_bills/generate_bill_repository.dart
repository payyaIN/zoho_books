import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:payzo_books/data/mapper/bill_mapper.dart';
import 'package:payzo_books/data/models/add_bills/generate_bill_response.dart';
import 'package:payzo_books/data/repository/add_bills/get_all_bills_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_item_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/shipping_method_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import '../../../import_data.dart';

class GenerateBillRepository {
  final BaseApiService apiService;

  GenerateBillRepository(this.apiService);

  Future<BillResponse> submitBill({
    required Map<String, dynamic> billDto,
    File? billAttach,
    required String token,
  }) async {
    final uri = Uri.parse(
        'http://81.208.173.149/pb-process-service/bill/generateBillWf');

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'authorization': 'Bearer $token',
        'company-id': '1',
        'locale': 'en',
      })
      ..files.add(http.MultipartFile.fromString(
        'billDto',
        jsonEncode(billDto),
        contentType: MediaType('application', 'json'),
        filename: 'blob',
      ));

    if (billAttach != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'billAttach',
        billAttach.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    debugPrint('📤 Submitting Bill DTO: ${jsonEncode(billDto)}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (jsonResponse['code'] == 'FAILED') {
      throw Exception(jsonResponse['message'] ?? 'Bill generation failed.');
    }

// 🔥 Force details to be empty list if null
    if (jsonResponse['details'] == null || jsonResponse['details'] is! List) {
      jsonResponse['details'] = [];
    }

    final billResponse = BillResponse.fromJson(jsonResponse);

// 🔥 Now check if billResponse.details is empty
    if (billResponse.details == null || billResponse.details!.isEmpty) {
      debugPrint('⚠️ Warning: Bill generated but no details returned.');
    }

    return billResponse;
  }
}
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
  if (token == null) throw Exception('❌ Missing access token.');

  return ref.read(generateBillRepositoryProvider).submitBill(
    billDto: dto,
    billAttach: file,
    token: token,
  );
});

final billNameIdProvider = StateProvider<int>((ref) => 0);
