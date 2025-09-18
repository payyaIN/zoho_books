import 'package:payzo_books/data/models/customer_model/customer_model.dart';

String customerAddressFunction(Address address) {
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
