import '../../../../import_data.dart';

final customerTileExpandedProvider = StateProvider<bool>((ref) => true);
final billingTileExpandedProvider = StateProvider<bool>((ref) => false);
final shippingTileExpandedProvider = StateProvider<bool>((ref) => false);