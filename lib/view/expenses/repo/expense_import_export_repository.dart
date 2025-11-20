import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final uri = Uri.parse(
        "http://81.208.173.149/pb-accounting-service/api/bulkExpenseImport/validateFile",
      );

      final request = http.MultipartRequest('POST', uri);

      // Add config as JSON blob
      request.files.add(
        http.MultipartFile.fromString(
          'config',
          jsonEncode(config),
          contentType: MediaType('application', 'json'),
          filename: 'blob',
        ),
      );

      // Add mapping as JSON blob
      request.files.add(
        http.MultipartFile.fromString(
          'mapping',
          jsonEncode(mapping),
          contentType: MediaType('application', 'json'),
          filename: 'blob',
        ),
      );

      // Add the actual file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType(
            'application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          ),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return ValidateFileResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to validate file: ${response.statusCode}');
      }
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
      final uri = Uri.parse(
        "http://81.208.173.149/pb-accounting-service/api/bulkExpenseImport/importFile",
      );

      final request = http.MultipartRequest('POST', uri);

      // Add config as JSON blob
      request.files.add(
        http.MultipartFile.fromString(
          'config',
          jsonEncode(config),
          contentType: MediaType('application', 'json'),
          filename: 'blob',
        ),
      );

      // Add mapping as JSON blob
      request.files.add(
        http.MultipartFile.fromString(
          'mapping',
          jsonEncode(mapping),
          contentType: MediaType('application', 'json'),
          filename: 'blob',
        ),
      );

      // Add the actual file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType(
            'application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          ),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return ImportFileResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to import file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error importing file: $e');
      rethrow;
    }
  }

  /// Export expenses as XLS file
  Future<ExportExpenseResponse> exportExpenseAsXls({
    required String fileName,
    required bool isPasswordProtected,
    String? password,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final payload = {
        "fileName": fileName,
        "isPasswordProtected": isPasswordProtected,
        "password": password ?? "",
        "filter": filter ??
            {
              "sortingCriteria": {},
              "requestCriteria": {
                "reference": "",
                "paidThroughAccountId": null,
                "expenseAccount": null,
                "branch": null,
                "expenseAmountMin": 0,
                "expenseAmountMax": "",
                "expenseFromDate": "",
                "expenseToDate": ""
              }
            }
      };

      final result = await _apiService.postApi(
        url:
            "http://81.208.173.149/pb-accounting-service/api/expense/exportExpenseAsXlsFile",
        body: payload,
        fromJson: (json) => ExportExpenseResponse.fromJson(json),
      );

      return result;
    } catch (e) {
      print('Error exporting expenses: $e');
      rethrow;
    }
  }
}

final expenseImportExportRepositoryProvider =
    Provider<ExpenseImportExportRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ExpenseImportExportRepository(apiService);
});

// Provider to ensure apiServiceProvider is accessible
final apiServiceProvider = Provider<BaseApiService>((ref) {
  return BaseApiService(ref);
});
