import 'package:payzo_books/data/models/tax/all_tax_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetAllTaxListRepository {
  final BaseApiService _apiService;
  GetAllTaxListRepository(this._apiService);

  Future<GetAllTaxListModel> fetchTaxListData() async {
    try {
      print('Fetching tax list data...');
      return await _apiService.getApi(
        url: "apiUrl//taxes/getAllTaxList",
        fromJson: (json) {
          print('Tax list API response received');
          return GetAllTaxListModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching tax list data: $e');
      return GetAllTaxListModel.empty();
    }
  }
}

final getAllTaxListData = Provider<GetAllTaxListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllTaxListRepository(apiService);
});

final getTaxListData = FutureProvider<GetAllTaxListModel>((ref) async {
  print('getTaxListData provider called');
  final repository = ref.read(getAllTaxListData);
  final result = await repository.fetchTaxListData();
  print('Tax list data fetched successfully');
  return result;
});
