import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_vendor/get_state_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

import '../../../import_data.dart';


final countryCodeProvider = StateProvider<String>((ref) => '179');
final countryPhoneProvider = StateProvider<String>((ref) => '+966');
final countryCodeMobileProvider = StateProvider<String>((ref) => '179');
final countryPhoneMobileProvider = StateProvider<String>((ref) => '+966');
final countryFlagProvider = StateProvider<String>((ref) => 'sa');
final countryFlagMobileProvider = StateProvider<String>((ref) => 'sa');

class GetStateListRepository {
  final BaseApiService _apiService;
  final Ref _ref;

  GetStateListRepository(this._apiService, this._ref);

  Future<GetStateListModel> fetchData() async {
    final countryCode = _ref.watch(countryCodeProvider);
    if (countryCode.isEmpty) {
      return GetStateListModel(
          response: []); // return empty model if code is empty
    }
    return _apiService.getApi(
      url:
          'http://158.101.247.195/pb-common-service/api/companyInfo/getStateList?Id=$countryCode',
      fromJson: (json) => GetStateListModel.fromJson(json),
    );
  }
}

final getStateListProvider = Provider<GetStateListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetStateListRepository(apiService, ref);
});

final getStateList = FutureProvider<GetStateListModel>((ref) async {
  final repository = ref.watch(getStateListProvider);
  return repository.fetchData();
});
