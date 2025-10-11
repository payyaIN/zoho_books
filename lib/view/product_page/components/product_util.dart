// import 'package:intl/intl.dart';

// class ProductUtil {
//   static String formatCurrency(String amount) {
//     if (amount == "-") return "SAR 0.00";

//     String cleanAmount = amount.replaceAll(',', '');

//     double? parsedAmount = double.tryParse(cleanAmount);
//     if (parsedAmount == null) return "SAR 0.00";

//     final formatter = NumberFormat.currency(
//       symbol: 'SAR ',
//       decimalDigits: 2,
//     );
//     return formatter.format(parsedAmount);
//   }

//   // static String getUsageType(int itemUsageType) {
//   //   switch (itemUsageType) {
//   //     case 1:
//   //       return "Goods";
//   //     case 2:
//   //       return "Services";
//   //     case 3:
//   //       return "Both";
//   //     default:
//   //       return "Unknown";
//   //   }
//   // }
// }

import 'package:intl/intl.dart';

class ProductUtil {
  // ✅ FIXED: Changed parameter type from String to dynamic to handle both String and double
  static String formatCurrency(dynamic amount) {
    // Handle null or "-" cases
    if (amount == null || amount == "-") return "SAR 0.00";

    double parsedAmount;

    // ✅ NEW: Handle both String and numeric types
    if (amount is double) {
      parsedAmount = amount;
    } else if (amount is int) {
      parsedAmount = amount.toDouble();
    } else if (amount is String) {
      String cleanAmount = amount.replaceAll(',', '');
      parsedAmount = double.tryParse(cleanAmount) ?? 0.0;
    } else {
      return "SAR 0.00";
    }

    final formatter = NumberFormat.currency(
      symbol: 'SAR ',
      decimalDigits: 2,
    );
    return formatter.format(parsedAmount);
  }

  // Optional: Add a method to format without currency symbol
  static String formatNumber(dynamic amount, {int decimalDigits = 2}) {
    if (amount == null) return "0.00";

    double parsedAmount;

    if (amount is double) {
      parsedAmount = amount;
    } else if (amount is int) {
      parsedAmount = amount.toDouble();
    } else if (amount is String) {
      String cleanAmount = amount.replaceAll(',', '');
      parsedAmount = double.tryParse(cleanAmount) ?? 0.0;
    } else {
      return "0.00";
    }

    final formatter = NumberFormat.decimalPattern();
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(parsedAmount);
  }
}
