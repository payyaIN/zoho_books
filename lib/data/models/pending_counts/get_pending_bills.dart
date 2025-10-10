// PENDING BILL REPO
import 'package:payzo_books/data/models/bill_model/bill_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetPendingBillRepository {
  final BaseApiService _apiService;

  GetPendingBillRepository(this._apiService);

  Future<BillModel> fetchPendingBills() {
    return _apiService.postApi(
      url: "http://81.208.173.149/pb-process-service/bill/getAllBill",
      body: {
        "requestCriteria": {
          "billStatus": "1",
          "billIsVerified": "0",
        },
        "sortingCriteria": {"field": "billCreatedDate", "order": "-1"},
        "rowPerPage": 1000,
        "pageNo": 0
      },
      fromJson: (json) => BillModel.fromMap(json),
    );
  }
}

final getPendingBillRepoProvider = Provider<GetPendingBillRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetPendingBillRepository(apiService);
});

final pendingBillsProvider = FutureProvider<BillModel>((ref) async {
  final repo = ref.read(getPendingBillRepoProvider);
  return repo.fetchPendingBills();
});
