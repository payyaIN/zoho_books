import 'package:payzo_books/data/models/bill_model/download_bill_pdf_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class DownloadBillRepository {
  final BaseApiService _apiService;
  DownloadBillRepository(this._apiService);

  Future<BillDownloadModel> downloadBillPdf(int billId) async {
    try {
      print('Fetching bill details for billId: $billId');

      final result = await _apiService.getApi(
        url:
            "http://158.101.247.195/pb-process-service/bill/downloadBillPdf?billId=$billId",
        fromJson: (json) {
          print('Bill detail API response received for billId $billId');
          return BillDownloadModel.fromMap(json);
        },
      );

      print('bill download result for billId $billId:');
      print('- data: ${result.data.substring(0, 50)}... (truncated)');
      print('- file name: ${result.fileName}');
      print('- status: ${result.status}');
      print('- type: ${result.type}');

      return result;
    } catch (e) {
      print('Error fetching bill details for billId $billId: $e');

      return BillDownloadModel.empty();
    }
  }
}

final downloadBillRepositoryProvider = Provider<DownloadBillRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DownloadBillRepository(apiService);
});

final downloadBillPdfProvider =
    FutureProvider.family<BillDownloadModel, int>((ref, billId) async {
  print('downloadBillPdfProvider called for billId: $billId');
  final repository = ref.read(downloadBillRepositoryProvider);
  final result = await repository.downloadBillPdf(billId);
  print('Bill download details fetched for billId $billId');
  return result;
});
