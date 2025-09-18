// tax_api.dart
import 'package:payzo_books/data/models/tax/tax_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetTaxListRepository {
  final BaseApiService _apiService;
  GetTaxListRepository(this._apiService);

  Future<GetTaxListModel> fetchTaxData() async {
    try {
      print('Fetching tax data...');
      return await _apiService.getApi(
        url: "apiUrl/taxes/getTaxList",
        fromJson: (json) {
          print('Tax API response received');
          return GetTaxListModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching tax data: $e');
      return GetTaxListModel.empty();
    }
  }
}

final getTaxListRepository = Provider<GetTaxListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetTaxListRepository(apiService);
});

final getTaxList = FutureProvider<GetTaxListModel>((ref) async {
  print('getTaxList provider called');
  final repository = ref.read(getTaxListRepository);
  final result = await repository.fetchTaxData();
  print('Tax data fetched successfully');
  return result;
});
