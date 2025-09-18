import 'package:payzo_books/import_data.dart';

Container additionalInfo({
  required String invoiceCustomerNotes,
  required String invoiceTermsAndConditions,
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
        ReusableText(
          text: "Additional Information",
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.loginTextColor,
        ),
        Divider(height: 16),
        if (invoiceCustomerNotes.trim().isNotEmpty) ...[
          ReusableText(
            text: "Customer Notes:",
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.loginTextColor,
          ),
          GapSpace.height4,
          ReusableText(
            text: invoiceCustomerNotes,
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
          GapSpace.height15,
        ],
        if (invoiceTermsAndConditions.trim().isNotEmpty) ...[
          ReusableText(
            text: "Terms & Conditions:",
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.loginTextColor,
          ),
          GapSpace.height4,
          ReusableText(
            text: invoiceTermsAndConditions,
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ],
      ],
    ),
  );
}
