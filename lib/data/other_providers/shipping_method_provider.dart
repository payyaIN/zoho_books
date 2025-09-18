import 'package:payzo_books/data/models/shipping_model/shipping_model.dart';
import 'package:payzo_books/import_data.dart';

class ShippingMethodNotifier extends StateNotifier<ShippingMethodModel?> {
  ShippingMethodNotifier() : super(null);

  void setShippingMethodData(ShippingMethodModel shippingModel) {
    state = shippingModel;
  }

  void clearShippingMethodData() {
    state = null;
  }
}

final shippingMethodProvider =
    StateNotifierProvider<ShippingMethodNotifier, ShippingMethodModel?>((ref) {
  return ShippingMethodNotifier();
});

final selectedShippingMethodProvider =
    StateProvider<ShippingMethod?>((ref) => null);

void setSelectedShippingMethod(WidgetRef ref, ShippingMethod method) {
  ref.read(selectedShippingMethodProvider.notifier).state = method;
}

ShippingMethod? getSelectedShippingMethod(WidgetRef ref) {
  return ref.read(selectedShippingMethodProvider);
}

final activeShippingMethodsProvider = Provider<List<ShippingMethod>>((ref) {
  final shippingModel = ref.watch(shippingMethodProvider);
  if (shippingModel == null) return [];

  return shippingModel.methods
      .where((method) => method.shpmIsActive == 't')
      .toList();
});

final shippingMethodByIdProvider =
    Provider.family<ShippingMethod?, int>((ref, methodId) {
  final shippingModel = ref.watch(shippingMethodProvider);
  if (shippingModel == null) return null;

  try {
    return shippingModel.methods
        .firstWhere((method) => method.shpmId == methodId);
  } catch (e) {
    print('Shipping method with ID $methodId not found');
    return null;
  }
});
