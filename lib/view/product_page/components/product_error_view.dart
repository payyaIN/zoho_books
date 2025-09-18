import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';

Widget productErrorView(
    String errorMessage, ProductPaginationNotifier notifier) {
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
          "Failed to load products",
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
