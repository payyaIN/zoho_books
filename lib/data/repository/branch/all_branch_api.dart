import 'package:payzo_books/data/models/branch_model/all_branch_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetAllBranchListRepository {
  final BaseApiService _apiService;
  GetAllBranchListRepository(this._apiService);

  Future<GetAllBranchListModel> fetchBranchListData() async {
    try {
      print('Fetching branch list data...');
      return await _apiService.getApi(
        url: "apiUrl/branches/getAllBranchList",
        fromJson: (json) {
          print('Branch list API response received');
          return GetAllBranchListModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching branch list data: $e');
      return GetAllBranchListModel.empty();
    }
  }
}

final getAllBranchListRepository = Provider<GetAllBranchListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllBranchListRepository(apiService);
});

final getAllBranchListData = FutureProvider<GetAllBranchListModel>((ref) async {
  print('getAllBranchListData provider called');
  final repository = ref.read(getAllBranchListRepository);
  final result = await repository.fetchBranchListData();
  print('Branch list data fetched: ${result.data.length} branches');
  return result;
});
