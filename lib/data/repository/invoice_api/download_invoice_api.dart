import 'package:payzo_books/data/models/invoice_model/invoice_download_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class DownloadInvoiceRepository {
  final BaseApiService _apiService;
  DownloadInvoiceRepository(this._apiService);

  Future<InvoiceDownloadModel> downloadInvoicePdf(int invoiceId) async {
    try {
      print('Fetching invoice details for invoiceId: $invoiceId');

      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/invoice/downloadInvoicePdf?invoiceId=$invoiceId&action=download",
        fromJson: (json) {
          print(
              'Invoice detail API response received for invoiceId $invoiceId');
          return InvoiceDownloadModel.fromMap(json);
        },
      );

      print('Invoice download result for invoiceId $invoiceId:');
      print('- data: ${result.data.substring(0, 50)}... (truncated)');
      print('- file name: ${result.fileName}');
      print('- status: ${result.status}');
      print('- type: ${result.type}');

      return result;
    } catch (e) {
      print('Error fetching invoice details for invoiceId $invoiceId: $e');

      return InvoiceDownloadModel.empty();
    }
  }
}

final downloadInvoiceRepositoryProvider =
    Provider<DownloadInvoiceRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DownloadInvoiceRepository(apiService);
});

final downloadInvoicePdfProvider =
    FutureProvider.family<InvoiceDownloadModel, int>((ref, invoiceId) async {
  print('downloadInvoicePdfProvider called for invoiceId: $invoiceId');
  final repository = ref.read(downloadInvoiceRepositoryProvider);
  final result = await repository.downloadInvoicePdf(invoiceId);
  print('Invoice download details fetched for invoiceId $invoiceId');
  return result;
});
