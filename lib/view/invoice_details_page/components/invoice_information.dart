import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/approval_box.dart';

Container invoiceAndBillInformationWidget({
  required bool isBill,
  required String invoiceCreatedByName,
  required String invoiceCreatedBy,
  required String invoiceCustomerName,
  required String invoiceShippingType,
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
          isBill == true ? "Bill Information" : "Invoice Information",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.loginTextColor,
          ),
        ),
        Divider(height: 16),
        rowText2(
          leftText: "Created By",
          rightText: invoiceCreatedByName,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: "Email",
          rightText: invoiceCreatedBy,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: isBill == false ? "Customer" : "Vendor",
          rightText: invoiceCustomerName,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: "Shipping",
          rightText: invoiceShippingType,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
      ],
    ),
  );
}
