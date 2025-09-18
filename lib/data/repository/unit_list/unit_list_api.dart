import 'package:payzo_books/data/models/unit_list_model/unit_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetUnitListRepository {
  final BaseApiService _apiService;
  GetUnitListRepository(this._apiService);

  Future<UnitListModel> fetchUnitListData() async {
    try {
      print('Fetching unit list data...');
      return await _apiService.getApi(
        url: "apiUrl//rfq/getUnitList",
        fromJson: (json) {
          print('Unit list API response received');
          if (json is List) {
            return UnitListModel.fromList(json as List);
          } else {
            print('Warning: Expected a list response but got an object');
            return UnitListModel.empty();
          }
        },
      );
    } catch (e) {
      print('Error fetching unit list data: $e');
      return UnitListModel.empty();
    }
  }
}

final getUnitListRepository = Provider<GetUnitListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetUnitListRepository(apiService);
});

final getUnitListData = FutureProvider<UnitListModel>((ref) async {
  print('getUnitListData provider called');
  final repository = ref.read(getUnitListRepository);
  final result = await repository.fetchUnitListData();
  print('Unit list data fetched: ${result.units.length} units');
  return result;
});
