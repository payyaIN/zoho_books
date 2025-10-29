import '../../../../import_data.dart';

final customerTileExpandedProvider = StateProvider<bool>((ref) => true);
final billingTileExpandedProvider = StateProvider<bool>((ref) => false);
final shippingTileExpandedProvider = StateProvider<bool>((ref) => false);
final isThisTaxedOrganizationProvider = StateProvider<bool>((ref) => false);
final isThisCustomerGovernmentProvider = StateProvider<bool>((ref) => false);
final billingCountryLabelProvider = StateProvider<String>((ref) => '');
final shippingCountryLabelProvider = StateProvider<String>((ref) => '');
final billingStateLabelProvider = StateProvider<String>((ref) => '');
final shippingStateLabelProvider = StateProvider<String>((ref) => '');
