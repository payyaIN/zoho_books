import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';

class ExpenseDetailAdditionalInfo extends ConsumerStatefulWidget {
  final int? expenseId;
  const ExpenseDetailAdditionalInfo({required this.expenseId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpenseDetailAdditionalInfoState();
}

class _ExpenseDetailAdditionalInfoState
    extends ConsumerState<ExpenseDetailAdditionalInfo> {
  @override
  Widget build(BuildContext context) {
    final id = widget.expenseId ?? 1;
    final expenseDetailsAsync = ref.watch(getExpenseDetailsProvider(id));

    return expenseDetailsAsync.when(
      data: (expenseDetail) {
        // These fields don't exist in the model, so skip rendering
        return const SizedBox();
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.appMainColor),
      ),
      error: (e, _) => billErrorWidget(
        error: e.toString(),
        onRetry: () => ref.refresh(getExpenseDetailsProvider(id)),
      ),
    );
  }
}
