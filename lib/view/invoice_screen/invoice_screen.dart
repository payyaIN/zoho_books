import 'package:payzo_books/utils/app_data/parsed_date.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/invoice_screen/components/helper_widget.dart';
import 'package:payzo_books/view/invoice_screen/components/invoice_item_widget.dart';
import 'package:payzo_books/view/invoice_screen/provider/invoice_fn_provider.dart';
import 'package:payzo_books/view/invoice_screen/provider/invoice_notifier.dart';
import 'package:payzo_books/view/invoice_screen/provider/invoice_pagination_provider.dart';

import '../../import_data.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  const InvoiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  final TextEditingController invoiceSearchController = TextEditingController();

  void invoiceOnChange(String value) {
    print("Invoice search text changed: '$value'");
    ref.read(searchProvider.notifier).updateSearchQuery(value);

    ref.read(invoicePaginationStateProvider.notifier).setSearchQuery(value);
  }

  void invoiceOnClear() {
    print("Invoice search cleared");
    invoiceSearchController.clear();
    ref.read(searchProvider.notifier).clearSearch();

    ref.read(invoicePaginationStateProvider.notifier).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    final paginationState = ref.watch(invoicePaginationStateProvider);
    final paginationNotifier =
        ref.read(invoicePaginationStateProvider.notifier);

    final invoiceSelectionState = ref.watch(invoiceSelectionProvider);
    final invoiceSelectionNotifier =
        ref.read(invoiceSelectionProvider.notifier);

    print("Invoice Screen Build");
    print("- Current search query: '${paginationState.searchQuery}'");
    print("- Total invoices: ${paginationState.invoices.length}");
    print("- Filtered invoices: ${paginationState.filteredInvoices.length}");

    final scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.removeListener(() {});
        scrollController.addListener(() {
          if (scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent * 0.8 &&
              !paginationState.isLoading &&
              paginationState.hasNextPage &&
              paginationState.searchQuery.isEmpty) {
            paginationNotifier.loadMoreInvoices();
          }
        });
      }
    });

    return ScalingFactor(
      child: Scaffold(
        appBar: reusableAppBarWithSuffixWidget(
          context: context,
          showTitle: true,
          showBackButton: false,
          isSuffixText: true,
          title: AppText.invoices,
          suffixText: invoiceSelectionState.isSelectionMode
              ? AppText.cancel
              : AppText.select,
          onSuffixTap: () {
            invoiceSelectionNotifier.toggleSelectionMode();
          },
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(),
                BodyStatus(
                  controller: invoiceSearchController,
                  onChanged: invoiceOnChange,
                  onClear: invoiceOnClear,
                  hintText: 'Search by Invoice Number',
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      paginationNotifier.refresh();
                    },
                    child: paginationState.isLoading &&
                            paginationState.invoices.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.appMainColor,
                            ),
                          )
                        : paginationState.errorMessage != null &&
                                paginationState.invoices.isEmpty
                            ? _buildErrorView(paginationState.errorMessage!,
                                paginationNotifier)
                            : paginationState.invoices.isEmpty
                                ? _buildEmptyView()
                                : _buildInvoiceListView(
                                    paginationState,
                                    invoiceSelectionState,
                                    invoiceSelectionNotifier,
                                    scrollController,
                                    context),
                  ),
                ),
              ],
            ),
            invoiceSelectionState.isSelectionMode
                ? Positioned(
                    bottom: 0,
                    child: Container(
                      width: width,
                      height: 139,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-0.02, -1.00),
                          end: Alignment(0.02, 1),
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Transform.translate(
                        offset: Offset(-10, 30),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 10, right: 10),
                          child: PayzoFormSubmitTwoButtons(
                              cancelText: AppText.cancel,
                              saveText: AppText.approve,
                              cancelOnPressed:
                                  invoiceSelectionNotifier.resetSelection,
                              saveOnPressed: () {
                                final selectedIndices = invoiceSelectionNotifier
                                    .getSelectedIndices();
                                print(
                                    'Approving invoices at indices: $selectedIndices');
                              }),
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
        floatingActionButton: invoiceSelectionState.isSelectionMode
            ? Transform.translate(
                offset: Offset(0, -85),
                child: floatingActionBtn(
                  onPress: () {
                    Navigator.pushNamed(context, RouteNames.addInvoice);
                  },
                ))
            : floatingActionBtn(
                onPress: () {
                  Navigator.pushNamed(context, RouteNames.addInvoice);
                },
              ),
      ),
    );
  }

  Widget _buildErrorView(
      String errorMessage, InvoicePaginationNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red.shade300,
          ),
          SizedBox(height: 16),
          Text(
            "Failed to load invoices",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => notifier.refresh(),
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            "No Invoices Available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add a new invoice to get started",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceListView(
      InvoicePaginationState paginationState,
      InvoiceSelectionState selectionState,
      InvoiceSelectionNotifier selectionNotifier,
      ScrollController scrollController,
      BuildContext context) {
    final invoices = paginationState.searchQuery.isNotEmpty
        ? paginationState.filteredInvoices
        : paginationState.invoices;

    if (paginationState.searchQuery.isNotEmpty && invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              "No invoices match your search",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Try a different search term",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: invoices.length +
          (paginationState.hasNextPage && paginationState.searchQuery.isEmpty
              ? 1
              : 0),
      itemBuilder: (context, index) {
        if (index == invoices.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                color: AppColors.appMainColor,
              ),
            ),
          );
        }

        final invoice = invoices[index];

        final hasProducts = invoice.productDetails.isNotEmpty;
        final firstProduct = hasProducts ? invoice.productDetails[0] : null;

        final productDesc =
            hasProducts ? firstProduct!.productDescription : null;

        final taxAmount = invoice.invoiceTotalAmount - invoice.invoiceAmount;

        final quantity = hasProducts ? firstProduct!.quantity : 0;
        final unitPrice = hasProducts ? firstProduct!.unitPrice : 0;

        return InvoiceItemWidget(
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
                  builder: (context) => InvoiceDetailPage(
                    invoiceId: invoice.invoiceId,
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
          invoiceAmount: invoice.invoiceAmount,
          taxAmount: taxAmount,
          totalAmount: invoice.invoiceTotalAmount,
          issueDate: formatDate("${invoice.invoiceCreatedDate}"),
          invoiceNumber: invoice.invoiceNumber,
          currency: invoice.invoiceCurrency,
          customerName: invoice.invoiceCustomerName,
          branchName: invoice.invoiceBranchName,
          invoiceStatus: getBillAndInvoiceStatusText(
              invoice.invoiceStatus), //, invoice.isInvoiceverified),
          isInvoiceverified: invoice.isInvoiceverified,
        );
      },
    );
  }
}
