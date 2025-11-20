import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/reusable_snackbar.dart';
import 'package:payzo_books/view/expenses/expense_edit_screen.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/expenses/repo/expense_update_delete_repository.dart';
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
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

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
          title1: AppText.editExpense,
          title2: AppText.deleteExpense,
          title3: '',
          title4: '',
          title5: '',
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

          // ✅ DIRECT navigation to ExpenseEditScreen - NO wrapper
          onTap1: () async {
            print('🔘 Edit button tapped - navigating to ExpenseEditScreen');
            if (!_isMounted || !mounted) return;

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseEditScreen(
                  expenseId: widget.expenseId!,
                ),
              ),
            );

            if (!_isMounted || !mounted) return;
            ref.invalidate(getExpenseDetailsProvider(widget.expenseId!));
          },

          onTap2: () async {
            if (!_isMounted || !mounted) return;

            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Confirm Delete'),
                  ],
                ),
                content: const Text(
                  'Are you sure you want to delete this expense?',
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

            if (!_isMounted || !mounted) return;

            if (confirmed == true) {
              try {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appMainColor,
                    ),
                  ),
                );

                final repository =
                    ref.read(expenseUpdateDeleteRepositoryProvider);
                await repository.deleteExpense(effectiveExpenseId);

                if (!_isMounted || !mounted) return;
                Navigator.of(context).pop();

                showPayzoSnackBar(
                  context: context,
                  ref: ref,
                  message: "Expense deleted successfully.",
                  type: PayzoSnackType.success,
                );

                await ref
                    .read(expensesPaginationStateProvider.notifier)
                    .fetchExpenses();

                if (!_isMounted || !mounted) return;
                Navigator.of(context).pop();
              } catch (e) {
                if (!_isMounted || !mounted) return;
                Navigator.of(context).pop();

                showPayzoSnackBar(
                  context: context,
                  ref: ref,
                  message: "Failed to delete: $e",
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
      error: (e, stackTrace) {
        if (!_isMounted || !mounted) {
          return const SizedBox.shrink();
        }

        return expenseErrorWidget(
          error: e.toString(),
          onRetry: () {
            if (_isMounted && mounted) {
              ref.refresh(getExpenseDetailsProvider(effectiveExpenseId));
            }
          },
        );
      },
    );
  }
}
