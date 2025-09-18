import 'package:payzo_books/import_data.dart';

Widget financialCard({
  required String state,
  required String city,
  String? companyName,
  String? primaryContactName,
  String? phoneNumber,
  String? mobileCode,
  String? countryRegion,
  String? emailAddress,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.indigo.shade900,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: buildFinancialColumn(
                'Company',
                companyName ?? 'N/A',
              ),
            ),
            Expanded(
              child: buildFinancialColumn(
                'Contact Name',
                primaryContactName ?? 'N/A',
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: buildFinancialColumn(
                'Phone',
                '$mobileCode $phoneNumber' ?? 'N/A',
              ),
            ),
            Expanded(
              child: buildFinancialColumn(
                'Email',
                emailAddress ?? 'N/A',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildFinancialColumn(String title, String value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ReusableText(
        text: title,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColors.whiteShade,
      ),
      ReusableText(
        text: value,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: AppColors.whiteShade,
      ),
    ],
  );
}
