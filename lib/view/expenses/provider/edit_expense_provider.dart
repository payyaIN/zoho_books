import 'package:payzo_books/import_data.dart';

/// Provider to track if we're in edit mode for expense
final editExpenseModeProvider = StateProvider<bool>((ref) => false);

/// Provider to hold the expense ID being edited
final editExpenseIdProvider = StateProvider<int?>((ref) => null);
