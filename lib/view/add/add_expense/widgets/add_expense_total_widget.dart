import 'package:payzo_books/import_data.dart';

class AddExpenseTotal extends ConsumerWidget {
  const AddExpenseTotal({
    super.key,
    required this.taxType,
    required this.taxTypeText,
    required this.subTotal,
    required this.total,
  });

  final String taxTypeText;
  final String taxType;
  final String subTotal;
  final String total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScalingFactor(
      child: Align(
        alignment: Alignment.centerRight,
        child: ReusableColumn(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _buildAmountRow('Sub Total', subTotal,isBold: true),
            _buildAmountRow(taxTypeText, taxType,isBold: true),
            const PayzoDivider(),
            _buildAmountRow('Total', total, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: ReusableText(
                text: label,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color.fromRGBO(51, 51, 51, 1),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ReusableText(
            text: value,
            fontFamily: 'SF Pro Display',
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(51, 51, 51, 1),
          ),
        ],
      ),
    );
  }
}
