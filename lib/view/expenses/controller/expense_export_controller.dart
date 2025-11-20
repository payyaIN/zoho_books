import 'package:flutter_riverpod/flutter_riverpod.dart';
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
