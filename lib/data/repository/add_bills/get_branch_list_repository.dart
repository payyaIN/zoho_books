import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_bills/get_branch_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetBranchListRepository {
  final BaseApiService _apiService;
  GetBranchListRepository(this._apiService);

  Future<BranchListResponse> fetchBranchList() async {
    const url =
        'http://81.208.173.149/pb-common-service/api/branches/getAllBranchList';
    return _apiService.getApi(
      url: url,
      fromJson: (json) => BranchListResponse.fromJson(json),
    );
  }
}

final getBranchListProvider = Provider<GetBranchListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetBranchListRepository(apiService);
});

final fetchBranchListProvider = FutureProvider<BranchListResponse>((ref) async {
  return ref.watch(getBranchListProvider).fetchBranchList();
});
