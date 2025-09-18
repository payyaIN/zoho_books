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
          headerText1: formatCurrency(data.expenseAmount!.toDouble(), data.currency!),
          headerText2: data.vendor ?? '',
          imgName1: AppText.edit,
          imgName2: AppText.payments,
          imgName3: AppText.printpdf,
          imgName4: AppText.more,
          img1: AppImages.editWhite,
          img2: AppImages.moneyBag,
          img3: AppImages.printIcon,
          img4: AppImages.more,
          isMailNeeded: false,
          isCallNeeded: false,
          callOnTap: () {},
          mailOnTap: () {},
          msgOnTap: () {
            print("Message icon tapped, initiating expense PDF download...");
            // downloadExpensePdf(ref, context, data.transactionId?.toInt() ?? 0);
          },
          moreOnTap: () {},
          isMoreNeeded: false,
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
