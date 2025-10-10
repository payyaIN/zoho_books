import 'package:payzo_books/data/models/rfq_model/download_rfq_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

import '../../../import_data.dart';

class DownloadRfqRepository {
  final BaseApiService _apiService;
  DownloadRfqRepository(this._apiService);

  Future<RfqDownloadModel> downloadRfqPdf(int rfqId) async {
    try {
      print(' Fetching RFQ PDF for rfqId: $rfqId');

      final result = await _apiService.getApi(
        url: "http://81.208.173.149/pb-process-service/rfq/downloadRfqPdf?rfqId=$rfqId",
        fromJson: (json) {
          print(' RFQ PDF API response received');
          return RfqDownloadModel.fromJson(json);
        },
      );

      print('-  File Name: ${result.fileName}');
      print('-  Status: ${result.status}');
      print('-  Data (truncated): ${result.data?.substring(0, 50)}...');

      return result;
    } catch (e) {
      print(' Error downloading RFQ PDF: $e');
      return RfqDownloadModel.empty(); // Add empty constructor in model
    }
  }
}
final downloadRfqRepositoryProvider = Provider<DownloadRfqRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DownloadRfqRepository(apiService);
});

final downloadRfqPdfProvider =
FutureProvider.family<RfqDownloadModel, int>((ref, rfqId) async {
  print(' downloadRfqPdfProvider called for rfqId: $rfqId');
  final repo = ref.read(downloadRfqRepositoryProvider);
  final result = await repo.downloadRfqPdf(rfqId);
  print(' RFQ PDF fetched for rfqId: $rfqId');
  return result;
});
//how to use:
// final rfqPdfAsyncValue = ref.watch(downloadRfqPdfProvider(rfqId));
//
// rfqPdfAsyncValue.when(
// data: (pdf) {
// // Use `pdf.data` for base64
// // Use `pdf.fileName` to show name
// },
// loading: () => CircularProgressIndicator(),
// error: (err, stack) => Text('Error loading PDF'),
// );
