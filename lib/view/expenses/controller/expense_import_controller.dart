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
  final Map<String, String>? fieldMappings; // NEW
  final List<Map<String, dynamic>>? previewData; // NEW

  ExpenseImportState({
    this.currentStep = ImportStep.downloadSample,
    this.selectedFile,
    this.validationResult,
    this.isLoading = false,
    this.errorMessage,
    this.fieldMappings, // NEW
    this.previewData, // NEW
  });

  ExpenseImportState copyWith({
    ImportStep? currentStep,
    File? selectedFile,
    ValidateFileResponse? validationResult,
    bool? isLoading,
    String? errorMessage,
    Map<String, String>? fieldMappings, // NEW
    List<Map<String, dynamic>>? previewData, // NEW
  }) {
    return ExpenseImportState(
      currentStep: currentStep ?? this.currentStep,
      selectedFile: selectedFile ?? this.selectedFile,
      validationResult: validationResult ?? this.validationResult,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      fieldMappings: fieldMappings ?? this.fieldMappings, // NEW
      previewData: previewData ?? this.previewData, // NEW
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

  /// Preview data before import

  /// Set selected file
  void setSelectedFile(File file) {
    state = state.copyWith(
      selectedFile: file,
      currentStep: ImportStep.chooseFile,
    );
  }

  Future<bool> previewData() async {
    if (state.selectedFile == null) {
      state = state.copyWith(
        errorMessage: 'No file selected for preview',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Generate field mappings
      final fieldMappings = <String, String>{
        'Branch': 'Column A',
        'Date': 'Column B',
        'Expense Account': 'Column C',
        'Currency': 'Column D',
        'Amount': 'Column E',
        'Paid Through': 'Column F',
        'Vendor': 'Column G',
        'Tax': 'Column H',
        'Tax Exemption': 'Column I',
        'Reference': 'Column J',
        'Customer': 'Column K',
        'Notes': 'Column L',
        'Expense Info': 'Column M',
      };

      // Create mock preview data
      // In a real implementation, this would parse the Excel file
      final mockPreviewData = <Map<String, dynamic>>[
        {
          'branch': 'Main Branch',
          'date': '2025-11-20',
          'expenseAccount': 'Office Supplies',
          'currency': 'AED',
          'amount': '100.00',
          'paidThrough': 'Cash in Hand',
          'vendor': 'Vendor A',
          'tax': 'VAT 5%',
          'reference': 'REF001',
          'customer': 'Customer A',
          'notes': 'Test expense',
          'expenseInfo': 'Info 1',
        },
        {
          'branch': 'Main Branch',
          'date': '2025-11-21',
          'expenseAccount': 'Utilities',
          'currency': 'AED',
          'amount': '200.00',
          'paidThrough': 'Petty Cash',
          'vendor': 'Vendor B',
          'tax': 'VAT 5%',
          'reference': 'REF002',
          'customer': 'Customer B',
          'notes': 'Another test expense',
          'expenseInfo': 'Info 2',
        },
        {
          'branch': 'Branch 2',
          'date': '2025-11-22',
          'expenseAccount': 'Rent Expense',
          'currency': 'AED',
          'amount': '500.00',
          'paidThrough': 'Bank Account',
          'vendor': 'Vendor C',
          'tax': 'VAT 5%',
          'reference': 'REF003',
          'customer': 'Customer C',
          'notes': 'Monthly rent',
          'expenseInfo': 'Info 3',
        },
      ];

      state = state.copyWith(
        isLoading: false,
        fieldMappings: fieldMappings,
        previewData: mockPreviewData,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Preview failed: $e',
      );
      return false;
    }
  }

// UPDATE the validateFile method to set fieldMappings:
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

      // Generate field mappings for display
      final fieldMappings = <String, String>{
        'Branch': 'Column A (Index 0)',
        'Date': 'Column B (Index 1)',
        'Expense Account': 'Column C (Index 2)',
        'Currency': 'Column D (Index 3)',
        'Amount': 'Column E (Index 4)',
        'Paid Through': 'Column F (Index 5)',
        'Vendor': 'Column G (Index 6)',
        'Tax': 'Column H (Index 7)',
        'Tax Exemption': 'Column I (Index 8)',
        'Reference': 'Column J (Index 9)',
        'Customer': 'Column K (Index 10)',
        'Notes': 'Column L (Index 11)',
        'Expense Info': 'Column M (Index 12)',
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
        fieldMappings: fieldMappings, // Set field mappings
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
