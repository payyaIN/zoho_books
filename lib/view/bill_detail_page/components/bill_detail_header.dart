import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

class BillDetailHeaderData extends ConsumerStatefulWidget {
  final int? billId;
  const BillDetailHeaderData({required this.billId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillDetailHeaderDataHeaderState();
}

class _BillDetailHeaderDataHeaderState
    extends ConsumerState<BillDetailHeaderData> {
  @override
  Widget build(BuildContext context) {
    final effectiveBillId = widget.billId ?? 1;
    final billDetailsAsync = ref.watch(getBillDetailsProvider(effectiveBillId));
    return billDetailsAsync.when(
        data: (billDetail) {
          return headerTextAndWidgets(
              headerText1: formatCurrency(
                  billDetail.billTotalAmount, billDetail.billCurrency),
              headerText2: billDetail.billVenderName,
              title1: AppText.downloadpdf,
              title2: AppText.editBill,
              title3: AppText.deleteBill,
              // title4: AppText.recrngBill,
              // title5: AppText.makeBillPayment,
              title4: '',
              title5: '',
              img1: AppImages.printIcon,
              img2: AppImages.editWhite,
              img3: AppImages.delete,
              // img4: AppImages.invoicewhte,
              // img5: AppImages.billPayment,
              img4: '',
              img5: '',
              isOnTap1Needed: true,
              isOnTap2Needed: true,
              isOnTap3Needed: true,
              isOnTap4Needed: false,
              isOnTap5Needed: false,
              onTap1: () {
                print("Message icon tapped, initiating download...");
                downloadBillPdf(ref, context, billDetail.billId);
              },
              onTap2: () {},
              onTap3: () {},
              onTap4: () {},
              onTap5: () {});
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
