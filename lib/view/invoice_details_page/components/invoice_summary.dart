import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/approval_box.dart';
import 'package:payzo_books/view/invoice_details_page/components/helper_widget.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

Container invoiceSummary({
  required double invoiceAmount,
  required String invoiceCurrency,
  required double invoiceTotalAmount,
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
          text: "Invoice Summary",
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.loginTextColor,
        ),
        Divider(height: 16),
        rowText2(
          leftText: "Sub Total",
          rightText: formatCurrency(invoiceAmount, invoiceCurrency),
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: "Standard Rate(%)",
          rightText: formatCurrency(
              invoiceTotalAmount - invoiceAmount, invoiceCurrency),
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: "Tax Amount",
          rightText: formatCurrency(
              invoiceTotalAmount - invoiceAmount, invoiceCurrency),
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        Divider(height: 16),
        rowText2(
          leftText: "Total",
          rightText: formatCurrency(invoiceTotalAmount, invoiceCurrency),
          is60015: false,
          is70020: true,
          is70016: false,
          isQuantity: false,
        ),
      ],
    ),
  );
}
