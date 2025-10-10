import 'package:payzo_books/data/models/quotes_model/download_quotes_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

import '../../../import_data.dart';

class DownloadQuoteRepository {
  final BaseApiService _apiService;
  DownloadQuoteRepository(this._apiService);

  Future<QuoteDownloadModel> downloadQuotePdf(int quoteId) async {
    try {
      print('Fetching quote PDF for quoteId: $quoteId');

      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/quotation/getQuotesPdf?quoteId=$quoteId",
        fromJson: (json) {
          print('Quote PDF API response received for quoteId $quoteId');
          return QuoteDownloadModel.fromJson(json);
        },
      );

      print('Quote PDF result for quoteId $quoteId:');
      print('- data: ${result.data?.substring(0, 50)}... (truncated)');
      print('- file name: ${result.fileName}');
      print('- status: ${result.status}');
      print('- type: ${result.type}');

      return result;
    } catch (e) {
      print('Error downloading quote PDF for quoteId $quoteId: $e');
      return QuoteDownloadModel.empty();
    }
  }
}

final downloadQuoteRepositoryProvider =
    Provider<DownloadQuoteRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DownloadQuoteRepository(apiService);
});

final downloadQuotePdfProvider =
    FutureProvider.family<QuoteDownloadModel, int>((ref, quoteId) async {
  print('downloadQuotePdfProvider called for quoteId: $quoteId');
  final repository = ref.read(downloadQuoteRepositoryProvider);
  final result = await repository.downloadQuotePdf(quoteId);
  print('Quote PDF fetched for quoteId $quoteId');
  return result;
});
