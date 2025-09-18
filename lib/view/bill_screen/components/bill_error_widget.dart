import 'package:payzo_books/view/bill_screen/provider/bill_pagination_provider.dart';

import '../../../import_data.dart';

Widget billErrorViewWidget(
    String errorMessage, BillPaginationNotifier notifier) {
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
          "Failed to load bills",
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
