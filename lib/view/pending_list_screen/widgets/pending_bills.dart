import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/parsed_date.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';
import 'package:payzo_books/view/bill_screen/components/bill_item_widget.dart';
import 'package:payzo_books/data/repository/bills_api/bills_api.dart';
import 'package:payzo_books/view/invoice_screen/components/helper_widget.dart';

class PendingBills extends ConsumerWidget {
  const PendingBills({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBillData = ref.watch(getBillData);

    final pendingBills = asyncBillData.maybeWhen(
      data: (data) =>
          data.billData
              ?.where((e) => e.billStatus == 1 && e.isBillVerified == 0)
              .toList() ??
          [],
      orElse: () => [],
    );

    final isLoading = asyncBillData.isLoading;

    return ScalingFactor(
      child: Scaffold(
        appBar: reusableAppBar(
            title: 'Pending Bills', showBackButton: true, context: context),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.appMainColor),
              )
            : pendingBills.isEmpty
                ? _buildEmptyView()
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: pendingBills.length,
                    itemBuilder: (context, index) {
                      final bill = pendingBills[index];
                      final hasProducts = bill.productDetails.isNotEmpty;
                      final firstProduct =
                          hasProducts ? bill.productDetails[0] : null;

                      final productDesc =
                          hasProducts ? firstProduct!.productDesc : null;
                      final taxAmount = bill.billTotalAmount - bill.billAmount;
                      final quantity = hasProducts ? firstProduct!.quantity : 0;
                      final unitPrice =
                          hasProducts ? firstProduct!.unitPrice : 0;

                      return BillItemWidget(
                        index: index,
                        isSelectionMode: false,
                        isSelected: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillDetailPage(
                                billId: bill.billId,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {},
                        productName: hasProducts
                            ? firstProduct!.productName
                            : "No Product",
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
                        billStatus: getBillAndInvoiceStatusText(
                            bill.billStatus), //, bill.isBillVerified),
                        isBillVerified: bill.isBillVerified,
                      );
                    },
                  ),
        bottomNavigationBar: ReusableSizedBox(
          height: 50,
        ),
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
          const SizedBox(height: 16),
          Text(
            "No Pending Bills Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
