import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class ExpenseUpdateDeleteRepository {
  final BaseApiService _apiService;

  ExpenseUpdateDeleteRepository(this._apiService);

  /// Update an existing expense
  Future<Map<String, dynamic>> updateExpense({
    required int expenseId,
    required Map<String, dynamic> expenseData,
    File? file,
  }) async {
    try {
      // Use BaseApiService for multipart with JSON blob
      final result = await _apiService.postMultipartWithFileAndJson(
        url: "http://81.208.173.149/pb-accounting-service/api/expense/update",
        jsonData: expenseData,
        file: file,
        fromJson: (json) => json,
      );
      return result;
    } catch (e) {
      print('Error updating expense: $e');
      rethrow;
    }
  }

  /// Delete an expense
  Future<Map<String, dynamic>> deleteExpense(int expenseId) async {
    try {
      final result = await _apiService.deleteApi(
        url:
            "http://81.208.173.149/pb-accounting-service/api/expense?expenseId=$expenseId",
        fromJson: (json) => json,
      );
      return result;
    } catch (e) {
      print('Error deleting expense: $e');
      rethrow;
    }
  }
}

final expenseUpdateDeleteRepositoryProvider =
    Provider<ExpenseUpdateDeleteRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ExpenseUpdateDeleteRepository(apiService);
});
