import 'package:payzo_books/data/models/price_currency_model/price_currency_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

// class GetPriceCurrencyRepository {
//   final BaseApiService _apiService;
//   GetPriceCurrencyRepository(this._apiService);

//   Future<PriceCurrencyModel> fetchPriceCurrencyData() async {
//     try {
//       print('Fetching price currency data...');
//       return await _apiService.getApi(
//         url: "apiUrl/rfq/getPriceCurrency",
//         fromJson: (json) {
//           print('Price currency API response received');
//           if (json is List) {
//             return PriceCurrencyModel.fromList(json as List);
//           } else {
//             print('Warning: Expected a list response but got an object');
//             return PriceCurrencyModel.empty();
//           }
//         },
//       );
//     } catch (e) {
//       print('Error fetching price currency data: $e');
//       return PriceCurrencyModel.empty();
//     }
//   }
// }

// final getPriceCurrencyRepository = Provider<GetPriceCurrencyRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return GetPriceCurrencyRepository(apiService);
// });

// final getPriceCurrencyData = FutureProvider<PriceCurrencyModel>((ref) async {
//   print('getPriceCurrencyData provider called');
//   final repository = ref.read(getPriceCurrencyRepository);
//   final result = await repository.fetchPriceCurrencyData();
//   print('Price currency data fetched: ${result.currencies.length} currencies');
//   return result;
// });
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_bills/get_price_currency.dart';

class GetPriceCurrencyRepository {
  final BaseApiService _apiService;
  GetPriceCurrencyRepository(this._apiService);

  Future<List<GetPriceCurrency>> fetchPriceCurrencies() async {
    try {
      return await _apiService.getListApi(
        url: 'api/rfq/getPriceCurrency',
        fromJson: (json) => GetPriceCurrency.fromJson(json),
      );
    } catch (e) {
      print('Error fetching price currencies: $e');
      return [];
    }
  }
}

final getPriceCurrencyRepositoryProvider =
    Provider<GetPriceCurrencyRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetPriceCurrencyRepository(apiService);
});

final priceCurrenciesProvider =
    FutureProvider<List<GetPriceCurrency>>((ref) async {
  final repository = ref.read(getPriceCurrencyRepositoryProvider);
  return repository.fetchPriceCurrencies();
});
