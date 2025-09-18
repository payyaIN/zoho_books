import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_bills/get_item_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetItemListRepository {
  final BaseApiService apiService;
  GetItemListRepository(this.apiService);

  Future<List<Item>> fetchItemList() {
    return apiService.getApi(
      url: 'http://158.101.247.195/pb-item-service/v1/items/getItems',
      fromJson: (json) {
        final dataList = json['data'] as List<dynamic>;
        return dataList.map((itemJson) => Item.fromJson(itemJson)).toList();
      },
    );
  }
}


final getItemListRepoProvider = Provider<GetItemListRepository>((ref) {
  return GetItemListRepository(ref.read(apiServiceProvider));
});

final fetchItemListProvider = FutureProvider<List<Item>>((ref) {
  return ref.read(getItemListRepoProvider).fetchItemList();
});
