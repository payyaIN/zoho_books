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
          //   return headerTextAndWidgets(
          //     headerText1: formatCurrency(
          //         billDetail.billTotalAmount, billDetail.billCurrency),
          //     headerText2: billDetail.billVenderName,
          //     title1: AppText.edit,
          //     title2: AppText.payments,
          //     title3: AppText.downloadpdf,
          //     title4: AppText.more,
          //     title5: AppText.delete,
          //     img1: AppImages.editWhite,
          //     img2: AppImages.moneyBag,
          //     img3: AppImages.printIcon,
          //     img4: AppImages.more,
          //     img5: AppImages.delete,
          //     isonTap1Needed: false,
          //     isonTap4Needed: false,
          //     isonTap2Needed: false,
          //     isonTap5Needed: true,
          //     isonTap3Needed: true,
          //     onTap1: () {},
          //     onTap2: () {},
          //     onTap3: () {
          //       print("Message icon tapped, initiating download...");
          //       downloadBillPdf(ref, context, billDetail.billId);
          //     },
          //     onTap4: () {},
          //     onTap5: () {},
          //   );
          // },
          return headerTextAndWidgets(
              headerText1: formatCurrency(
                  billDetail.billTotalAmount, billDetail.billCurrency),
              headerText2: billDetail.billVenderName,
              imgName1: AppText.edit,
              imgName2: AppText.payments,
              imgName3: AppText.downloadpdf,
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
                print("Message icon tapped, initiating download...");
                downloadBillPdf(ref, context, billDetail.billId);
              },
              editOnTap: () {},
              isEditNeeded: false);
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
