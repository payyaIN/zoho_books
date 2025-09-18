import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/country_list/get_country_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetCountryListRepository {
  final BaseApiService _apiService;
  GetCountryListRepository(this._apiService);

  Future<GetCountryListModel> fetchData() {
    return _apiService.getApi(
      url:
          'http://158.101.247.195/pb-common-service/api/companyInfo/getCountryList',
      fromJson: (json) => GetCountryListModel.fromJson(json),
    );
  }
}

final getCountryListProvider = Provider<GetCountryListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetCountryListRepository(apiService);
});
