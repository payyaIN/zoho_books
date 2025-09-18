import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';

Widget expensesErrorViewWidget(
    String errorMessage, ExpensesPaginationNotifier notifier) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 48,
          color: Colors.red.shade300,
        ),
        const SizedBox(height: 16),
        const Text(
          "Failed to load expenses",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => notifier.refresh(),
          child: const Text("Retry"),
        ),
      ],
    ),
  );
}
