import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_bills/shipping_method_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
class ShippingMethodRepository {
  final BaseApiService apiService;
  ShippingMethodRepository(this.apiService);

  Future<List<ShippingMethodModel>> fetchShippingMethods() {
    return apiService.getListApi(
      url: 'http://158.101.247.195/pb-process-service/rfq/getShippingMethod',
      fromJson: (json) => ShippingMethodModel.fromJson(json),
    );
  }
}

final shippingMethodRepoProvider = Provider<ShippingMethodRepository>((ref) {
  return ShippingMethodRepository(ref.read(apiServiceProvider));
});

final fetchShippingMethodsProvider = FutureProvider<List<ShippingMethodModel>>((ref) {
  return ref.read(shippingMethodRepoProvider).fetchShippingMethods();
});



