// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payzo_books/data/models/product_model/product_list_model.dart';
// import 'package:payzo_books/data/services/base_api_service.dart';

// class GetAllProductRepository {
//   final BaseApiService _apiService;
//   GetAllProductRepository(this._apiService);

//   Future<ProductModel> fetchProductData(
//       {int pageNo = 0, int rowsPerPage = 15}) async {
//     try {
//       print('Fetching vendor list data (page: $pageNo, rows: $rowsPerPage)...');

//       return await _apiService.postApi(
//         url:
//             "http://158.101.247.195/pb-item-service/v1/items/search/items?pageNo=$pageNo&RowPerPage=$rowsPerPage",
//         body: {
//           "requestCriteria": {
//             "itemName": "",
//             "costDescription": "",
//             "costRate": ""
//           },
//           "sortingCriteria": {}
//         },
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
// }

// final getAllProductsData = Provider<GetAllProductRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return GetAllProductRepository(apiService);
// });

// final getProductDataWithPagination =
//     FutureProvider.family<ProductModel, ProductPaginationParams>(
//         (ref, params) async {
//   print(
//       'getProductData provider called with page ${params.pageNo}, rows ${params.rowsPerPage}');
//   final repository = ref.read(getAllProductsData);
//   final result = await repository.fetchProductData(
//       pageNo: params.pageNo, rowsPerPage: params.rowsPerPage);
//   print(
//       'Vendor data fetched: ${result.response.data.length} vendors found of ${result.response.totalRecord} total');
//   return result;
// });

// final getVendorData = FutureProvider<ProductModel>((ref) async {
//   print('getVendorData provider called with default pagination');
//   final params = ProductPaginationParams();
//   return ref.watch(getProductDataWithPagination(params).future);
// });

// class ProductPaginationParams {
//   final int pageNo;
//   final int rowsPerPage;

//   ProductPaginationParams({this.pageNo = 0, this.rowsPerPage = 15});

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (other.runtimeType != runtimeType) return false;
//     return other is ProductPaginationParams &&
//         other.pageNo == pageNo &&
//         other.rowsPerPage == rowsPerPage;
//   }

//   @override
//   int get hashCode => pageNo.hashCode ^ rowsPerPage.hashCode;
// }
