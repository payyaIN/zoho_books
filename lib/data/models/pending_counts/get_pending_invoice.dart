// PENDING INVOICE REPO
import 'package:payzo_books/data/models/invoice_model/invoice_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetPendingInvoiceRepository {
  final BaseApiService _apiService;

  GetPendingInvoiceRepository(this._apiService);

  Future<InvoiceModel> fetchPendingInvoices() {
    return _apiService.postApi(
      url: "http://81.208.173.149/pb-process-service/invoice/getAllInvoice",
      body: {
        "requestCriteria": {
          "invoiceStatus": "1",
          "invoiceIsVerified": "0",
        },
        "sortingCriteria": {"field": "invoiceCreatedDate", "order": "-1"},
        "rowPerPage": 1000,
        "pageNo": 0
      },
      fromJson: (json) => InvoiceModel.fromMap(json),
    );
  }
}

final getPendingInvoiceRepoProvider = Provider<GetPendingInvoiceRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetPendingInvoiceRepository(apiService);
});

final pendingInvoicesProvider = FutureProvider<InvoiceModel>((ref) async {
  final repo = ref.read(getPendingInvoiceRepoProvider);
  return repo.fetchPendingInvoices();
});