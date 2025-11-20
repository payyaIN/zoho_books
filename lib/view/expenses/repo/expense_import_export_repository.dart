import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/view/expenses/model/expense_export_expense_response.dart';
import 'package:payzo_books/view/expenses/model/expense_import_file_response.dart';
import 'package:payzo_books/view/expenses/model/expense_validate_file_response.dart';
import 'package:payzo_books/view/expenses/model/sample_xls_model.dart';

class ExpenseImportExportRepository {
  final BaseApiService _apiService;

  ExpenseImportExportRepository(this._apiService);

  /// Download sample expense XLS file
  Future<DownloadSampleResponse> downloadSampleFile() async {
    try {
      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-accounting-service/api/bulkExpenseImport/downloadExpenseSampleXls",
        fromJson: (json) => DownloadSampleResponse.fromJson(json),
      );
      return result;
    } catch (e) {
      print('Error downloading sample file: $e');
      rethrow;
    }
  }

  /// Validate uploaded expense file
  Future<ValidateFileResponse> validateFile({
    required File file,
    required Map<String, dynamic> config,
    required Map<String, dynamic> mapping,
  }) async {
    try {
      final result = await _apiService.postMultipartWithBlobJson(
        url:
            "http://81.208.173.149/pb-accounting-service/api/bulkExpenseImport/validateFile",
        file: file,
        config: config,
        mapping: mapping,
        fromJson: (json) => ValidateFileResponse.fromJson(json),
      );
      return result;
    } catch (e) {
      print('Error validating file: $e');
      rethrow;
    }
  }

  /// Import validated expense file
  Future<ImportFileResponse> importFile({
    required File file,
    required Map<String, dynamic> config,
    required Map<String, dynamic> mapping,
  }) async {
    try {
      final result = await _apiService.postMultipartWithBlobJson(
        url:
            "http://81.208.173.149/pb-accounting-service/api/bulkExpenseImport/importFile",
        file: file,
        config: config,
        mapping: mapping,
        fromJson: (json) => ImportFileResponse.fromJson(json),
      );
      return result;
    } catch (e) {
      print('Error importing file: $e');
      rethrow;
    }
  }

  /// Export expenses to Excel
  Future<ExportExpenseResponse> exportExpenses({
    int pageNo = 0,
    int rowPerPage = 15,
  }) async {
    try {
      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-accounting-service/api/bulkExpenseImport/export?pageNo=$pageNo&rowPerPage=$rowPerPage",
        fromJson: (json) => ExportExpenseResponse.fromJson(json),
      );
      return result;
    } catch (e) {
      print('Error exporting expenses: $e');
      rethrow;
    }
  }

  Future<ExportExpenseResponse> exportExpenseAsXls({
    required String fileName,
    required bool isPasswordProtected,
    String? password,
    Map<String, dynamic>? filter,
  }) async {
    try {
      // Build query parameters
      String url =
          "http://81.208.173.149/pb-accounting-service/api/bulkExpenseImport/export";

      Map<String, dynamic> queryParams = {
        'fileName': fileName,
        'isPasswordProtected': isPasswordProtected.toString(),
      };

      if (password != null && password.isNotEmpty) {
        queryParams['password'] = password;
      }

      // Add query parameters to URL
      final uri = Uri.parse(url).replace(queryParameters: queryParams);

      final result = await _apiService.getApi(
        url: uri.toString(),
        fromJson: (json) => ExportExpenseResponse.fromJson(json),
      );
      return result;
    } catch (e) {
      print('Error exporting expenses as XLS: $e');
      rethrow;
    }
  }
}

final expenseImportExportRepositoryProvider =
    Provider<ExpenseImportExportRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ExpenseImportExportRepository(apiService);
});
