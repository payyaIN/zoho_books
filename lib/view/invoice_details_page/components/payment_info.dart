import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/approval_box.dart';

Container paymentInfo({
  required String invoiceBankAcc,
  required String invoicePaymentTerms,
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
          text: "Payment Information",
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.loginTextColor,
        ),
        Divider(height: 16),
        rowText2(
          leftText: "Bank Account",
          rightText: invoiceBankAcc,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: "Payment Terms",
          rightText: invoicePaymentTerms,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
      ],
    ),
  );
}
