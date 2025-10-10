import 'package:payzo_books/data/models/product_model/product_detail_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetProductDetailsRepository {
  final BaseApiService _apiService;
  GetProductDetailsRepository(this._apiService);

  Future<ProductDetailModel> fetchProductDetailsData(int productId) async {
    try {
      print('Fetching product details for productId: $productId');

      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-item-service/v1/items/view?productId=$productId",
        fromJson: (json) {
          print(
              'Product detail API response received for productId $productId');
          return ProductDetailModel.fromMap(json);
        },
      );

      print('Product detail result for productId $productId:');

      if (result.productDetails.isNotEmpty) {
        final productDetail = result.productDetails.firstWhere(
            (detail) => detail.productId == productId,
            orElse: () => result.productDetails.first);

        print('- Product ID: ${productDetail.productId}');
        print('- Product Name: ${productDetail.productName}');
      } else {
        print('- No product details found in response');
      }

      return result;
    } catch (e) {
      print('Error fetching product details for productId $productId: $e');
      return ProductDetailModel.empty();
    }
  }
}

final getProductDetailsData = Provider<GetProductDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetProductDetailsRepository(apiService);
});

final getProductDetailsProvider =
    FutureProvider.family<ProductDetailModel, int>((ref, productId) async {
  if (productId == null || productId == 0) {
    return ProductDetailModel.empty();
  }

  print('getProductDetailsProvider called for productId: $productId');
  final repository = ref.read(getProductDetailsData);
  final result = await repository.fetchProductDetailsData(productId);
  print('Product details fetched for productId $productId');
  return result;
});
