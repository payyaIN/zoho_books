import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
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
          title1: AppText.importExpense,
          title2: AppText.exportExcelExpense,
          title3: AppText.editExpense,
          title4: AppText.deleteExpense,
          title5: '',
          img1: AppImages.importExpense,
          img2: AppImages.exportExpense,
          img3: AppImages.editWhite,
          img4: AppImages.delete,
          img5: '',
          isOnTap1Needed: true,
          isOnTap2Needed: true,
          isOnTap3Needed: true,
          isOnTap4Needed: true,
          isOnTap5Needed: false,
          onTap1: () {},
          onTap2: () {},
          onTap3: () {
            print("Message icon tapped, initiating expense PDF download...");
            // downloadExpensePdf(ref, context, data.transactionId?.toInt() ?? 0);
          },
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
