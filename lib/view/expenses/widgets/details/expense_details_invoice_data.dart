import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/expenses/widgets/details/expense_detail_error_widget.dart';

class ExpenseDetailInvoiceInfo extends ConsumerStatefulWidget {
  final int? expenseId;
  const ExpenseDetailInvoiceInfo({required this.expenseId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpenseDetailInvoiceInfoState();
}

class _ExpenseDetailInvoiceInfoState
    extends ConsumerState<ExpenseDetailInvoiceInfo> {
  @override
  Widget build(BuildContext context) {
    final id = widget.expenseId ?? 1;
    final expenseDetailsAsync = ref.watch(getExpenseDetailsProvider(id));

    return expenseDetailsAsync.when(
      data: (expenseDetail) {
        final data = expenseDetail.response!;
        return invoiceAndBillInformationWidget(
          isBill: false,
          invoiceCreatedByName: '', // not available in the response
          invoiceCreatedBy: '', // not available in the response
          invoiceCustomerName: data.vendor ?? '',
          // invoiceShippingType: data.paidThrough ?? '',
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
