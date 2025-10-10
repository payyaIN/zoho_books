import 'package:payzo_books/data/models/vendor_model/vendor_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

import 'dart:developer' as developer;

class GetAllVendorRepository {
  final BaseApiService _apiService;
  GetAllVendorRepository(this._apiService);

//   Future<VendorModel> fetchVendorData({
//     int pageNo = 0,
//     int rowsPerPage = 15,
//     String? searchQuery,
//   }) async {
//     try {
//       final bool isSearching = searchQuery != null && searchQuery.isNotEmpty;

//       final int effectivePageNo = isSearching ? 0 : pageNo;
//       final int effectiveRowsPerPage = isSearching ? 1000 : rowsPerPage;

//       developer.log(
//           'Fetching vendor list data (page: $effectivePageNo, rows: $effectiveRowsPerPage, search: $searchQuery)...',
//           name: 'VendorAPI');

//       final Map<String, dynamic> requestBody;

//       if (isSearching) {
//         requestBody = {
//           "requestCriteria": {
//             "firstName": searchQuery,
//             "companyName": searchQuery
//           },
//           "sortingCriteria": {}
//         };
//         developer.log('Searching vendors by name/company: "$searchQuery"',
//             name: 'VendorAPI');
//       } else {
//         requestBody = {
//           "requestCriteria": {"firstName": "", "companyName": ""},
//           "sortingCriteria": {}
//         };
//       }

//       developer.log('VENDOR API REQUEST BODY: ${requestBody.toString()}',
//           name: 'VendorAPI');

//       final url =
//           "http://81.208.173.149/pb-process-service/api/process/vendors?pageNo=$pageNo&RowPerPage=$rowsPerPage";
//       developer.log('VENDOR API URL: $url', name: 'VendorAPI');

//       return await _apiService.postApi(
//         url: url,
//         body: requestBody,
//         fromJson: (json) {
//           developer.log('Vendor list API response received', name: 'VendorAPI');
//           final model = VendorModel.fromMap(json);
//           developer.log(
//               'Parsed VendorModel - totalRecord: ${model.response.totalRecord}, vendors: ${model.response.response.length}',
//               name: 'VendorAPI');
//           return model;
//         },
//       );
//     } catch (e) {
//       developer.log('Error fetching vendor data: $e',
//           name: 'VendorAPI', error: e);
//       return VendorModel(
//         error: true,
//         errorMsg: e.toString(),
//         response: ResponseData(response: [], totalRecord: 0),
//         status: false,
//         transactionId: "",
//       );
//     }
//   }
  Future<VendorModel> fetchVendorData({
    int pageNo = 0,
    int rowsPerPage = 15,
    String? searchQuery,
  }) async {
    try {
      final bool isSearching = searchQuery != null && searchQuery.isNotEmpty;
      final int effectiveRowsPerPage = isSearching ? 1000 : rowsPerPage;

      developer.log(
          'Fetching vendor list data (page: $pageNo, rows: $effectiveRowsPerPage, search: $searchQuery)...',
          name: 'VendorAPI');

      final Map<String, dynamic> requestBody;

      if (isSearching) {
        requestBody = {
          "requestCriteria": {"firstName": searchQuery, "companyName": ""},
          "sortingCriteria": {}
        };
        developer.log('Searching vendors by firstName: "$searchQuery"',
            name: 'VendorAPI');
      } else {
        requestBody = {
          "requestCriteria": {"firstName": "", "companyName": ""},
          "sortingCriteria": {}
        };
      }

      developer.log('VENDOR API REQUEST BODY: ${requestBody.toString()}',
          name: 'VendorAPI');

      return await _apiService.postApi(
        url:
            "http://81.208.173.149/pb-process-service/api/process/vendors?pageNo=$pageNo&RowPerPage=$rowsPerPage",
        body: requestBody,
        fromJson: (json) {
          developer.log('Vendor list API response received', name: 'VendorAPI');
          final model = VendorModel.fromMap(json);
          developer.log(
              'Parsed VendorModel - totalRecord: ${model.response.totalRecord}, vendors: ${model.response.response.length}',
              name: 'VendorAPI');
          return model;
        },
      );
    } catch (e) {
      developer.log('Error fetching vendor data: $e',
          name: 'VendorAPI', error: e);
      return VendorModel(
        error: true,
        errorMsg: e.toString(),
        response: ResponseData(response: [], totalRecord: 0),
        status: false,
        transactionId: "",
      );
    }
  }
}

final getAllVendorsData = Provider<GetAllVendorRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllVendorRepository(apiService);
});

class VendorPaginationParams {
  final int pageNo;
  final int rowsPerPage;
  final String? searchQuery;

  VendorPaginationParams({
    this.pageNo = 0,
    this.rowsPerPage = 15,
    this.searchQuery,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is VendorPaginationParams &&
        other.pageNo == pageNo &&
        other.rowsPerPage == rowsPerPage &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode =>
      pageNo.hashCode ^ rowsPerPage.hashCode ^ (searchQuery?.hashCode ?? 0);
}

final getVendorDataWithPagination =
    FutureProvider.family<VendorModel, VendorPaginationParams>(
        (ref, params) async {
  developer.log(
      'getVendorData provider called with page ${params.pageNo}, rows ${params.rowsPerPage}, search: ${params.searchQuery}',
      name: 'VendorProvider');
  final repository = ref.read(getAllVendorsData);
  final result = await repository.fetchVendorData(
    pageNo: params.pageNo,
    rowsPerPage: params.rowsPerPage,
    searchQuery: params.searchQuery,
  );
  developer.log(
      'Vendor data fetched: ${result.response.response.length} vendors found of ${result.response.totalRecord} total',
      name: 'VendorProvider');
  return result;
});

final getVendorData = FutureProvider<VendorModel>((ref) async {
  developer.log('getVendorData provider called with default pagination',
      name: 'VendorProvider');
  final params = VendorPaginationParams();
  return ref.watch(getVendorDataWithPagination(params).future);
});
