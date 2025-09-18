import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/parsed_date.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';
import 'package:payzo_books/view/invoice_screen/components/helper_widget.dart';
import 'package:payzo_books/view/invoice_screen/components/invoice_item_widget.dart';
import '../../../data/repository/invoice_api/invoice_detail_api.dart';

class PendingInvoices extends ConsumerWidget {
  const PendingInvoices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingInvoices = ref.watch(pendingInvoicesProvider);
    final asyncInvoiceData = ref.watch(getInvoiceData);
    final isLoading = asyncInvoiceData.isLoading;

    return ScalingFactor(
      child: Scaffold(
        appBar: reusableAppBar(
          title: 'Pending Invoice',
          showBackButton: true,
          context: context,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.appMainColor),
              )
            : pendingInvoices.isEmpty
                ? const Center(
                    child: Text(
                      'No Pending Invoices Found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: pendingInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = pendingInvoices[index];
                      final hasProducts = invoice.productDetails.isNotEmpty;
                      final firstProduct =
                          hasProducts ? invoice.productDetails[0] : null;

                      final productDesc =
                          hasProducts ? firstProduct!.productDescription : null;
                      final taxAmount =
                          invoice.invoiceTotalAmount - invoice.invoiceAmount;
                      final quantity = hasProducts ? firstProduct!.quantity : 0;
                      final unitPrice =
                          hasProducts ? firstProduct!.unitPrice : 0;

                      return InvoiceItemWidget(
                        index: index,
                        isSelectionMode: false,
                        isSelected: false,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.invoiceDetailsScreen,
                            arguments: invoice.invoiceId,
                          );
                        },
                        onLongPress: () {},
                        productName: hasProducts
                            ? firstProduct!.productName
                            : "No Product",
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
                        invoiceStatus: getBillAndInvoiceStatusText(invoice
                            .invoiceStatus), // invoice.isInvoiceverified),
                        isInvoiceverified: invoice.isInvoiceverified,
                      );
                    },
                  ),
        bottomNavigationBar: const SizedBox(height: 50),
      ),
    );
  }
}
