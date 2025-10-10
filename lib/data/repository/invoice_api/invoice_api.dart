import 'package:payzo_books/data/models/invoice_model/invoice_detail_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetInvoiceDetailsRepository {
  final BaseApiService _apiService;
  GetInvoiceDetailsRepository(this._apiService);

  Future<InvoiceDetailModel> fetchInvoiceDetailsData(int invoiceId) async {
    try {
      print('Fetching invoice details for invoiceId: $invoiceId');

      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/invoice/getInvoiceByInvoiceId?invoiceId=$invoiceId",
        fromJson: (json) {
          print(
              'Invoice detail API response received for invoiceId $invoiceId');
          return InvoiceDetailModel.fromMap(json);
        },
      );

      print('Invoice detail result for invoiceId $invoiceId:');
      print('- Invoice ID: ${result.invoiceId}');
      print('- Invoice Number: ${result.invoiceNumber}');
      print('- Customer Name: ${result.invoiceCustomerName}');

      return result;
    } catch (e) {
      print('Error fetching invoice details for invoiceId $invoiceId: $e');

      return InvoiceDetailModel.empty();
    }
  }
}

final getInvoicesDetailsData = Provider<GetInvoiceDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetInvoiceDetailsRepository(apiService);
});

final getInvoiceDetailsProvider =
    FutureProvider.family<InvoiceDetailModel, int>((ref, invoiceId) async {
  print('getInvoiceDetailsProvider called for invoiceId: $invoiceId');
  final repository = ref.read(getInvoicesDetailsData);
  final result = await repository.fetchInvoiceDetailsData(invoiceId);
  print('Invoice details fetched for invoiceId $invoiceId');
  return result;
});
