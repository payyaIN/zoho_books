import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/journal_entries/journal_entries_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_journal/bill_journal.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

class InvoiceDetailPage extends ConsumerWidget {
  final int? invoiceId;
  const InvoiceDetailPage({Key? key, this.invoiceId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveInvoiceId = invoiceId ?? 1;
    print('Building InvoiceDetailPage for invoiceId: $effectiveInvoiceId');

    final invoiceDetailsAsync =
        ref.watch(getInvoiceDetailsProvider(effectiveInvoiceId));
    final journalEntriesAsync =
        ref.watch(journalEntriesProvider(effectiveInvoiceId));

    final branchListAsync = ref.watch(fetchBranchListProvider);
    print('Building InvoiceDetailPage for invoiceId: $effectiveInvoiceId');

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: reusableAppBar(
            title: 'Invoice Details', showBackButton: true, context: context),
        body: RefreshIndicator(
          onRefresh: () async {
            await ref
                .refresh(getInvoiceDetailsProvider(effectiveInvoiceId).future);
            await ref
                .refresh(journalEntriesProvider(effectiveInvoiceId).future);
          },
          child: invoiceDetailsAsync.when(
            data: (invoiceDetail) {
              print(
                  'Invoice details data received for invoiceId: ${invoiceDetail.invoiceId}');

              final hasProducts = invoiceDetail.productDetails.isNotEmpty;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerTextAndWidgets(
                          headerText1: formatCurrency(
                              invoiceDetail.invoiceTotalAmount,
                              invoiceDetail.invoiceCurrency),
                          headerText2: invoiceDetail.invoiceCustomerName,
                          title1: AppText.importInvoice,
                          title2: AppText.downloadpdf,
                          title3: AppText.recrngInvc,
                          title4: AppText.creditNote,
                          title5: AppText.debitNote,
                          img1: AppImages.importExpense,
                          img2: AppImages.printIcon,
                          img3: AppImages.invoicewhte,
                          img4: AppImages.createAndDebitNote,
                          img5: AppImages.createAndDebitNote,
                          isOnTap1Needed: true,
                          isOnTap2Needed: true,
                          isOnTap3Needed: true,
                          isOnTap4Needed: true,
                          isOnTap5Needed: true,
                          onTap1: () {},
                          onTap2: () {},
                          onTap3: () {
                            print(
                                "Message icon tapped, initiating download...");
                            downloadInvoicePdf(
                                ref, context, invoiceDetail.invoiceId);
                          },
                          onTap4: () {},
                          onTap5: () {}),
                      invoiceAndBillInformationWidget(
                        isBill: false,
                        invoiceCreatedByName:
                            invoiceDetail.invoiceCreatedByName,
                        invoiceCreatedBy: invoiceDetail.invoiceCreatedBy,
                        invoiceCustomerName: invoiceDetail.invoiceCustomerName,
                        // invoiceShippingType:
                        //     invoiceDetail.invoiceShippingType
                      ),
                      GapSpace.height20,
                      billData(
                          context: context,
                          isBill: false,
                          // isVerified: invoiceDetail.isInvoiceverified,
                          billStatus: invoiceDetail.invoiceStatus,
                          rightText1: invoiceDetail.invoiceNumber,
                          rightText2: formatDateFn(invoiceDetail.invoiceDate),
                          rightText3:
                              formatDateFn(invoiceDetail.invoiceDueDate),
                          rightText4: invoiceDetail.invoiceCurrency),
                      GapSpace.height20,
                      productDetailsHeaderText(),
                      GapSpace.height15,
                      productDetailWidget(
                          isBill: false,
                          billDetails: [],
                          hasProducts: hasProducts,
                          productDetails: invoiceDetail.productDetails,
                          invoiceCustomerName:
                              invoiceDetail.invoiceCustomerName,
                          invoiceCurrency: invoiceDetail.invoiceCurrency),
                      GapSpace.height20,
                      invoiceSummary(
                        invoiceAmount: invoiceDetail.invoiceAmount,
                        invoiceCurrency: invoiceDetail.invoiceCurrency,
                        invoiceTotalAmount: invoiceDetail.invoiceTotalAmount,
                      ),
                      GapSpace.height20,
                      invoiceDetail.invoiceCustomerNotes.trim().isNotEmpty ||
                              invoiceDetail.invoiceTermsAndConditions
                                  .trim()
                                  .isNotEmpty
                          ? additionalInfo(
                              invoiceCustomerNotes:
                                  invoiceDetail.invoiceCustomerNotes,
                              invoiceTermsAndConditions:
                                  invoiceDetail.invoiceTermsAndConditions)
                          : SizedBox(),
                      GapSpace.height40,
                      invoiceDetail.invoicePaymentTerms.trim().isNotEmpty &&
                              invoiceDetail.invoiceBankAcc.trim().isNotEmpty
                          ? paymentInfo(
                              invoiceBankAcc: invoiceDetail.invoiceBankAcc,
                              invoicePaymentTerms:
                                  invoiceDetail.invoicePaymentTerms)
                          : SizedBox(),
                      invoiceDetail.invoicePaymentTerms.trim().isNotEmpty &&
                              invoiceDetail.invoiceBankAcc.trim().isNotEmpty
                          ? GapSpace.height40
                          : SizedBox(),
                      GapSpace.height20,
                      BillJournalEntries(
                        journalEntriesAsync: journalEntriesAsync,
                        currency: invoiceDetail.invoiceCurrency,
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
            error: (error, stackTrace) => errorColumn(
              errorText: error,
              onRetry: () =>
                  ref.refresh(getInvoiceDetailsProvider(effectiveInvoiceId)),
            ),
          ),
        ),
      ),
    );
  }
}
