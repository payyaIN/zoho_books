import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/reusable_snackbar.dart';
import 'package:payzo_books/view/add/add_expense/widgets/add_expense_form.dart';
import 'package:payzo_books/view/expenses/provider/edit_expense_provider.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/expenses/repo/expense_update_delete_repository.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';

class ExpenseEditScreen extends ConsumerStatefulWidget {
  final int expenseId;

  const ExpenseEditScreen({
    Key? key,
    required this.expenseId,
  }) : super(key: key);

  @override
  ConsumerState<ExpenseEditScreen> createState() => _ExpenseEditScreenState();
}

class _ExpenseEditScreenState extends ConsumerState<ExpenseEditScreen> {
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExpenseData();
    });
  }

  Future<void> _loadExpenseData() async {
    try {
      print('🔄 Loading expense data for ID: ${widget.expenseId}');

      // Set edit mode
      ref.read(editExpenseModeProvider.notifier).state = true;
      ref.read(editExpenseIdProvider.notifier).state = widget.expenseId;

      // Fetch expense details
      final expenseDetails =
          await ref.read(getExpenseDetailsProvider(widget.expenseId).future);

      if (expenseDetails.response == null) {
        throw Exception('No expense data found');
      }

      final data = expenseDetails.response!;
      print('📝 Expense data: ${data.toJson()}');

      // Populate text fields
      if (data.expenseAmount != null) {
        ref.read(amountControllerProvider).text = data.expenseAmount.toString();
      }
      if (data.reference != null && data.reference.toString().isNotEmpty) {
        ref.read(referenceControllerProvider).text = data.reference.toString();
      }
      if (data.expenseDescription != null) {
        ref.read(notesControllerProvider).text = data.expenseDescription!;
      }
      if (data.expenseInfo != null) {
        ref.read(expenseInfoControllerProvider).text = data.expenseInfo!;
      }
      if (data.exemptionReason != null) {
        ref.read(expensesExemptionReasonControllerProvider).text =
            data.exemptionReason!;
      }

      // Set date - handle multiple formats
      if (data.date != null && data.date!.isNotEmpty) {
        try {
          DateTime? parsedDate;
          // Try ISO format first
          try {
            parsedDate = DateTime.parse(data.date!);
          } catch (e) {
            // Try dd-MM-yyyy
            try {
              parsedDate = DateFormat('dd-MM-yyyy').parse(data.date!);
            } catch (e2) {
              // Try yyyy-MM-dd
              try {
                parsedDate = DateFormat('yyyy-MM-dd').parse(data.date!);
              } catch (e3) {
                print('⚠️ Could not parse date: ${data.date}');
                parsedDate = DateTime.now();
              }
            }
          }
          ref.read(dateProvider.notifier).state = parsedDate;
          print('✅ Date set: $parsedDate');
        } catch (e) {
          print('Error parsing date: $e');
          ref.read(dateProvider.notifier).state = DateTime.now();
        }
      }

      // Set dropdown selections with both ID and display name
      if (data.branchId != null) {
        ref.read(branchIdProvider.notifier).state = data.branchId;
        ref.read(branchProvider.notifier).state = data.branch ?? '';
      }

      if (data.currencyId != null) {
        ref.read(expenseCurrencyIdProvider.notifier).state = data.currencyId;
        ref.read(expenseCurrencyProvider.notifier).state = data.currency ?? '';
      }

      if (data.expenseAccountId != null) {
        ref.read(expenseAccountIdProvider.notifier).state =
            data.expenseAccountId;
        ref.read(expenseAccountProvider.notifier).state =
            data.expenseAccount ?? '';
      }

      if (data.paidThroughAccountId != null) {
        ref.read(paidThroughIdProvider.notifier).state =
            data.paidThroughAccountId;
        ref.read(paidThroughProvider.notifier).state =
            data.paidThroughAccount ?? '';
      }

      if (data.vendorId != null) {
        ref.read(vendorIdProvider.notifier).state = data.vendorId;
        ref.read(vendorProvider.notifier).state = data.vendor ?? '';
      }

      if (data.customerId != null) {
        ref.read(customerIdProvider.notifier).state = data.customerId;
        ref.read(customerProvider.notifier).state = data.customerName ?? '';
      }

      if (data.taxId != null) {
        ref.read(taxIdProvider.notifier).state = data.taxId;
        ref.read(taxProvider.notifier).state = data.taxName ?? '';
      }

      final isClaimable = data.isClaimable ?? false;
      print('➡️ Setting Claimable: $isClaimable');

      ref
          .read(productTypeProvider.notifier)
          .updateField('isClaimable', isClaimable);
      final radioValue = isClaimable ? 'Claimable' : 'Non-claimable';
      ref.read(productTypeProvider.notifier).updateRadio('type', radioValue);

      print('✅ All expense data loaded successfully');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading expense data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading expense: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateExpense() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      // Get form data
      final amount = ref.read(amountControllerProvider).text.trim();
      final reference = ref.read(referenceControllerProvider).text.trim();
      final notes = ref.read(notesControllerProvider).text.trim();
      final exemptionReason =
          ref.read(expensesExemptionReasonControllerProvider).text.trim();
      final expenseInfo = ref.read(expenseInfoControllerProvider).text.trim();

      // Get selections
      final branchId = ref.read(branchIdProvider);
      final currencyId = ref.read(expenseCurrencyIdProvider);
      final date = ref.read(dateProvider);
      final expenseAccountId = ref.read(expenseAccountIdProvider);
      final paidThroughId = ref.read(paidThroughIdProvider);
      final vendorId = ref.read(vendorIdProvider);
      final taxId = ref.read(taxIdProvider);
      final customerId = ref.read(customerIdProvider);
      final files = ref.read(expenseAttachmentProvider);
      final isClaimable = ref.read(productTypeProvider).isClaimable;

      // Validate required fields
      if (branchId == null ||
          date == null ||
          expenseAccountId == null ||
          amount.isEmpty ||
          paidThroughId == null) {
        showPayzoSnackBar(
          context: context,
          ref: ref,
          message: "Please fill all required fields",
          type: PayzoSnackType.error,
        );
        setState(() {
          _isUpdating = false;
        });
        return;
      }

      // Build update payload
      final payload = {
        'expenseId': widget.expenseId,
        'branch': branchId,
        'currency': currencyId,
        'date': date.toIso8601String(),
        'expenseAccountId': expenseAccountId,
        'expenseAmount': amount,
        'expenseDescription': notes,
        'reference': reference,
        'paidThroughAccountId': paidThroughId,
        'vendorId': vendorId,
        'vendorAccount': null,
        'exemptionReason': exemptionReason.isNotEmpty ? exemptionReason : null,
        'expenseInfo': expenseInfo.isNotEmpty ? expenseInfo : null,
        'tax': {
          'taxId': taxId,
          'taxType': ref.read(showExemptionReasonProvider)
              ? 'non-taxable'
              : 'standard-rate',
        },
        'customerDto': {
          'customerId': customerId,
          'curtomerChartOfAccountId': null,
          'billable': false,
          'markUpby': null,
          'projectId': 1,
        },
        'isClaimable': isClaimable,
      };

      print('📦 Update payload: $payload');

      // Call update API
      final repository = ref.read(expenseUpdateDeleteRepositoryProvider);
      final response = await repository.updateExpense(
        expenseId: widget.expenseId,
        expenseData: payload,
        file: files.isNotEmpty ? files.first : null,
      );

      print('✅ Update response: $response');

      if (mounted) {
        showPayzoSnackBar(
          context: context,
          ref: ref,
          message: response['message'] ?? "Expense updated successfully",
          type: PayzoSnackType.success,
        );

        // Refresh expense list
        await ref
            .read(expensesPaginationStateProvider.notifier)
            .fetchExpenses();

        // Navigate back
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('❌ Error updating expense: $e');
      if (mounted) {
        showPayzoSnackBar(
          context: context,
          ref: ref,
          message: "Failed to update: $e",
          type: PayzoSnackType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clear edit mode when leaving
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editExpenseModeProvider.notifier).state = false;
      ref.read(editExpenseIdProvider.notifier).state = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: Watch these autoDispose providers to keep them alive
    // while this screen is active. This prevents them from being disposed
    // when _isLoading is true (and AddExpenseForm is not yet built),
    // which would cause the data we just loaded to be lost.
    ref.watch(amountControllerProvider);
    ref.watch(referenceControllerProvider);
    ref.watch(notesControllerProvider);
    ref.watch(expenseInfoControllerProvider);
    ref.watch(expensesExemptionReasonControllerProvider);
    ref.watch(productTypeProvider).type;

    return ScalingFactor(
      child: Scaffold(
        appBar: reusableAppBar(
          title: 'Edit Expense',
          showBackButton: true,
          context: context,
        ),
        body: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading expense data...'),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    const AddExpenseForm(), // Same UI as add expense
                    const SizedBox(height: 15),
                  ],
                ),
              ),
        bottomNavigationBar: _isLoading
            ? null
            : PayzoFormSubmitTwoButtons(
                safeArea: true,
                cancelText: 'Cancel',
                saveText: _isUpdating ? 'Updating...' : 'Update',
                cancelOnPressed: () {
                  _isUpdating
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        };
                },
                saveOnPressed: () {
                  _isUpdating ? null : _updateExpense();
                },
              ),
      ),
    );
  }
}
