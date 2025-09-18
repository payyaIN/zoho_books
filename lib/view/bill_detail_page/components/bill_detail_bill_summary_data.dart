import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_summary_data.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

class BillDetailBillSummaryData extends ConsumerStatefulWidget {
  final int? billId;
  const BillDetailBillSummaryData({required this.billId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillDetailBillSummaryDataState();
}

class _BillDetailBillSummaryDataState
    extends ConsumerState<BillDetailBillSummaryData> {
  @override
  Widget build(BuildContext context) {
    final effectiveBillId = widget.billId ?? 1;
    final billDetailsAsync = ref.watch(getBillDetailsProvider(effectiveBillId));
    return billDetailsAsync.when(
        data: (billDetail) {
          return billSummaryData(
              subTotal: formatCurrency(
                  billDetail.billAmount, billDetail.billCurrency),
              discount: formatCurrency(
                  billDetail.billDiscountAmount, billDetail.billCurrency),
              discountPercntage:
                  formatPercentage(billDetail.billDiscountPercentage),
              taxAmount: formatCurrency(
                  billDetail.billTotalAmount - billDetail.billAmount,
                  billDetail.billCurrency),
              total: formatCurrency(
                  billDetail.billTotalAmount, billDetail.billCurrency));
        },
        loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.appMainColor,
              ),
            ),
        error: (e, stackTrace) => billErrorWidget(
              error: e.toString(),
              onRetry: () =>
                  ref.refresh(getBillDetailsProvider(effectiveBillId)),
            ));
  }
}
