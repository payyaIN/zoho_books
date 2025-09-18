import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/customer_screen/provider/customer_pagination_provider.dart';

Widget customerErrorView(String errorMessage, WidgetRef ref) {
  Future<void> refreshCustomer() async {
    ref.read(customerPaginationStateProvider.notifier).refresh();
  }

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
        Text(
          "Error loading customers:",
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
          onPressed: refreshCustomer,
          child: const Text("Retry"),
        )
      ],
    ),
  );
}
