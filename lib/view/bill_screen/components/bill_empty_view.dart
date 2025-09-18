import 'package:payzo_books/import_data.dart';

Widget billEmptyView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 64,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 16),
        Text(
          "No Bills Available",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Add a new bill to get started",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}
