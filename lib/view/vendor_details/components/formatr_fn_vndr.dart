import 'package:payzo_books/data/models/vendor_model/vendor_model.dart';

String vendorFormatAddress(Address address) {
  final List<String> addressParts = [];

  if (address.streetAddress != null && address.streetAddress!.isNotEmpty) {
    addressParts.add(address.streetAddress!);
  }

  if (address.streetName != null && address.streetName!.isNotEmpty) {
    addressParts.add(address.streetName!);
  }

  addressParts.add('${address.buildingNumber}, ${address.city}');
  addressParts
      .add('${address.state}, ${address.countryName ?? address.countryRegion}');
  addressParts.add(address.zipCode);

  return addressParts.join('\n');
}
