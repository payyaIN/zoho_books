// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:payzo_books/data/services/base_api_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ExpenseUpdateDeleteRepository {
//   final BaseApiService _apiService;

//   ExpenseUpdateDeleteRepository(this._apiService);

//   /// Update an existing expense
//   Future<Map<String, dynamic>> updateExpense({
//     required int expenseId,
//     required Map<String, dynamic> expenseData,
//     File? file,
//   }) async {
//     try {
//       final uri = Uri.parse(
//         "http://81.208.173.149/pb-accounting-service/api/expense/update",
//       );

//       final request = http.MultipartRequest('POST', uri);

//       // Add expense data as JSON blob
//       request.files.add(
//         http.MultipartFile.fromString(
//           'data',
//           jsonEncode(expenseData),
//           contentType: MediaType('application', 'json'),
//           filename: 'blob',
//         ),
//       );

//       // Add file if provided
//       if (file != null) {
//         final mimeType = file.path.toLowerCase().endsWith('.pdf')
//             ? 'application/pdf'
//             : 'image/jpeg';

//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'file',
//             file.path,
//             contentType: MediaType.parse(mimeType),
//           ),
//         );
//       }

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to update expense: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error updating expense: $e');
//       rethrow;
//     }
//   }

//   /// Delete an expense
//   Future<Map<String, dynamic>> deleteExpense(int expenseId) async {
//     try {
//       final uri = Uri.parse(
//         "http://81.208.173.149/pb-accounting-service/api/expense?expenseId=$expenseId",
//       );

//       final response = await http.delete(uri);

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to delete expense: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error deleting expense: $e');
//       rethrow;
//     }
//   }
// }

// final expenseUpdateDeleteRepositoryProvider =
//     Provider<ExpenseUpdateDeleteRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return ExpenseUpdateDeleteRepository(apiService);
// });

// // Provider to ensure apiServiceProvider is accessible
// final apiServiceProvider = Provider<BaseApiService>((ref) {
//   return BaseApiService(ref);
// });

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

final apiServiceProvider = Provider<BaseApiService>((ref) {
  return BaseApiService(ref);
});
