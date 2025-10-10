import 'package:payzo_books/data/models/customer_model/customer_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';
import 'dart:developer' as developer;

class GetAllCustomerRepository {
  final BaseApiService _apiService;
  GetAllCustomerRepository(this._apiService);

  Future<CustomerModel> fetchCustomerData({
    int pageNo = 0,
    int rowsPerPage = 15,
    String? searchQuery,
  }) async {
    try {
      final bool isSearching = searchQuery != null && searchQuery.isNotEmpty;
      final int effectiveRowsPerPage = isSearching ? 1000 : rowsPerPage;

      developer.log(
          'Repository: fetchCustomerData called with pageNo=$pageNo, rows=$effectiveRowsPerPage, searchQuery=$searchQuery',
          name: 'CustomerAPI');

      final Map<String, dynamic> requestBody;

      if (isSearching) {
        requestBody = {
          "requestCriteria": {"firstName": searchQuery, "companyName": ""},
          "sortingCriteria": {}
        };
        developer.log('Searching customers by firstName: "$searchQuery"',
            name: 'CustomerAPI');
      } else {
        requestBody = {
          "requestCriteria": {"firstName": "", "companyName": ""},
          "sortingCriteria": {}
        };
      }

      developer.log('CUSTOMER API REQUEST BODY: ${requestBody.toString()}',
          name: 'CustomerAPI');

      return await _apiService.postApi(
        url:
            "http://81.208.173.149/pb-process-service/api/process/customers?pageNo=$pageNo&RowPerPage=$rowsPerPage",
        body: requestBody,
        fromJson: (json) {
          developer.log('Customer list API response received',
              name: 'CustomerAPI');
          final model = CustomerModel.fromMap(json);
          developer.log(
              'Parsed CustomerModel - totalRecord: ${model.response.totalRecord}, customers: ${model.response.response.length}',
              name: 'CustomerAPI');
          return model;
        },
      );
    } catch (e) {
      developer.log('Error fetching customer data: $e',
          name: 'CustomerAPI', error: e);
      return CustomerModel(
        error: true,
        errorMsg: e.toString(),
        response: ResponseData(response: [], totalRecord: 0),
        status: false,
        transactionId: "",
      );
    }
  }
}

final getAllCustomersData = Provider<GetAllCustomerRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllCustomerRepository(apiService);
});

class CustomerPaginationParams {
  final int pageNo;
  final int rowsPerPage;
  final String? searchQuery;

  CustomerPaginationParams({
    this.pageNo = 0,
    this.rowsPerPage = 15,
    this.searchQuery,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CustomerPaginationParams &&
        other.pageNo == pageNo &&
        other.rowsPerPage == rowsPerPage &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode =>
      pageNo.hashCode ^ rowsPerPage.hashCode ^ (searchQuery?.hashCode ?? 0);
}

final getCustomerDataWithPagination =
    FutureProvider.family<CustomerModel, CustomerPaginationParams>(
        (ref, params) async {
  developer.log(
      'getCustomerData provider called with page ${params.pageNo}, rows ${params.rowsPerPage}, search: ${params.searchQuery}',
      name: 'CustomerProvider');
  final repository = ref.read(getAllCustomersData);
  final result = await repository.fetchCustomerData(
    pageNo: params.pageNo,
    rowsPerPage: params.rowsPerPage,
    searchQuery: params.searchQuery,
  );
  developer.log(
      'Customer data fetched: ${result.response.response.length} customers found of ${result.response.totalRecord} total',
      name: 'CustomerProvider');
  return result;
});

final getCustomerData = FutureProvider<CustomerModel>((ref) async {
  developer.log('getCustomerData provider called with default pagination',
      name: 'CustomerProvider');
  final params = CustomerPaginationParams();
  return ref.watch(getCustomerDataWithPagination(params).future);
});
