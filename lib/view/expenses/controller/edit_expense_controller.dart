import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/reusable_snackbar.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';
import 'package:payzo_books/view/expenses/repo/expense_update_delete_repository.dart';

class EditExpenseController extends StateNotifier<bool> {
  final Ref ref;

  EditExpenseController(this.ref) : super(false);

  Future<void> updateExpense(
    BuildContext context,
    WidgetRef ref,
    int expenseId,
  ) async {
    state = true;

    try {
      // Get all form values
      final amount = ref.read(amountControllerProvider).text.trim();
      final reference = ref.read(referenceControllerProvider).text.trim();
      final notes = ref.read(notesControllerProvider).text.trim();
      final exemptionReason =
          ref.read(expensesExemptionReasonControllerProvider).text.trim();

      // Required fields
      final branchId = ref.read(branchIdProvider);
      final currencyId = ref.read(expenseCurrencyIdProvider);
      final date = ref.read(dateProvider);
      final expenseAccountId = ref.read(expenseAccountIdProvider);
      final paidThroughId = ref.read(paidThroughIdProvider);

      // Optional fields
      final vendorId = ref.read(vendorIdProvider);
      final taxId = ref.read(taxIdProvider);
      final customerId = ref.read(customerIdProvider);
      final files = ref.read(expenseAttachmentProvider);

      // Clear previous errors
      ref.read(branchErrorProvider.notifier).state = null;
      ref.read(dateErrorProvider.notifier).state = null;
      ref.read(expenseAccountErrorProvider.notifier).state = null;
      ref.read(amountErrorProvider.notifier).state = null;
      ref.read(paidThroughErrorProvider.notifier).state = null;

      // Validation
      bool hasError = false;

      if (branchId == null) {
        ref.read(branchErrorProvider.notifier).state = "Branch is required.";
        hasError = true;
      }

      if (date == null) {
        ref.read(dateErrorProvider.notifier).state = "Date is required.";
        hasError = true;
      }

      if (expenseAccountId == null || expenseAccountId == 0) {
        ref.read(expenseAccountErrorProvider.notifier).state =
            "Expense account is required.";
        hasError = true;
      }

      if (amount.isEmpty || double.tryParse(amount) == null) {
        ref.read(amountErrorProvider.notifier).state =
            "Enter a valid expense amount.";
        hasError = true;
      }

      if (paidThroughId == null || paidThroughId == 0) {
        ref.read(paidThroughErrorProvider.notifier).state =
            "Paid through account is required.";
        hasError = true;
      }

      if (hasError) {
        showPayzoSnackBar(
          context: context,
          ref: ref,
          message: "Please fill all the required fields.",
          type: PayzoSnackType.error,
        );
        state = false;
        return;
      }

      // Build payload
      final expenseData = {
        'expenseId': expenseId,
        'branch': branchId,
        'currency': currencyId,
        'date': date?.toIso8601String(),
        'expenseAccountId': expenseAccountId,
        'expenseAmount': amount,
        'expenseDescription': notes,
        'reference': reference.isEmpty ? null : reference,
        'paidThroughAccountId': paidThroughId,
        'vendorId': vendorId,
        'vendorAccount': null,
        'tax': {
          'taxId': taxId,
          'taxType': ref.read(showExemptionReasonProvider)
              ? 'non-taxable'
              : 'standard-rate',
        },
        'exemptionReason': exemptionReason ?? '',
        'isModalShown': 1,
        'expenseInfo': '',
        'claimable': false,
      };

      print("📦 Updating Expense Payload: $expenseData");

      // Get file if exists
      File? attachedFile;
      if (files.isNotEmpty && files.first != null) {
        attachedFile = files.first;
      }

      // Call repository
      final repository = ref.read(expenseUpdateDeleteRepositoryProvider);
      final response = await repository.updateExpense(
        expenseId: expenseId,
        expenseData: expenseData,
        file: attachedFile,
      );

      print("✅ Expense updated successfully: $response");

      showPayzoSnackBar(
        context: context,
        ref: ref,
        message: "Expense updated successfully.",
        type: PayzoSnackType.success,
      );

      // Refresh expense list
      await ref.read(expensesPaginationStateProvider.notifier).fetchExpenses();

      // Navigate back
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("❌ Error updating expense: $e");
      showPayzoSnackBar(
        context: context,
        ref: ref,
        message: "Failed to update expense: $e",
        type: PayzoSnackType.error,
      );
    } finally {
      state = false;
    }
  }
}

final editExpenseControllerProvider =
    StateNotifierProvider<EditExpenseController, bool>((ref) {
  return EditExpenseController(ref);
});
