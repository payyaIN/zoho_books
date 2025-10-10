import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_product/get_product_account_list.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class ProductAccountListRepository {
  final BaseApiService apiService;
  ProductAccountListRepository(this.apiService);

  Future<ProductAccountResponse> fetchProductAccounts() {
    return apiService.getApi(
      url: 'http://81.208.173.149/pb-accounting-service/api/chartOfAccounts/productAccounts',
      fromJson: (json) => ProductAccountResponse.fromJson(json),
    );
  }
}

final productAccountRepoProvider = Provider<ProductAccountListRepository>((ref) {
  return ProductAccountListRepository(ref.read(apiServiceProvider));
});

final getProductAccountsProvider = FutureProvider<ProductAccountResponse>((ref) {
  return ref.read(productAccountRepoProvider).fetchProductAccounts();
});
