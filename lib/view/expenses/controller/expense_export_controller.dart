import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/model/expense_export_expense_response.dart';
import 'package:payzo_books/view/expenses/repo/expense_import_export_repository.dart';

/// State for export operations
class ExpenseExportState {
  final bool isLoading;
  final String? errorMessage;
  final ExportExpenseResponse? exportResponse;

  ExpenseExportState({
    this.isLoading = false,
    this.errorMessage,
    this.exportResponse,
  });

  ExpenseExportState copyWith({
    bool? isLoading,
    String? errorMessage,
    ExportExpenseResponse? exportResponse,
  }) {
    return ExpenseExportState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      exportResponse: exportResponse ?? this.exportResponse,
    );
  }
}

/// Controller for expense export operations
class ExpenseExportController extends StateNotifier<ExpenseExportState> {
  final ExpenseImportExportRepository repository;

  ExpenseExportController(this.repository) : super(ExpenseExportState());

  /// Export expenses without password
  Future<ExportExpenseResponse?> exportWithoutPassword({
    String fileName = "Expense",
    Map<String, dynamic>? filter,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await repository.exportExpenseAsXls(
        fileName: fileName,
        isPasswordProtected: false,
        filter: filter,
      );

      if (response.response?.excelData != null) {
        await _saveFile(
          base64Data: response.response!.excelData!,
          fileName: response.response!.excelFileName ?? '$fileName.xlsx',
        );
      }

      state = state.copyWith(
        isLoading: false,
        exportResponse: response,
      );
      return response;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Export failed: $e',
      );
      return null;
    }
  }

  /// Export expenses with password protection
  Future<ExportExpenseResponse?> exportWithPassword({
    required String password,
    String fileName = "Expense",
    Map<String, dynamic>? filter,
  }) async {
    if (password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Password cannot be empty',
      );
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await repository.exportExpenseAsXls(
        fileName: fileName,
        isPasswordProtected: true,
        password: password,
        filter: filter,
      );

      if (response.response?.excelData != null) {
        await _saveFile(
          base64Data: response.response!.excelData!,
          fileName: response.response!.excelFileName ?? '$fileName.xlsx',
        );
      }

      state = state.copyWith(
        isLoading: false,
        exportResponse: response,
      );
      return response;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Export failed: $e',
      );
      return null;
    }
  }

  Future<void> _saveFile({
    required String base64Data,
    required String fileName,
  }) async {
    try {
      // Request storage permission
      // For Android 13+ (SDK 33+), MANAGE_EXTERNAL_STORAGE or specific media permissions might be needed,
      // but for Downloads, standard storage permission or just writing to app-specific storage might suffice depending on scope.
      // We'll try standard storage permission first.
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      // Get downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Fallback if direct path doesn't work or isn't accessible
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory != null) {
        final String filePath = '${directory.path}/$fileName';
        final File file = File(filePath);
        final List<int> bytes = base64Decode(base64Data);
        await file.writeAsBytes(bytes);
        print('File saved to: $filePath');
        
        // Optional: Open the file
        // OpenFile.open(filePath);
      } else {
        throw Exception('Could not access downloads directory');
      }
    } catch (e) {
      print('Error saving file: $e');
      throw Exception('Error saving file: $e');
    }
  }

  /// Reset export state
  void reset() {
    state = ExpenseExportState();
  }
}

/// Provider for expense export controller
final expenseExportControllerProvider =
    StateNotifierProvider<ExpenseExportController, ExpenseExportState>((ref) {
  final repository = ref.read(expenseImportExportRepositoryProvider);
  return ExpenseExportController(repository);
});
