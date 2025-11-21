// import 'package:payzo_books/data/repository/bills_api/bills_api.dart';
// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';
// import 'package:payzo_books/view/bill_screen/provider/bill_pagination_provider.dart';
// import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

// import 'package:payzo_books/data/repository/bills_api/bill_actions_repository.dart';
// import 'package:payzo_books/view/bill_detail_page/components/recurring_bill_modal.dart';
// import 'package:payzo_books/view/bill_screen/edit_bill_screen.dart';
// import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';

// class BillDetailHeaderData extends ConsumerStatefulWidget {
//   final int? billId;
//   const BillDetailHeaderData({required this.billId, super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _BillDetailHeaderDataHeaderState();
// }

// class _BillDetailHeaderDataHeaderState
//     extends ConsumerState<BillDetailHeaderData> {
//   @override
//   Widget build(BuildContext context) {
//     final effectiveBillId = widget.billId ?? 1;
//     final billDetailsAsync = ref.watch(getBillDetailsProvider(effectiveBillId));
//     return billDetailsAsync.when(
//         data: (billDetail) {
//           return headerTextAndWidgets(
//               headerText1: formatCurrency(
//                   billDetail.billTotalAmount, billDetail.billCurrency),
//               headerText2: billDetail.billVenderName,
//               title1: AppText.downloadpdf,
//               title2: AppText.editBill,
//               title3: AppText.deleteBill,
//               title4: AppText.recrngBill,
//               title5: '',
//               img1: AppImages.printIcon,
//               img2: AppImages.editWhite,
//               img3: AppImages.delete,
//               img4: AppImages.invoicewhte,
//               img5: '',
//               isOnTap1Needed: true,
//               isOnTap2Needed: true,
//               isOnTap3Needed: true,
//               isOnTap4Needed: true,
//               isOnTap5Needed: false,
//               onTap1: () {
//                 print("Message icon tapped, initiating download...");
//                 downloadBillPdf(ref, context, billDetail.billId);
//               },
//               onTap2: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         EditBillScreen(billId: billDetail.billId),
//                   ),
//                 ).then((_) {
//                   // Refresh details after edit
//                   ref.refresh(getBillDetailsProvider(effectiveBillId));
//                 });
//               },
//               onTap3: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Delete Bill'),
//                     content: const Text(
//                         'Are you sure you want to delete this bill?'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () async {
//                           // Capture context-dependent objects
//                           final navigator = Navigator.of(context);
//                           final messenger = ScaffoldMessenger.of(context);

//                           navigator.pop(); // Close confirmation dialog

//                           showPayzoProgress(context: context);

//                           try {
//                             final repo =
//                                 ref.read(billActionsRepositoryProvider);
//                             final success =
//                                 await repo.deleteBill(billDetail.billId);

//                             navigator.pop(); // Close progress dialog

//                             if (success) {
//                               // Refresh list
//                               await ref
//                                   .read(billPaginationStateProvider.notifier)
//                                   .refresh();
// ref.invalidate(getBillDataWithPagination);
// ref.invalidate(getBillData);

//                               messenger.showSnackBar(
//                                 const SnackBar(
//                                     content: Text('Bill deleted successfully')),
//                               );

//                               navigator.pop(); // Close BillDetailPage
//                             } else {
//                               messenger.showSnackBar(
//                                 const SnackBar(
//                                     content: Text('Failed to delete bill')),
//                               );
//                             }
//                           } catch (e) {
//                             navigator.pop(); // Close progress dialog
//                             messenger.showSnackBar(
//                               SnackBar(content: Text('Error: $e')),
//                             );
//                           }
//                         },
//                         child: const Text('Delete',
//                             style: TextStyle(color: Colors.red)),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               onTap4: () {
//                 showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   builder: (context) => Padding(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).viewInsets.bottom),
//                     child: RecurringBillModal(billId: billDetail.billId),
//                   ),
//                 );
//               },
//               onTap5: () {});
//         },
//         loading: () => const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.appMainColor,
//               ),
//             ),
//         error: (e, stackTrace) => billErrorWidget(
//               error: e.toString(),
//               onRetry: () =>
//                   ref.refresh(getBillDetailsProvider(effectiveBillId)),
//             ));
//   }
// }

import 'package:payzo_books/data/repository/bills_api/bills_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';
import 'package:payzo_books/view/bill_screen/notifier/edit_bill_form_notifier.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_pagination_provider.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

import 'package:payzo_books/data/repository/bills_api/bill_actions_repository.dart';
import 'package:payzo_books/view/bill_detail_page/components/recurring_bill_modal.dart';
import 'package:payzo_books/view/bill_screen/edit_bill_screen.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';

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
              title4: AppText.recrngBill,
              title5: '',
              img1: AppImages.printIcon,
              img2: AppImages.editWhite,
              img3: AppImages.delete,
              img4: AppImages.invoicewhte,
              img5: '',
              isOnTap1Needed: true,
              isOnTap2Needed: true,
              isOnTap3Needed: true,
              isOnTap4Needed: true,
              isOnTap5Needed: false,
              onTap1: () {
                print("Message icon tapped, initiating download...");
                downloadBillPdf(ref, context, billDetail.billId);
              },
              onTap2: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProviderScope(
                      overrides: [
                        addBillFormProvider.overrideWith((ref) {
                          final repo = ref.read(billActionsRepositoryProvider);
                          return EditBillFormNotifier(repo);
                        }),
                      ],
                      child: EditBillScreen(billId: billDetail.billId),
                    ),
                  ),
                ).then((_) {
                  // Refresh details after edit
                  ref.refresh(getBillDetailsProvider(effectiveBillId));
                });
              },
              onTap3: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Bill'),
                    content: const Text(
                        'Are you sure you want to delete this bill?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Capture context-dependent objects
                          final navigator = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);

                          navigator.pop(); // Close confirmation dialog

                          showPayzoProgress(context: context);

                          try {
                            final repo =
                                ref.read(billActionsRepositoryProvider);
                            final success =
                                await repo.deleteBill(billDetail.billId);

                            navigator.pop(); // Close progress dialog

                            if (success) {
                              // Refresh list
                              await ref
                                  .read(billPaginationStateProvider.notifier)
                                  .refresh();
                              // ref.invalidate(getBillDataWithPagination);
                              // ref.invalidate(getBillData);

                              messenger.showSnackBar(
                                const SnackBar(
                                    content: Text('Bill deleted successfully')),
                              );

                              navigator.pop(); // Close BillDetailPage
                            } else {
                              messenger.showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to delete bill')),
                              );
                            }
                          } catch (e) {
                            navigator.pop(); // Close progress dialog
                            messenger.showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              onTap4: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: RecurringBillModal(billId: billDetail.billId),
                  ),
                );
              },
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
