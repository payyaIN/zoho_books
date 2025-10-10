import 'package:payzo_books/data/models/bill_model/bill_detail_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetBillDetailsRepository {
  final BaseApiService _apiService;
  GetBillDetailsRepository(this._apiService);

  Future<BillDetailModel> fetchBillDetailsData(int billId) async {
    try {
      print('Fetching bill details for billId: $billId');

      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/bill/getBillByBillId?billId=$billId",
        fromJson: (json) {
          print('Bill detail API response received for billId $billId');
          return BillDetailModel.fromMap(json);
        },
      );

      print('Bill detail result for billId $billId:');
      print('- Bill ID: ${result.billId}');
      print('- Bill Invoice Number: ${result.billInvoiceNumber}');
      print('- Vendor Name: ${result.billVenderName}');

      return result;
    } catch (e) {
      print('Error fetching bill details for billId $billId: $e');

      return BillDetailModel.empty();
    }
  }
}

final getBillsDetailsData = Provider<GetBillDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetBillDetailsRepository(apiService);
});

final getBillDetailsProvider =
    FutureProvider.family<BillDetailModel, int>((ref, billId) async {
  print('getBillDetailsProvider called for billId: $billId');
  final repository = ref.read(getBillsDetailsData);
  final result = await repository.fetchBillDetailsData(billId);
  print('Bill details fetched for billId $billId');
  return result;
});
