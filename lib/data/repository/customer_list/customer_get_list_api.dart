import 'package:payzo_books/data/models/customer_model/customer_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetCustomerListRepository {
  final BaseApiService _apiService;
  GetCustomerListRepository(this._apiService);

  Future<GetCustomerListModel> fetchCustomerListData() async {
    try {
      print('Fetching customer list data...');
      return await _apiService.getApi(
        url: "apiUrl/process/getCustomerList",
        fromJson: (json) {
          print('Customer list API response received');
          return GetCustomerListModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching customer list data: $e');
      return GetCustomerListModel.empty();
    }
  }
}

final getCustomerListRepository = Provider<GetCustomerListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetCustomerListRepository(apiService);
});

final getCustomerListData = FutureProvider<GetCustomerListModel>((ref) async {
  print('getCustomerListData provider called');
  final repository = ref.read(getCustomerListRepository);
  final result = await repository.fetchCustomerListData();
  print(
      'Customer list data fetched: ${result.response.response.length} customers');
  return result;
});
