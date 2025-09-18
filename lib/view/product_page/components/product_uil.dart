import 'package:intl/intl.dart';

class ProductUtil {
  static String formatCurrency(String amount) {
    if (amount == "-") return "SAR 0.00";

    String cleanAmount = amount.replaceAll(',', '');

    double? parsedAmount = double.tryParse(cleanAmount);
    if (parsedAmount == null) return "SAR 0.00";

    final formatter = NumberFormat.currency(
      symbol: 'SAR ',
      decimalDigits: 2,
    );
    return formatter.format(parsedAmount);
  }

  // static String getUsageType(int itemUsageType) {
  //   switch (itemUsageType) {
  //     case 1:
  //       return "Goods";
  //     case 2:
  //       return "Services";
  //     case 3:
  //       return "Both";
  //     default:
  //       return "Unknown";
  //   }
  // }
}
