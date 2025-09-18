import 'package:payzo_books/data/models/vendor_model/vendor_model.dart';
import 'package:payzo_books/import_data.dart';

Column vendorDetailsContent(
    {required int partyId,
    required String partyType,
    required String transactionId,
    required String currencyCode,
    required String customerType}) {
  return Column(
    children: [
      textRowData(leftText: 'Customer Code', rightText: currencyCode),
      textRowData(leftText: 'Customer type', rightText: customerType),
      textRowData(leftText: AppText.partyId, rightText: '$partyId'),
      textRowData(leftText: AppText.partyType, rightText: partyType),
      textRowData(leftText: AppText.transactionId, rightText: transactionId),
    ],
  );
}

Widget addressDetailWidget(Address address) {
  return Column(
    children: [
      textRowData(leftText: 'Country Region', rightText: address.countryRegion),
      textRowData(leftText: 'State', rightText: address.state),
      textRowData(
        leftText: 'City',
        rightText: address.city,
      ),
      textRowData(
        leftText: 'Zipcode',
        rightText: address.zipCode,
      ),
      textRowData(
        leftText: 'Building Number',
        rightText: address.buildingNumber,
      ),
      textRowData(
        leftText: 'Street Address',
        rightText: address.streetAddress ?? 'N/A',
      ),
    ],
  );
}
