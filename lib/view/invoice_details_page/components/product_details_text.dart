import 'package:payzo_books/import_data.dart';

Container productDetailsHeaderText() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
    ),
    child: Text(
      "Product Details",
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: AppColors.loginTextColor,
      ),
    ),
  );
}
