import 'package:payzo_books/data/models/get_item/get_item_model.dart';
import 'package:payzo_books/import_data.dart';

class ItemsNotifier extends StateNotifier<GetItemModel?> {
  ItemsNotifier() : super(null);

  void setItemsData(GetItemModel itemModel) {
    state = itemModel;
  }

  void clearItemsData() {
    state = null;
  }
}

final itemsProvider =
    StateNotifierProvider<ItemsNotifier, GetItemModel?>((ref) {
  return ItemsNotifier();
});

final selectedItemProvider = StateProvider<Item?>((ref) => null);

void setSelectedItem(WidgetRef ref, Item item) {
  ref.read(selectedItemProvider.notifier).state = item;
}

Item? getSelectedItem(WidgetRef ref) {
  return ref.read(selectedItemProvider);
}

final activeItemsProvider = Provider<List<Item>>((ref) {
  final itemModel = ref.watch(itemsProvider);
  if (itemModel == null) return [];

  return itemModel.data.where((item) => item.status == 1).toList();
});

final itemsByUsageTypeProvider =
    Provider.family<List<Item>, int>((ref, usageType) {
  final itemModel = ref.watch(itemsProvider);
  if (itemModel == null) return [];

  return itemModel.data
      .where((item) => item.status == 1 && item.itemUsageType == usageType)
      .toList();
});

final stockableItemsProvider = Provider<List<Item>>((ref) {
  final itemModel = ref.watch(itemsProvider);
  if (itemModel == null) return [];

  return itemModel.data
      .where((item) => item.status == 1 && item.stockable)
      .toList();
});

final itemByIdProvider = Provider.family<Item?, int>((ref, itemId) {
  final itemModel = ref.watch(itemsProvider);
  if (itemModel == null) return null;

  try {
    return itemModel.data.firstWhere((item) => item.itemId == itemId);
  } catch (e) {
    print('Item with ID $itemId not found');
    return null;
  }
});
