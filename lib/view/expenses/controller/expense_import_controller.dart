import 'dart:io';

import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/model/expense_validate_file_response.dart';
import 'package:payzo_books/view/expenses/model/sample_xls_model.dart';
import 'package:payzo_books/view/expenses/repo/expense_import_export_repository.dart';

/// State for import operations
enum ImportStep { downloadSample, chooseFile, review }

class ExpenseImportState {
  final ImportStep currentStep;
  final File? selectedFile;
  final ValidateFileResponse? validationResult;
  final bool isLoading;
  final String? errorMessage;

  ExpenseImportState({
    this.currentStep = ImportStep.downloadSample,
    this.selectedFile,
    this.validationResult,
    this.isLoading = false,
    this.errorMessage,
  });

  ExpenseImportState copyWith({
    ImportStep? currentStep,
    File? selectedFile,
    ValidateFileResponse? validationResult,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExpenseImportState(
      currentStep: currentStep ?? this.currentStep,
      selectedFile: selectedFile ?? this.selectedFile,
      validationResult: validationResult ?? this.validationResult,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Controller for expense import operations
class ExpenseImportController extends StateNotifier<ExpenseImportState> {
  final ExpenseImportExportRepository repository;

  ExpenseImportController(this.repository) : super(ExpenseImportState());

  /// Download sample file
  Future<DownloadSampleResponse?> downloadSampleFile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await repository.downloadSampleFile();
      state = state.copyWith(
        isLoading: false,
        currentStep: ImportStep.chooseFile,
      );
      return response;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to download sample file: $e',
      );
      return null;
    }
  }

  /// Set selected file
  void setSelectedFile(File file) {
    state = state.copyWith(
      selectedFile: file,
      currentStep: ImportStep.chooseFile,
    );
  }

  /// Validate the selected file
  Future<bool> validateFile() async {
    if (state.selectedFile == null) {
      state = state.copyWith(
        errorMessage: 'Please select a file first',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Default config and mapping from the PDF
      final config = {
        "charEncoding": 0,
        "fileDelimiter": 0,
      };

      final mapping = {
        "branch": 0,
        "date": 1,
        "dateFormat": 0,
        "expenseAccount": 2,
        "currency": 3,
        "amount": 4,
        "paidThrough": 5,
        "vendor": 6,
        "tax": 7,
        "taxExemption": 8,
        "reference": 9,
        "customer": 10,
        "notes": 11,
        "expenseInfo": 12,
      };

      final response = await repository.validateFile(
        file: state.selectedFile!,
        config: config,
        mapping: mapping,
      );

      state = state.copyWith(
        isLoading: false,
        validationResult: response,
        currentStep: ImportStep.review,
      );

      return response.status == true && response.error == false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Validation failed: $e',
      );
      return false;
    }
  }

  /// Import the validated file
  Future<bool> importFile() async {
    if (state.selectedFile == null) {
      state = state.copyWith(
        errorMessage: 'No file selected for import',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final config = {
        "charEncoding": 0,
        "fileDelimiter": 0,
      };

      final mapping = {
        "branch": 0,
        "date": 1,
        "dateFormat": 0,
        "expenseAccount": 2,
        "currency": 3,
        "amount": 4,
        "paidThrough": 5,
        "vendor": 6,
        "tax": 7,
        "taxExemption": 8,
        "reference": 9,
        "customer": 10,
        "notes": 11,
        "expenseInfo": 12,
      };

      final response = await repository.importFile(
        file: state.selectedFile!,
        config: config,
        mapping: mapping,
      );

      state = state.copyWith(isLoading: false);
      return response.status == true && response.error == false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Import failed: $e',
      );
      return false;
    }
  }

  /// Reset import state
  void reset() {
    state = ExpenseImportState();
  }

  /// Navigate to specific step
  void goToStep(ImportStep step) {
    state = state.copyWith(currentStep: step);
  }
}

/// Provider for expense import controller
final expenseImportControllerProvider =
    StateNotifierProvider<ExpenseImportController, ExpenseImportState>((ref) {
  final repository = ref.read(expenseImportExportRepositoryProvider);
  return ExpenseImportController(repository);
});
