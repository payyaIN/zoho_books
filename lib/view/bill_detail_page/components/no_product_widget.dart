import 'package:payzo_books/import_data.dart';

Center noProductDataAvail() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "No product details available",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    ),
  );
}
