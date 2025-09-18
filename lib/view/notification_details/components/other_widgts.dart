import 'package:intl/intl.dart';
import 'package:payzo_books/import_data.dart';

bool shouldShowOnlyPrintButton(int? isVerified) {
  return isVerified == 1 || isVerified == 2;
}

// String formatCurrency(double amount, String currency) {
//   final formatter = NumberFormat.currency(
//     symbol: currency == 'SAR ' ? 'SAR ' : '$currency ',
//     decimalDigits: 2,
//   );
//   return formatter.format(amount);
// }
String formatCurrency(double amount, String currency) {
  if (currency.trim() == 'SAR') {
    return 'SAR ${amount.toStringAsFixed(2)}';
  }

  try {
    final formatter = NumberFormat.currency(
      symbol: '$currency ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  } catch (e) {
    return '$currency ${amount.toStringAsFixed(2)}';
  }
}

Widget buildErrorView({
  required Object error,
  required String errorMessage,
  required VoidCallback onRetry,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 48, color: Colors.red),
        SizedBox(height: 16),
        Text(
          errorMessage,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(error.toString(), textAlign: TextAlign.center),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: onRetry,
          child: Text("Retry"),
        ),
      ],
    ),
  );
}

Widget actionButton(IconData icon, String label,
    {required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        ReusableContainer(
          height: 45,
          width: 45,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.appMainColor,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        ReusableText(
          text: label,
          color: AppColors.appMainColor,
        ),
      ],
    ),
  );
}

Widget buildNotificationMessageBox(NotificationData notification) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notification",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.loginTextColor,
            ),
          ),
          Divider(height: 16),
          Text(
            notification.message!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            notification.timeAgo ?? notification.createdOn ?? "Recently",
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    ),
  );
}
