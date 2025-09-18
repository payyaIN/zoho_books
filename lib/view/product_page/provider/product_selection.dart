import 'package:payzo_books/data/models/product_model/product_detail_model.dart';
import 'package:payzo_books/data/models/product_model/product_list_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/data/repository/products_api/product_list_api.dart';

class ProductSelectionState {
  final bool isSelectionMode;
  final List<bool> selectedItems;

  ProductSelectionState({
    this.isSelectionMode = false,
    List<bool>? selectedItems,
  }) : selectedItems = selectedItems ?? List.filled(7, false);

  ProductSelectionState copyWith({
    bool? isSelectionMode,
    List<bool>? selectedItems,
  }) {
    return ProductSelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}

class ProductSelectionNotifier extends StateNotifier<ProductSelectionState> {
  ProductSelectionNotifier() : super(ProductSelectionState());

  void toggleSelectionMode() {
    state = state.copyWith(
      isSelectionMode: !state.isSelectionMode,
      selectedItems: state.isSelectionMode
          ? List.filled(state.selectedItems.length, false)
          : state.selectedItems,
    );
  }

  void toggleItemSelection(int index) {
    if (index >= state.selectedItems.length) {
      final updatedList = List<bool>.from(state.selectedItems);
      while (updatedList.length <= index) {
        updatedList.add(false);
      }
      state = state.copyWith(selectedItems: updatedList);
    }

    final updatedSelectedItems = List<bool>.from(state.selectedItems);
    updatedSelectedItems[index] = !updatedSelectedItems[index];

    state = state.copyWith(
      selectedItems: updatedSelectedItems,
      isSelectionMode: true,
    );
  }

  void updateSelectionSize(int size) {
    if (state.selectedItems.length != size) {
      state = state.copyWith(
        selectedItems: List.filled(size, false),
      );
    }
  }

  void resetSelection() {
    state = state.copyWith(
      isSelectionMode: false,
      selectedItems: List.filled(state.selectedItems.length, false),
    );
  }

  List<int> getSelectedIndices() {
    return List.generate(state.selectedItems.length,
            (index) => state.selectedItems[index] ? index : -1)
        .where((index) => index != -1)
        .toList();
  }
}

final productSelectionProvider =
    StateNotifierProvider<ProductSelectionNotifier, ProductSelectionState>(
        (ref) {
  return ProductSelectionNotifier();
});

class ProductDetailsNotifier extends StateNotifier<ProductModel?> {
  ProductDetailsNotifier() : super(null);

  void selectProduct(ProductModel productModel) {
    state = productModel;
  }

  void clearSelection() {
    state = null;
  }
}

final productSelectionDataProvider =
    StateNotifierProvider<ProductDetailsNotifier, ProductModel?>((ref) {
  return ProductDetailsNotifier();
});

final selectedProductDetailProvider =
    StateProvider<ProductDetailModel?>((ref) => null);

void setSelectedProductDetail(WidgetRef ref, ProductDetailModel productDetail) {
  ref.read(selectedProductDetailProvider.notifier).state = productDetail;
}

ProductDetailModel? getSelectedProductDetail(WidgetRef ref) {
  return ref.read(selectedProductDetailProvider);
}

final specificProductProvider =
    Provider.family<ProductData?, ProductModel?>((ref, model) {
  if (model == null || model.response.data.isEmpty) {
    return null;
  }

  return model.response.data[0];
});

final selectedProductIdProvider = StateProvider<int?>((ref) => null);

final selectedProductProvider = Provider<ProductData?>((ref) {
  final productId = ref.watch(selectedProductIdProvider);
  if (productId == null) return null;

  final productModel = ref.watch(getProductData);
  return productModel.value?.response.data.firstWhere(
    (product) => product.itemId == productId,
    orElse: () => ProductData.empty(),
  );
});
