import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_bills/get_price_currency.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
class GetPriceCurrencyRepository {
  final BaseApiService apiService;
  GetPriceCurrencyRepository(this.apiService);

  Future<List<GetPriceCurrency>> fetchShippingMethods() {
    return apiService.getListApi(
      url: 'http://81.208.173.149/pb-process-service/rfq/getPriceCurrency',
      fromJson: (json) => GetPriceCurrency.fromJson(json),
    );
  }
}

final getPriceCurrencyRepoProvider = Provider<GetPriceCurrencyRepository>((ref) {
  return GetPriceCurrencyRepository(ref.read(apiServiceProvider));
});

final fetchPriceCurrencyProvider = FutureProvider<List<GetPriceCurrency>>((ref) {
  return ref.read(getPriceCurrencyRepoProvider).fetchShippingMethods();
});



