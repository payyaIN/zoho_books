import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/expene_export_screen.dart';
import 'package:payzo_books/view/expenses/expense_edit_screen.dart';
import 'package:payzo_books/view/expenses/expense_import_screen.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/expenses/repo/expense_update_delete_repository.dart';
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
          onTap1: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ExpenseImportScreen()),
            );
          },
          onTap2: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ExpenseExportScreen()),
            );
          },
          onTap3: () {
            // print("Message icon tapped, initiating expense PDF download...");
            // downloadExpensePdf(ref, context, data.transactionId?.toInt() ?? 0);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExpenseEditScreen(expenseId: effectiveExpenseId),
              ),
            );
          },
          onTap4: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Delete'),
                content:
                    const Text('Are you sure you want to delete this expense?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              final repository =
                  ref.read(expenseUpdateDeleteRepositoryProvider);
              final response =
                  await repository.deleteExpense(effectiveExpenseId);
              if (response['status'] == true) {
                Navigator.pop(context);
              }
            }
          },
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
