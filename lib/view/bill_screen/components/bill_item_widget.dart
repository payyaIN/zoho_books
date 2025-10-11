import 'package:payzo_books/import_data.dart';
import 'package:intl/intl.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';

class BillItemWidget extends StatelessWidget {
  final int index;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String? productName;
  final String? productDescription;
  final double quantity;
  final double unitPrice;
  final double billAmount;
  final double taxAmount;
  final double totalAmount;
  final String issueDate;
  final String billInvoiceNumber;
  final String currency;
  final String vendorName;
  final String branchName;
  final int? isBillVerified;
  final String billStatus;

  const BillItemWidget({
    Key? key,
    required this.index,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.productName,
    this.productDescription,
    required this.quantity,
    required this.unitPrice,
    required this.billAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.issueDate,
    required this.billInvoiceNumber,
    required this.currency,
    required this.vendorName,
    required this.branchName,
    required this.isBillVerified,
    required this.billStatus,
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
                              text: productName ?? "No Product",
                              color: Color(0xFF212121),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 3),
                            if (productDescription != null &&
                                productDescription!.isNotEmpty)
                              ReusableText(
                                text: truncateText(productDescription, 25),
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
                            billInvoiceNumber == null ||
                                    billInvoiceNumber.isEmpty
                                ? ReusableText(
                                    text: "Bill Invoice No: -",
                                    color: Color(0xFF333333),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  )
                                : ReusableText(
                                    text:
                                        "Bill Invoice No: ${billInvoiceNumber}",
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
                              text: vendorName,
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
                                  text: "Unit Price: $currency $unitPrice",
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
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     ReusableText(
                      //       text: branchName,
                      //       color: Color(0xFF333333),
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //     SizedBox(height: 5),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 8, vertical: 2),
                      //       decoration: BoxDecoration(
                      //         color: billStatus == AppText.pending
                      //             ? Colors.red.withOpacity(0.1)
                      //             : billStatus == AppText.open
                      //                 ? Colors.green.withOpacity(0.1)
                      //                 : billStatus == AppText.paid
                      //                     ? Colors.blue.withOpacity(0.1)
                      //                     : Colors.grey.withOpacity(0.1),
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: ReusableText(
                      //         text: billStatus,
                      //         color: billStatus == AppText.pending
                      //             ? Colors.red
                      //             : billStatus == AppText.open
                      //                 ? Colors.green
                      //                 : billStatus == AppText.paid
                      //                     ? Colors.blue
                      //                     : Colors.grey,
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ReusableText(
                            text: branchName,
                            color: Color(0xFF333333),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: getStatusBackgroundColor(billStatus),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ReusableText(
                              text: billStatus,
                              color: getStatusColor(billStatus),
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
                            text: "Amount: ${formatCurrency(billAmount)}",
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
}
