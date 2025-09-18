import 'package:intl/intl.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';

class ExpensesItemWidget extends StatelessWidget {
  final int index;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String reference;
  final String vendorName;
  final double amount;
  final String currency;
  final String branch;
  final String date;
  final String status;

  const ExpensesItemWidget({
    Key? key,
    required this.index,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.reference,
    required this.vendorName,
    required this.amount,
    required this.currency,
    required this.branch,
    required this.date,
    required this.status,
  }) : super(key: key);

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      symbol: currency == 'SAR ' ? 'SAR ' : '$currency ',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFEEEEEE)),
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
                  // Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: vendorName,
                              color: const Color(0xFF212121),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 3),
                            ReusableText(
                              text: reference.isNotEmpty
                                  ? "Ref: $reference"
                                  : "Ref: -",
                              color: const Color(0xFF666666),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
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
                              text: date,
                              color: const Color(0xFF333333),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            const SizedBox(height: 3),
                            ReusableText(
                              text: branch,
                              color: const Color(0xFF333333),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: getStatusBackgroundColor(status),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ReusableText(
                          text: status,
                          color: getStatusColor(status),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ReusableText(
                        text: formatCurrency(amount),
                        color: const Color(0xFF212121),
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
