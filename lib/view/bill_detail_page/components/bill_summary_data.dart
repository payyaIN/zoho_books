import 'package:payzo_books/import_data.dart';

Container billSummaryData({
  required String subTotal,
  required String discount,
  required String discountPercntage,
  required String taxAmount,
  required String total,
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
          "Bill Summary",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.loginTextColor,
          ),
        ),
        Divider(height: 16),
        rowText2(
          leftText: "Sub Total",
          rightText: subTotal,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: "Discount",
          rightText: discount,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: "Discount %",
          rightText: discountPercntage,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height8,
        rowText2(
          leftText: "Tax Amount",
          rightText: taxAmount,
          is60015: false,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        Divider(height: 16),
        rowText2(
          leftText: "Total",
          rightText: total,
          is60015: false,
          is70020: true,
          is70016: false,
          isQuantity: false,
        ),
      ],
    ),
  );
}
