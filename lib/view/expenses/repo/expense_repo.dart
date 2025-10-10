import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'dart:developer' as developer;

import 'package:payzo_books/view/expenses/model/get_expense_list_model.dart';

class GetAllExpensesRepository {
  final BaseApiService _apiService;

  GetAllExpensesRepository(this._apiService);

  Future<GetExpenseListModel> fetchExpenseData({
    required int pageNo,
    required int rowsPerPage,
    String? searchQuery,
  }) async {
    try {
      final uri =
          "http://81.208.173.149/pb-accounting-service/api/expense/getExpenceList?pageNo=$pageNo&rowPerPage=$rowsPerPage";

      final requestBody = {
        "requestCriteria": {
          "reference": searchQuery ?? "",
        },
        "sortingCriteria": {}
      };

      developer.log("EXPENSE API REQUEST BODY: $requestBody",
          name: "ExpensesAPI");

      final result = await _apiService.postApi(
        url: uri,
        body: requestBody,
        fromJson: (json) {
          developer.log("EXPENSE API RESPONSE RECEIVED", name: "ExpensesAPI");
          return GetExpenseListModel.fromJson(json);
        },
      );

      developer.log(
        "EXPENSES RECEIVED: count=${result.response?.data?.length ?? 0}, total=${result.response?.totalRecord ?? 0}",
        name: "ExpensesAPI",
      );

      return result;
    } catch (e) {
      developer.log("ERROR fetching expense data: $e",
          name: "ExpensesAPI", error: e);
      return GetExpenseListModel(
        error: true,
        message: "Error fetching expenses",
        response: null,
        status: false,
      );
    }
  }
}

final getAllExpensesData = Provider<GetAllExpensesRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllExpensesRepository(apiService);
});

class ExpensePaginationParams {
  final int pageNo;
  final int rowsPerPage;
  final String? searchQuery;

  ExpensePaginationParams({
    required this.pageNo,
    required this.rowsPerPage,
    this.searchQuery,
  });

  @override
  bool operator ==(Object other) {
    return other is ExpensePaginationParams &&
        other.pageNo == pageNo &&
        other.rowsPerPage == rowsPerPage &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode =>
      pageNo.hashCode ^ rowsPerPage.hashCode ^ (searchQuery?.hashCode ?? 0);
}

final getExpenseDataWithPagination =
    FutureProvider.family<GetExpenseListModel, Map<String, dynamic>>(
        (ref, params) async {
  final repository = ref.read(getAllExpensesData);
  return repository.fetchExpenseData(
    pageNo: params["pageNo"],
    rowsPerPage: params["rowPerPage"],
    searchQuery: params["requestCriteria"]?["reference"],
  );
});
