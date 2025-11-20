import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/expenses/widgets/details/expense_detail_error_widget.dart';

class ExpenseDetailExpenseData extends ConsumerStatefulWidget {
  final int? expenseId;
  const ExpenseDetailExpenseData({required this.expenseId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpenseDetailExpenseDataState();
}

class _ExpenseDetailExpenseDataState
    extends ConsumerState<ExpenseDetailExpenseData> {
  @override
  Widget build(BuildContext context) {
    final effectiveExpenseId = widget.expenseId ?? 1;
    final expenseDetailsAsync =
        ref.watch(getExpenseDetailsProvider(effectiveExpenseId));

    return expenseDetailsAsync.when(
      data: (expenseDetail) {
        final data = expenseDetail.response;
        return billData(
          context: context,
          isBill: false,
          billStatus: 0, // Assuming no status badge for expense or make custom
          rightText1: data?.transactionId.toString() ?? '-',
          rightText2: formatDateFn(DateTime.tryParse(data?.date ?? '')),
          rightText3: '-', // Expenses don't have due dates
          rightText4: data?.currency ?? '-',
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
