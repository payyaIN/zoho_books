import 'package:payzo_books/data/models/rpt_every_type/rpt_every_type_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class RepeatTypeRepository {
  final BaseApiService _apiService;
  RepeatTypeRepository(this._apiService);

  Future<GetAllRptEveryTypeModel> fetchRepeatTypeData() async {
    try {
      print('Fetching repeat type data...');
      return await _apiService.getApi(
        url: "api/getAllRptEveryType",
        fromJson: (json) {
          print('Repeat type API response received');
          if (json is List) {
            return GetAllRptEveryTypeModel.fromList(json as List);
          } else {
            print('Warning: Expected a list response but got an object');
            return GetAllRptEveryTypeModel.empty();
          }
        },
      );
    } catch (e) {
      print('Error fetching repeat type data: $e');
      return GetAllRptEveryTypeModel.empty();
    }
  }
}

final repeatTypeRepository = Provider<RepeatTypeRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return RepeatTypeRepository(apiService);
});

final repeatTypeData = FutureProvider<GetAllRptEveryTypeModel>((ref) async {
  print('repeatTypeData provider called');
  final repository = ref.read(repeatTypeRepository);
  final result = await repository.fetchRepeatTypeData();
  print('Repeat type data fetched: ${result.items.length} items');
  return result;
});
