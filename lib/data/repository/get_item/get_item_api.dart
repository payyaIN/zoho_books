import 'package:payzo_books/data/models/get_item/get_item_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetItemsRepository {
  final BaseApiService _apiService;
  GetItemsRepository(this._apiService);

  Future<GetItemModel> fetchItemsData() async {
    try {
      print('Fetching items data...');
      return await _apiService.getApi(
        url: "apiUrl/items/getItems",
        fromJson: (json) {
          print('Items API response received');
          return GetItemModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching items data: $e');
      return GetItemModel.empty();
    }
  }
}

final getItemsRepository = Provider<GetItemsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetItemsRepository(apiService);
});

final getItemsData = FutureProvider<GetItemModel>((ref) async {
  print('getItemsData provider called');
  final repository = ref.read(getItemsRepository);
  final result = await repository.fetchItemsData();
  print('Items data fetched: ${result.data.length} items');
  return result;
});
