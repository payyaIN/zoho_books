import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/reusable_snackbar.dart';
import 'package:payzo_books/view/expenses/expene_export_screen.dart';
import 'package:payzo_books/view/expenses/expense_edit_screen.dart';
import 'package:payzo_books/view/expenses/expense_import_screen.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/expenses/repo/expense_update_delete_repository.dart';
import 'package:payzo_books/view/expenses/update_expense/update_expense.dart';
import 'package:payzo_books/view/expenses/widgets/details/download_expense_pdf.dart';
import 'package:payzo_books/view/expenses/widgets/details/expense_detail_error_widget.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

class ExpenseDetailHeaderData extends ConsumerStatefulWidget {
  final int? expenseId;
  const ExpenseDetailHeaderData({required this.expenseId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpenseDetailHeaderDataState();
}

class _ExpenseDetailHeaderDataState
    extends ConsumerState<ExpenseDetailHeaderData> {
  @override
  Widget build(BuildContext context) {
    final effectiveExpenseId = widget.expenseId ?? 1;
    final expenseDetailsAsync =
        ref.watch(getExpenseDetailsProvider(effectiveExpenseId));
    return expenseDetailsAsync.when(
      data: (expenseDetail) {
        final data = expenseDetail.response!;
        return headerTextAndWidgets(
          headerText1:
              formatCurrency(data.expenseAmount!.toDouble(), data.currency!),
          headerText2: data.vendor ?? '',
          // title1: AppText.importExpense,
          // title2: AppText.exportExcelExpense,
          title1: AppText.editExpense,
          title2: AppText.deleteExpense,
          title3: '',
          title4: '',
          title5: '',
          // img1: AppImages.importExpense,
          // img2: AppImages.exportExpense,
          img1: AppImages.editWhite,
          img2: AppImages.delete,
          img3: '',
          img4: '',
          img5: '',
          isOnTap1Needed: true,
          isOnTap2Needed: true,
          isOnTap3Needed: false,
          isOnTap4Needed: false,
          isOnTap5Needed: false,

          onTap1: () async {
            // Navigate to UpdateExpenseScreen which will handle all API calls
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateExpenseScreen(
                  expenseId: widget.expenseId!,
                ),
              ),
            );

            // After returning from update screen, refresh the expense details
            ref.invalidate(getExpenseDetailsProvider(widget.expenseId!));

            // Also refresh the expense list
            ref.read(expensesPaginationStateProvider.notifier).fetchExpenses();
          },
          // onTap2: () async {
          //   final confirmed = await showDialog<bool>(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //       title: const Text('Confirm Delete'),
          //       content:
          //           const Text('Are you sure you want to delete this expense?'),
          //       actions: [
          //         TextButton(
          //           onPressed: () => Navigator.pop(context, false),
          //           child: const Text('Cancel'),
          //         ),
          //         ElevatedButton(
          //           onPressed: () => Navigator.pop(context, true),
          //           child: const Text('Delete'),
          //         ),
          //       ],
          //     ),
          //   );

          //   if (confirmed == true) {
          //     final repository =
          //         ref.read(expenseUpdateDeleteRepositoryProvider);
          //     final response =
          //         await repository.deleteExpense(effectiveExpenseId);
          //     if (response['status'] == true) {
          //       Navigator.pop(context);
          //     }
          //   }
          // },
          onTap2: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Expense'),
                content: const Text(
                  'Are you sure you want to delete this expense? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );

            if (confirmed == true && context.mounted) {
              try {
                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appMainColor,
                    ),
                  ),
                );

                // Delete expense
                final repository =
                    ref.read(expenseUpdateDeleteRepositoryProvider);
                await repository.deleteExpense(effectiveExpenseId);

                // Close loading dialog
                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                // Show success message
                showPayzoSnackBar(
                  context: context,
                  ref: ref,
                  message: "Expense deleted successfully.",
                  type: PayzoSnackType.success,
                );

                // Refresh expense list
                await ref
                    .read(expensesPaginationStateProvider.notifier)
                    .fetchExpenses();

                // Navigate back
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                // Close loading dialog if still open
                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                // Show error message
                showPayzoSnackBar(
                  context: context,
                  ref: ref,
                  message: "Failed to delete expense: $e",
                  type: PayzoSnackType.error,
                );
              }
            }
          },

          onTap3: () {},
          onTap4: () {},
          onTap5: () {},
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.appMainColor,
        ),
      ),
      error: (e, stackTrace) => expenseErrorWidget(
        error: e.toString(),
        onRetry: () =>
            ref.refresh(getExpenseDetailsProvider(effectiveExpenseId)),
      ),
    );
  }
}
