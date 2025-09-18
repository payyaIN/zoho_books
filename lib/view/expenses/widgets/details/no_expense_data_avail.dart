import 'package:payzo_books/import_data.dart';

Center noExpenseDataAvail() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "No expense details available",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    ),
  );
}
