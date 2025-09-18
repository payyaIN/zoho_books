import 'package:payzo_books/data/models/current_country.dart/current_country_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetCurrentCountryRepository {
  final BaseApiService _apiService;
  GetCurrentCountryRepository(this._apiService);

  Future<GetCurrentCountryModel> fetchCurrentCountryData() async {
    try {
      print('Fetching current country data...');
      return await _apiService.getApi(
        url: "apiUrl/taxes/getCurrentCountry",
        fromJson: (json) {
          print('Current country API response received');
          return GetCurrentCountryModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching current country data: $e');
      return GetCurrentCountryModel.empty();
    }
  }
}

final getCurrentCountryRepository =
    Provider<GetCurrentCountryRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetCurrentCountryRepository(apiService);
});

final getCurrentCountryData =
    FutureProvider<GetCurrentCountryModel>((ref) async {
  print('getCurrentCountryData provider called');
  final repository = ref.read(getCurrentCountryRepository);
  final result = await repository.fetchCurrentCountryData();
  print('Current country data fetched: countryCode ${result.countryCode}');
  return result;
});
