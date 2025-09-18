import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/product_model/product_list_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';

class ProductSearchState {
  final String query;
  final bool isSearching;

  ProductSearchState({
    required this.query,
    required this.isSearching,
  });

  factory ProductSearchState.initial() {
    return ProductSearchState(
      query: '',
      isSearching: false,
    );
  }

  ProductSearchState copyWith({
    String? query,
    bool? isSearching,
  }) {
    return ProductSearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class ProductSearchNotifier extends StateNotifier<ProductSearchState> {
  ProductSearchNotifier() : super(ProductSearchState.initial());

  void updateSearchQuery(String query) {
    state = state.copyWith(
      query: query,
      isSearching: query.isNotEmpty,
    );
  }

  void clearSearch() {
    state = state.copyWith(
      query: '',
      isSearching: false,
    );
  }
}

final productSearchProvider =
    StateNotifierProvider<ProductSearchNotifier, ProductSearchState>((ref) {
  return ProductSearchNotifier();
});

final productFocusNodeProvider = Provider<FocusNode>((ref) {
  final focusNode = FocusNode();
  ref.onDispose(() {
    focusNode.dispose();
  });
  return focusNode;
});

final productTextControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

final filteredProductsProvider = Provider<List<ProductData>>((ref) {
  final searchState = ref.watch(productSearchProvider);
  final paginationState = ref.watch(productPaginationStateProvider);
  final products = paginationState.products;

  if (searchState.query.isEmpty) {
    return products;
  }

  final query = searchState.query.toLowerCase();

  return products.where((product) {
    if (product.itemName.toLowerCase().contains(query)) {
      return true;
    }

    if (product.salesDescription.toLowerCase().contains(query) ||
        product.costDescription.toLowerCase().contains(query)) {
      return true;
    }

    if (product.hsnOrSac.toLowerCase().contains(query)) {
      return true;
    }

    if (product.salesAccountName.toLowerCase().contains(query) ||
        product.costAccountName.toLowerCase().contains(query)) {
      return true;
    }

    return false;
  }).toList();
});
