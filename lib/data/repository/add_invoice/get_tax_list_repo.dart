import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_invoice/get_tax_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
class TaxRepository {
  final BaseApiService apiService;
  TaxRepository(this.apiService);

  Future<TaxResponse> fetchAllTaxes() {
    return apiService.getApi(
      url: 'http://158.101.247.195/pb-process-service/taxes/getAllTaxList',
      fromJson: (json) {
        print("🌐 Raw Tax API Response: $json");
        return TaxResponse.fromJson(json); // ✅ Pass the full JSON
      },
    );
  }
}



final taxRepositoryProvider = Provider<TaxRepository>((ref) {
  return TaxRepository(ref.read(apiServiceProvider));
});

final fetchAllTaxesProvider = FutureProvider<TaxResponse>((ref) {
  return ref.read(taxRepositoryProvider).fetchAllTaxes();
});
