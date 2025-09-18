import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/data/models/customer_model/customer_model.dart';

Column customerDetailsContent(
    {
    // required int partyId,
    required String partyType,
    // required String transactionId,
    // required String currencyCode,
    required String customerType}) {
  return Column(
    children: [
      // textRowData(leftText: 'Customer Code', rightText: currencyCode),
      // textRowData(leftText: 'Customer type', rightText: customerType),
      textRowData(
        leftText: 'Customer type',
        rightText: customerType == "BUSINESS"
            ? "Business"
            : customerType == "INDIVIDUAL"
                ? "Individual"
                : customerType,
      ),
      // textRowData(leftText: AppText.partyId, rightText: '$partyId'),
      textRowData(leftText: AppText.partyType, rightText: partyType),
      // textRowData(leftText: AppText.transactionId, rightText: transactionId),
    ],
  );
}

Widget addressDetailWidget(Address address) {
  return Column(
    children: [
      textRowData(
        leftText: 'Street Address',
        rightText: address.streetAddress ?? 'N/A',
      ),
      textRowData(
        leftText: 'Building Number',
        rightText: address.buildingNumber,
      ),
      textRowData(
        leftText: 'City',
        rightText: address.city,
      ),
      textRowData(leftText: 'State', rightText: address.state),
      textRowData(
        leftText: 'Zipcode',
        rightText: address.zipCode,
      ),
      textRowData(leftText: 'Country Region', rightText: address.countryRegion),
    ],
  );
}
