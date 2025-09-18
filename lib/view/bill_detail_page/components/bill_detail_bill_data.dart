import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';

class BillDetailBillData extends ConsumerStatefulWidget {
  final int? billId;
  const BillDetailBillData({required this.billId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillDetailBillDataState();
}

class _BillDetailBillDataState extends ConsumerState<BillDetailBillData> {
  @override
  Widget build(BuildContext context) {
    final effectiveBillId = widget.billId ?? 1;
    final billDetailsAsync = ref.watch(getBillDetailsProvider(effectiveBillId));
    return billDetailsAsync.when(
        data: (billDetail) {
          return billData(
              context: context,
              isBill: true,
              // isVerified: billDetail.isBillVerified,
              billStatus: billDetail.billStatus,
              rightText1: billDetail.billInvoiceNumber,
              rightText2: formatDateFn(billDetail.billDate),
              rightText3: formatDateFn(billDetail.billDueDate),
              rightText4: billDetail.billCurrency);
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
