import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/journal_entries/journal_entries_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_additional_info.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_appbar.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_bill_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_bill_summary_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_header.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_invoice_info.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_details_product_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_journal/bill_journal.dart';
import 'package:payzo_books/view/bill_detail_page/components/no_product_widget.dart';

class BillDetailPage extends ConsumerWidget {
  final int? billId;
  const BillDetailPage({Key? key, this.billId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveBillId = billId ?? 1;
    print('Building BillDetailPage for billId: $effectiveBillId');

    final billDetailsAsync = ref.watch(getBillDetailsProvider(effectiveBillId));

    final journalEntriesAsync =
        ref.watch(journalEntriesProvider(effectiveBillId));
    final branchListAsync = ref.watch(fetchBranchListProvider);
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: billDetailAppBar(context: context),
        body: RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(getBillDetailsProvider(effectiveBillId).future);
            await ref.refresh(journalEntriesProvider(effectiveBillId).future);
          },
          child: billDetailsAsync.when(
              data: (billDetail) {
                print(
                    'Bill details data received for billId: ${billDetail.billId}');

                final hasProducts = billDetail.productDetails.isNotEmpty;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BillDetailHeaderData(
                          billId: billDetail.billId,
                        ),
                        BillDetailInvoiceInfo(
                          billId: billDetail.billId,
                        ),
                        GapSpace.height20,
                        BillDetailBillData(
                          billId: billDetail.billId,
                        ),
                        GapSpace.height20,
                        productDetailsHeaderText(),
                        GapSpace.height15,
                        if (hasProducts) ...[
                          BillDetailProductData(billId: billId)
                        ] else ...[
                          noProductDataAvail()
                        ],
                        GapSpace.height20,
                        BillDetailBillSummaryData(
                          billId: billDetail.billId,
                        ),
                        GapSpace.height20,
                        BillDetailAdditionalInfo(
                          billId: billDetail.billId,
                        ),
                        GapSpace.height20,
                        BillJournalEntries(
                          journalEntriesAsync: journalEntriesAsync,
                          currency: billDetail.billCurrency,
                          // img: branchListAsync.when(
                          //   data: (branchList) {
                          //     return branchList.data != null &&
                          //             branchList.data!.isNotEmpty &&
                          //             branchList.data![0].logoUrl != null
                          //         ? branchList.data![0].logoUrl!
                          //         : '';
                          //   },
                          //   loading: () => '',
                          //   error: (_, __) => '',
                          // ),
                        ),
                        GapSpace.height40,
                      ],
                    ),
                  ),
                );
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
                  )),
        ),
      ),
    );
  }
}
