import 'package:payzo_books/data/models/shipping_model/shipping_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetShippingMethodRepository {
  final BaseApiService _apiService;
  GetShippingMethodRepository(this._apiService);

  Future<ShippingMethodModel> fetchShippingMethodData() async {
    try {
      print('Fetching shipping method data...');
      return await _apiService.getApi(
        url: "apiUrl/rfq/getShippingMethod",
        fromJson: (json) {
          print('Shipping method API response received');
          if (json is List) {
            return ShippingMethodModel.fromList(json as List);
          } else {
            print('Warning: Expected a list response but got an object');
            return ShippingMethodModel.empty();
          }
        },
      );
    } catch (e) {
      print('Error fetching shipping method data: $e');
      return ShippingMethodModel.empty();
    }
  }
}

final getShippingMethodRepository =
    Provider<GetShippingMethodRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetShippingMethodRepository(apiService);
});

final getShippingMethodData = FutureProvider<ShippingMethodModel>((ref) async {
  print('getShippingMethodData provider called');
  final repository = ref.read(getShippingMethodRepository);
  final result = await repository.fetchShippingMethodData();
  print('Shipping method data fetched: ${result.methods.length} methods');
  return result;
});
