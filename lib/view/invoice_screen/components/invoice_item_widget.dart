import 'package:payzo_books/import_data.dart';
import 'package:intl/intl.dart';

class InvoiceItemWidget extends StatelessWidget {
  final int index;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String? productName;
  final String? productDescription;
  final double quantity;
  final double unitPrice;
  final double invoiceAmount;
  final double taxAmount;
  final double totalAmount;
  final String issueDate;
  final String invoiceNumber;
  final String currency;
  final String customerName;
  final String branchName;
  final int? isInvoiceverified;
  final String invoiceStatus;

  const InvoiceItemWidget({
    Key? key,
    required this.index,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    this.productName,
    this.productDescription,
    required this.quantity,
    required this.unitPrice,
    required this.invoiceAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.issueDate,
    required this.invoiceNumber,
    required this.currency,
    required this.customerName,
    required this.branchName,
    required this.isInvoiceverified,
    required this.invoiceStatus,
  }) : super(key: key);

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: currency == 'SAR ' ? 'SAR ' : '$currency ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String truncateText(String? text, int maxLength) {
    if (text == null || text.isEmpty) return "N/A";
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            if (isSelectionMode)
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                checkColor: AppColors.appWhiteColor,
                activeColor: AppColors.appMainColor,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: customerName,
                              color: Color(0xFF212121),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 3),
                            if (productName != null && productName!.isNotEmpty)
                              ReusableText(
                                text: truncateText(productName, 25),
                                color: Color(0xFF666666),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ReusableText(
                              text: issueDate,
                              color: Color(0xFF333333),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 3),
                            ReusableText(
                              text: "$invoiceNumber",
                              color: Color(0xFF333333),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: branchName,
                              color: Color(0xFF333333),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                ReusableText(
                                  text: "Qty: ${quantity.toStringAsFixed(0)}",
                                  color: Color(0xFF555555),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                SizedBox(width: 8),
                                ReusableText(
                                  text: "Unit: ${formatCurrency(unitPrice)}",
                                  color: Color(0xFF555555),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // ReusableText(
                          //   text: branchName,
                          //   color: Color(0xFF333333),
                          //   fontSize: 13,
                          //   fontWeight: FontWeight.w400,
                          // ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: getStatusColor(invoiceStatus)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ReusableText(
                              text: invoiceStatus,
                              color: getStatusColor(invoiceStatus),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(height: 1, thickness: 0.5),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Amount: ${formatCurrency(invoiceAmount)}",
                            color: Color(0xFF555555),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(height: 3),
                          ReusableText(
                            text: "Tax: ${formatCurrency(taxAmount)}",
                            color: Color(0xFF555555),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      ReusableText(
                        text: formatCurrency(totalAmount),
                        color: Color(0xFF212121),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    if (status == AppText.pending) {
      return Colors.red;
    } else if (status == AppText.open) {
      return Colors.green;
    } else if (status == AppText.paid) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}
