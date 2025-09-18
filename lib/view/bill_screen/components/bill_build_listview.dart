import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/parsed_date.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';
import 'package:payzo_books/view/bill_screen/components/bill_item_widget.dart';
import 'package:payzo_books/view/bill_screen/components/bill_search_not_found.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_fn_provider.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_notifier.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_pagination_provider.dart';
import 'package:payzo_books/view/invoice_screen/components/helper_widget.dart';

Widget billBuildListView({
  required BuildContext context,
  required WidgetRef ref,
  required BillPaginationState paginationState,
  required BillSelectionState selectionState,
  required BillSelectionNotifier selectionNotifier,
  required ScrollController scrollController,
}) {
  final bills = paginationState.searchQuery.isNotEmpty
      ? paginationState.filteredBills
      : paginationState.bills;

  if (paginationState.searchQuery.isNotEmpty && bills.isEmpty) {
    return billSearchNotFound();
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (scrollController.hasClients) {
      scrollController.removeListener(() {});

      scrollController.addListener(() {
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;

        final threshold = maxScroll * 0.8;

        print(
            'Scroll position: $currentScroll / $maxScroll (threshold: $threshold)');
        print(
            'IsLoading: ${paginationState.isLoading}, HasNextPage: ${paginationState.hasNextPage}');

        if (currentScroll >= threshold &&
            !paginationState.isLoading &&
            paginationState.hasNextPage) {
          print(' LOAD MORE TRIGGERED at position: $currentScroll');

          ref.read(billPaginationStateProvider.notifier).loadMoreBills();
        }
      });
    } else {
      print('Warning: Scroll controller has no clients');
    }
  });

  return NotificationListener<ScrollNotification>(
    onNotification: (ScrollNotification notification) {
      if (notification is ScrollEndNotification) {
        if (scrollController.position.extentAfter < 500 &&
            !paginationState.isLoading &&
            paginationState.hasNextPage) {
          print('LOAD MORE TRIGGERED via notification');
          ref.read(billPaginationStateProvider.notifier).loadMoreBills();
        }
      }
      return false;
    },
    child: ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: bills.length + (paginationState.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == bills.length) {
          print('Rendering loading indicator at the end of the list');
          return Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: AppColors.appMainColor,
                ),
              ],
            ),
          );
        }

        final bill = bills[index];
        final hasProducts = bill.productDetails.isNotEmpty;
        final firstProduct = hasProducts ? bill.productDetails[0] : null;
        final productDesc = hasProducts ? firstProduct!.productDesc : null;
        final taxAmount = bill.billTotalAmount - bill.billAmount;
        final quantity = hasProducts ? firstProduct!.quantity : 0;
        final unitPrice = hasProducts ? firstProduct!.unitPrice : 0;

        String statusText = getBillAndInvoiceStatusText(
            bill.billStatus); // bill.isBillVerified);

        if (index % 5 == 0) {
          print(
              'Rendering bill at index $index: ID ${bill.billId}, Invoice ${bill.billInvoiceNumber}');
        }

        return BillItemWidget(
          index: index,
          isSelectionMode: selectionState.isSelectionMode,
          isSelected: index < selectionState.selectedItems.length
              ? selectionState.selectedItems[index]
              : false,
          onTap: () {
            if (selectionState.isSelectionMode) {
              selectionNotifier.toggleItemSelection(index);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillDetailPage(
                    billId: bill.billId,
                  ),
                ),
              );
            }
          },
          onLongPress: () {
            selectionNotifier.toggleSelectionMode();
            selectionNotifier.toggleItemSelection(index);
          },
          productName: hasProducts ? firstProduct!.productName : "No Product",
          productDescription: truncateTextFn(productDesc, 30),
          quantity: quantity.toDouble(),
          unitPrice: unitPrice.toDouble(),
          billAmount: bill.billAmount,
          taxAmount: taxAmount,
          totalAmount: bill.billTotalAmount,
          issueDate: formatDate("${bill.billCreatedDate}"),
          billInvoiceNumber: bill.billInvoiceNumber,
          currency: bill.billCurrency,
          vendorName: bill.billVenderName,
          branchName: bill.billBranchName,
          billStatus: statusText,
          // getBillAndInvoiceStatusText(bill.billStatus, bill.isBillVerified),
          isBillVerified: bill.isBillVerified,
        );
      },
    ),
  );
}
