import 'package:payzo_books/data/models/product_model/product_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';
import 'dart:developer' as developer;

// class GetAllProductRepository {
//   final BaseApiService _apiService;
//   GetAllProductRepository(this._apiService);

//   Future<ProductModel> fetchProductData({
//     int pageNo = 0,
//     int rowsPerPage = 15,
//     String? searchQuery,
//   }) async {
//     try {
//       print(
//           'Fetching product list data (page: $pageNo, rows: $rowsPerPage, search: $searchQuery)...');

//       final Map<String, dynamic> requestBody;

//       if (searchQuery != null && searchQuery.isNotEmpty) {
//         requestBody = {
//           "requestCriteria": {
//             "itemName": searchQuery,
//             "costDescription": "",
//             "costRate": ""
//           },
//           "sortingCriteria": {}
//         };
//         print('Searching products by name: "$searchQuery"');
//       } else {
//         requestBody = {
//           "requestCriteria": {
//             "itemName": "",
//             "costDescription": "",
//             "costRate": ""
//           },
//           "sortingCriteria": {}
//         };
//       }

//       return await _apiService.postApi(
//         url:
//             "http://81.208.173.149/pb-item-service/v1/items/search/items?pageNo=$pageNo&RowPerPage=$rowsPerPage",
//         body: requestBody,
//         fromJson: (json) {
//           print('Product list API response received');
//           return ProductModel.fromMap(json);
//         },
//       );
//     } catch (e) {
//       print('Error fetching product data: $e');
//       return ProductModel(
//         error: true,
//         errorMsg: e.toString(),
//         successMsg: "",
//         response: ProductResponse(
//           data: [],
//           totalRecord: 0,
//         ),
//         status: false,
//         transactionId: "f32dc8fd-41b0-4fb2-805a-fcc91ce789bf",
//       );
//     }
//   }

//   Future<ProductData> fetchProductById(int productId) async {
//     try {
//       print('Fetching product by ID: $productId');

//       int page = 0;
//       int totalRecords = 0;

//       do {
//         final productModel =
//             await fetchProductData(pageNo: page, rowsPerPage: 15);
//         totalRecords = productModel.response.totalRecord;

//         final product = productModel.response.data.firstWhere(
//           (p) => p.itemId == productId,
//           orElse: () => ProductData.empty(),
//         );

//         if (product.itemId != 0) {
//           return product;
//         }

//         page++;
//       } while (page * 15 < totalRecords);

//       return ProductData.empty();
//     } catch (e) {
//       print('Error fetching product by ID: $e');
//       return ProductData.empty();
//     }
//   }
// }

// final getAllProductsData = Provider<GetAllProductRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return GetAllProductRepository(apiService);
// });

// class ProductPaginationParams {
//   final int pageNo;
//   final int rowsPerPage;
//   final String? searchQuery;

//   ProductPaginationParams({
//     this.pageNo = 0,
//     this.rowsPerPage = 15,
//     this.searchQuery,
//   });

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (other.runtimeType != runtimeType) return false;
//     return other is ProductPaginationParams &&
//         other.pageNo == pageNo &&
//         other.rowsPerPage == rowsPerPage &&
//         other.searchQuery == searchQuery;
//   }

//   @override
//   int get hashCode =>
//       pageNo.hashCode ^ rowsPerPage.hashCode ^ (searchQuery?.hashCode ?? 0);
// }

// final getProductDataWithPagination =
//     FutureProvider.family<ProductModel, ProductPaginationParams>(
//         (ref, params) async {
//   print(
//       'getProductData provider called with page ${params.pageNo}, rows ${params.rowsPerPage}, search: ${params.searchQuery}');
//   final repository = ref.read(getAllProductsData);
//   final result = await repository.fetchProductData(
//     pageNo: params.pageNo,
//     rowsPerPage: params.rowsPerPage,
//     searchQuery: params.searchQuery,
//   );
//   print(
//       'Product data fetched: ${result.response.data.length} products found of ${result.response.totalRecord} total');
//   return result;
// });

// final getProductData = FutureProvider<ProductModel>((ref) async {
//   print('getProductData provider called with default pagination');
//   final params = ProductPaginationParams();
//   return ref.watch(getProductDataWithPagination(params).future);
// });

// final getProductByIdProvider =
//     FutureProvider.family<ProductData, int>((ref, productId) async {
//   if (productId == null || productId == 0) return ProductData.empty();

//   print('getProductByIdProvider called for ID: $productId');
//   final repository = ref.read(getAllProductsData);
//   return await repository.fetchProductById(productId);
// });

class GetAllProductRepository {
  final BaseApiService _apiService;
  GetAllProductRepository(this._apiService);

  Future<ProductModel> fetchProductData({
    int pageNo = 0,
    int rowsPerPage = 15,
    String? searchQuery,
  }) async {
    try {
      developer.log(
          'Fetching product list data (page: $pageNo, rows: $rowsPerPage, search: $searchQuery)...',
          name: 'ProductAPI');

      final Map<String, dynamic> requestBody;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        requestBody = {
          "requestCriteria": {
            "itemName": searchQuery,
            "costDescription": "",
            "costRate": ""
          },
          "sortingCriteria": {}
        };
        developer.log('Searching products by name: "$searchQuery"',
            name: 'ProductAPI');
      } else {
        requestBody = {
          "requestCriteria": {
            "itemName": "",
            "costDescription": "",
            "costRate": ""
          },
          "sortingCriteria": {}
        };
      }

      developer.log('PRODUCT API REQUEST BODY: ${requestBody.toString()}',
          name: 'ProductAPI');

      return await _apiService.postApi(
        url:
            "http://81.208.173.149/pb-item-service/v1/items/search/items?pageNo=$pageNo&RowPerPage=$rowsPerPage",
        body: requestBody,
        fromJson: (json) {
          developer.log('Product list API response received',
              name: 'ProductAPI');
          return ProductModel.fromMap(json);
        },
      );
    } catch (e) {
      developer.log('Error fetching product data: $e',
          name: 'ProductAPI', error: e);
      return ProductModel(
        error: true,
        errorMsg: e.toString(),
        successMsg: "",
        response: ProductResponse(
          data: [],
          totalRecord: 0,
        ),
        status: false,
        transactionId: "f32dc8fd-41b0-4fb2-805a-fcc91ce789bf",
      );
    }
  }

  Future<ProductData> fetchProductById(int productId) async {
    try {
      developer.log('Fetching product by ID: $productId', name: 'ProductAPI');

      int page = 0;
      int totalRecords = 0;

      do {
        final productModel =
            await fetchProductData(pageNo: page, rowsPerPage: 15);
        totalRecords = productModel.response.totalRecord;

        final product = productModel.response.data.firstWhere(
          (p) => p.itemId == productId,
          orElse: () => ProductData.empty(),
        );

        if (product.itemId != 0) {
          developer.log('Found product with ID: $productId',
              name: 'ProductAPI');
          return product;
        }

        page++;
      } while (page * 15 < totalRecords);

      developer.log(
          'Product with ID: $productId not found after searching all pages',
          name: 'ProductAPI');
      return ProductData.empty();
    } catch (e) {
      developer.log('Error fetching product by ID: $e',
          name: 'ProductAPI', error: e);
      return ProductData.empty();
    }
  }
}

final getAllProductsData = Provider<GetAllProductRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllProductRepository(apiService);
});

class ProductPaginationParams {
  final int pageNo;
  final int rowsPerPage;
  final String? searchQuery;

  ProductPaginationParams({
    this.pageNo = 0,
    this.rowsPerPage = 15,
    this.searchQuery,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ProductPaginationParams &&
        other.pageNo == pageNo &&
        other.rowsPerPage == rowsPerPage &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode =>
      pageNo.hashCode ^ rowsPerPage.hashCode ^ (searchQuery?.hashCode ?? 0);
}

final getProductDataWithPagination =
    FutureProvider.family<ProductModel, ProductPaginationParams>(
        (ref, params) async {
  developer.log(
      'getProductData provider called with page ${params.pageNo}, rows ${params.rowsPerPage}, search: ${params.searchQuery}',
      name: 'ProductProvider');

  final repository = ref.read(getAllProductsData);
  final result = await repository.fetchProductData(
    pageNo: params.pageNo,
    rowsPerPage: params.rowsPerPage,
    searchQuery: params.searchQuery,
  );

  developer.log(
      'Product data fetched: ${result.response.data.length} products found of ${result.response.totalRecord} total',
      name: 'ProductProvider');
  return result;
});

final getProductData = FutureProvider<ProductModel>((ref) async {
  developer.log('getProductData provider called with default pagination',
      name: 'ProductProvider');
  final params = ProductPaginationParams();
  return ref.watch(getProductDataWithPagination(params).future);
});

final getProductByIdProvider =
    FutureProvider.family<ProductData, int>((ref, productId) async {
  if (productId == null || productId == 0) return ProductData.empty();

  developer.log('getProductByIdProvider called for ID: $productId',
      name: 'ProductProvider');
  final repository = ref.read(getAllProductsData);
  return await repository.fetchProductById(productId);
});
