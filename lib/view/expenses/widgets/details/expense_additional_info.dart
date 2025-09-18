import 'package:payzo_books/import_data.dart';

Widget expenseAdditionalInfo({
  required dynamic expenseDetail,
  required String customerNotes,
  required String termsAndConditions,
}) {
  return Container(
    padding: EdgeInsets.all(15),
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
          "Additional Information",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.loginTextColor,
          ),
        ),
        Divider(height: 16),
        if ((expenseDetail.customerNotes ?? '').trim().isNotEmpty) ...[
          Text(
            "Customer Notes:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.loginTextColor,
            ),
          ),
          GapSpace.height4,
          Text(
            customerNotes,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          GapSpace.height15,
        ],
        if ((expenseDetail.termsAndConditions ?? '').trim().isNotEmpty) ...[
          Text(
            "Terms & Conditions:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.loginTextColor,
            ),
          ),
          GapSpace.height4,
          Text(
            termsAndConditions,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ],
    ),
  );
}