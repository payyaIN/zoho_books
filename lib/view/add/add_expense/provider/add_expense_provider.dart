import 'dart:io';

import 'package:payzo_books/data/models/add_bills/get_price_currency.dart';

import '../../../../import_data.dart';
final addExpenseProvider =
StateNotifierProvider<AddExpenseController, bool>((ref) {
  return AddExpenseController(ref);
});

/// Text Controllers
final amountControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final referenceControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final notesControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final expensesExemptionReasonControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final showExemptionReasonProvider = StateProvider.autoDispose<bool>((ref) => false);
final expenseAttachmentProvider = StateProvider<List<File>>((ref) => []);

/// Dropdown Selections
final dateProvider = StateProvider<DateTime?>((ref) => null);

/// Selected branch (UI name and API ID)
final branchProvider = StateProvider<String?>((ref) => null);
final branchIdProvider = StateProvider<int?>((ref) => null);

/// Selected expense account
final expenseAccountProvider = StateProvider<String?>((ref) => null);
final expenseAccountIdProvider = StateProvider<int?>((ref) => null);

/// Selected paid through
final paidThroughProvider = StateProvider<String?>((ref) => null);
final paidThroughIdProvider = StateProvider<int?>((ref) => null);

/// Selected vendor
final vendorProvider = StateProvider<String?>((ref) => null);
final vendorIdProvider = StateProvider<int?>((ref) => null);

/// Selected customer
final customerProvider = StateProvider<String?>((ref) => null);
final customerIdProvider = StateProvider<int?>((ref) => null);

/// Selected tax
final taxProvider = StateProvider<String?>((ref) => null);
final taxIdProvider = StateProvider<int?>((ref) => null);
final taxTypeProvider = StateProvider<String?>((ref) => null);
final taxJsonProvider = StateProvider<Map<String, dynamic>>((ref) => {});

/// Selected currency
final expenseCurrencyProvider = StateProvider<String?>((ref) => null);
final expenseCurrencyIdProvider = StateProvider<int?>((ref) => null);

/// Validation error messages for form fields
final branchErrorProvider = StateProvider<String?>((ref) => null);
final dateErrorProvider = StateProvider<String?>((ref) => null);
final amountErrorProvider = StateProvider<String?>((ref) => null);
final expenseAccountErrorProvider = StateProvider<String?>((ref) => null);
final paidThroughErrorProvider = StateProvider<String?>((ref) => null);
