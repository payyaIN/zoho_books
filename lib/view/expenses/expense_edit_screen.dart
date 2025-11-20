// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/view/add/add_expense/widgets/add_expense_form.dart';
// import 'package:payzo_books/view/expenses/controller/edit_expense_controller.dart';
// import 'package:payzo_books/view/expenses/provider/edit_expense_provider.dart';
// import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';

// class ExpenseEditScreen extends ConsumerStatefulWidget {
//   final int expenseId;

//   const ExpenseEditScreen({
//     Key? key,
//     required this.expenseId,
//   }) : super(key: key);

//   @override
//   ConsumerState<ExpenseEditScreen> createState() => _ExpenseEditScreenState();
// }

// class _ExpenseEditScreenState extends ConsumerState<ExpenseEditScreen> {
//   bool _isDataLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     // Load expense data after widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadExpenseData();
//     });
//   }

//   Future<void> _loadExpenseData() async {
//     if (_isDataLoaded) return;

//     try {
//       // Fetch expense details
//       final expenseDetails =
//           await ref.read(getExpenseDetailsProvider(widget.expenseId).future);

//       if (expenseDetails.response != null) {
//         final data = expenseDetails.response!;

//         // Set edit mode
//         ref.read(editExpenseModeProvider.notifier).state = true;
//         ref.read(editExpenseIdProvider.notifier).state = widget.expenseId;

//         // Populate text controllers
//         if (data.expenseAmount != null) {
//           ref.read(amountControllerProvider).text =
//               data.expenseAmount.toString();
//         }
//         if (data.reference != null) {
//           ref.read(referenceControllerProvider).text = data.reference!;
//         }
//         if (data.expenseDescription != null) {
//           ref.read(notesControllerProvider).text = data.expenseDescription!;
//         }

//         // Set date
//         if (data.date != null) {
//           try {
//             ref.read(dateProvider.notifier).state = DateTime.parse(data.date!);
//           } catch (e) {
//             print('Error parsing date: $e');
//           }
//         }

//         // Set branch
//         if (data.branchId != null) {
//           ref.read(branchIdProvider.notifier).state = data.branchId;
//           ref.read(branchProvider.notifier).state = data.branch ?? '';
//         }

//         // Set currency
//         if (data.currencyId != null) {
//           ref.read(expenseCurrencyIdProvider.notifier).state = data.currencyId;
//           ref.read(expenseCurrencyProvider.notifier).state =
//               data.currency ?? '';
//         }

//         // Set expense account
//         if (data.expenseAccountId != null) {
//           ref.read(expenseAccountIdProvider.notifier).state =
//               data.expenseAccountId;
//           ref.read(expenseAccountProvider.notifier).state =
//               data.expenseAccount ?? '';
//         }

//         // Set paid through account
//         if (data.paidThroughAccountId != null) {
//           ref.read(paidThroughIdProvider.notifier).state =
//               data.paidThroughAccountId;
//           ref.read(paidThroughProvider.notifier).state =
//               data.paidThroughAccount ?? '';
//         }

//         // Set vendor
//         if (data.vendorId != null) {
//           ref.read(vendorIdProvider.notifier).state = data.vendorId;
//           ref.read(vendorProvider.notifier).state = data.vendor ?? '';
//         }

//         // Set customer
//         if (data.customerId != null) {
//           ref.read(customerIdProvider.notifier).state = data.customerId;
//           ref.read(customerProvider.notifier).state = data.customerName ?? '';
//         }

//         // Set tax
//         if (data.taxId != null) {
//           ref.read(taxIdProvider.notifier).state = data.taxId;
//           ref.read(taxProvider.notifier).state = data.taxName ?? '';
//         }

//         // Mark as loaded
//         setState(() {
//           _isDataLoaded = true;
//         });
//       }
//     } catch (e) {
//       print('Error loading expense data: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error loading expense data: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     // Clear edit mode when leaving
//     ref.read(editExpenseModeProvider.notifier).state = false;
//     ref.read(editExpenseIdProvider.notifier).state = null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScalingFactor(
//       child: PopScope(
//         onPopInvokedWithResult: (didPop, result) {
//           if (didPop) {
//             // Clear edit mode
//             ref.read(editExpenseModeProvider.notifier).state = false;
//             ref.read(editExpenseIdProvider.notifier).state = null;
//           }
//         },
//         child: Scaffold(
//           appBar: reusableAppBar(
//             title: 'Edit Expense',
//             showBackButton: true,
//             context: context,
//             onBackPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           body: _isDataLoaded
//               ? SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       // Reuse the same form from Add Expense
//                       const AddExpenseForm(),
//                       const SizedBox(height: 20),
//                       // Update button
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               final controller = ref
//                                   .read(editExpenseControllerProvider.notifier);
//                               await controller.updateExpense(
//                                 context,
//                                 ref,
//                                 widget.expenseId,
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.appMainColor,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: ref.watch(editExpenseControllerProvider)
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text(
//                                     'Update Expense',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const Center(
//                   child: CircularProgressIndicator(
//                     color: AppColors.appMainColor,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

// REPLACE: lib/view/expenses/expense_edit_screen.dart

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
