import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_summary_data.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/expenses/widgets/details/expense_detail_error_widget.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

class ExpenseDetailSummaryData extends ConsumerStatefulWidget {
  final int? expenseId;
  const ExpenseDetailSummaryData({required this.expenseId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpenseDetailSummaryDataState();
}

class _ExpenseDetailSummaryDataState
    extends ConsumerState<ExpenseDetailSummaryData> {
  @override
  Widget build(BuildContext context) {
    final id = widget.expenseId ?? 1;
    final expenseDetailsAsync = ref.watch(getExpenseDetailsProvider(id));

    return expenseDetailsAsync.when(
      data: (expenseDetail) {
        final data = expenseDetail.response;
        final currency = data?.currency ?? '';
        final amount = data?.expenseAmount ?? 0;

        return billSummaryData(
          subTotal: formatCurrency(amount.toDouble(), currency),
          discount: formatCurrency(0, currency),
          discountPercntage: formatPercentage(0),
          taxAmount: formatCurrency(0, currency),
          total: formatCurrency(amount.toDouble(), currency),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.appMainColor),
      ),
      error: (e, _) => expenseErrorWidget(
        error: e.toString(),
        onRetry: () => ref.refresh(getExpenseDetailsProvider(id)),
      ),
    );
  }
}
