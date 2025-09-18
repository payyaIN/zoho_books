import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/pending_counts/get_pending_counts_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetPendingRequestsCount {
  final BaseApiService _apiService;
  GetPendingRequestsCount(this._apiService);

  Future<PendingCounts> fetchData() {
    return _apiService.getApi(
      url: 'http://158.101.247.195/pb-process-service/common/pendingCounts',
      fromJson: (json) => PendingCounts.fromJson(json),
    );
  }
}

final getPendingRequestCountProvider = Provider<GetPendingRequestsCount>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetPendingRequestsCount(apiService);
});
final pendingCountsFutureProvider = FutureProvider<PendingCounts>((ref) {
  final repo = ref.read(getPendingRequestCountProvider);
  return repo.fetchData();
});
