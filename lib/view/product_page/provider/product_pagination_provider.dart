import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/product_model/product_list_model.dart';
import 'package:payzo_books/data/repository/products_api/product_list_api.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';
import 'dart:developer' as developer;

import '../../../import_data.dart';

final productPaginationStateProvider =
    StateNotifierProvider<ProductPaginationNotifier, ProductPaginationState>(
        (ref) {
  return ProductPaginationNotifier(ref);
});

class ProductPaginationState {
  final int currentPage;
  final List<ProductData> products;
  final bool isLoading;
  final bool hasNextPage;
  final String? errorMessage;
  final String searchQuery;
  final bool isSearching;
  final int totalCount;

  ProductPaginationState({
    this.currentPage = 0,
    this.products = const [],
    this.isLoading = false,
    this.hasNextPage = true,
    this.errorMessage,
    this.searchQuery = '',
    this.isSearching = false,
    this.totalCount = 0,
  });

  ProductPaginationState copyWith({
    int? currentPage,
    List<ProductData>? products,
    bool? isLoading,
    bool? hasNextPage,
    String? errorMessage,
    String? searchQuery,
    bool? isSearching,
    int? totalCount,
  }) {
    return ProductPaginationState(
      currentPage: currentPage ?? this.currentPage,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  List<ProductData> get filteredProducts {
    if (searchQuery.isEmpty) return products;

    final query = searchQuery.toLowerCase();

    return products.where((product) {
      return product.itemName.toLowerCase().contains(query);
    }).toList();
  }
}

class ProductPaginationNotifier extends StateNotifier<ProductPaginationState> {
  final Ref _ref;
  static const int _pageSize = 15;
  bool _isLoadingMore = false;

  ProductPaginationNotifier(this._ref) : super(ProductPaginationState()) {
    fetchProducts();
  }

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // ✅ Invalidate cache if force refresh requested
      if (forceRefresh) {
        _ref.invalidate(getProductDataWithPagination);
      }

      final params = ProductPaginationParams(pageNo: 0, rowsPerPage: _pageSize);

      developer.log('FETCHING INITIAL PRODUCTS - Page 0',
          name: 'ProductPagination');

      final result =
          await _ref.read(getProductDataWithPagination(params).future);

      final products = result.response.data;
      final totalCount = result.response.totalRecord;

      developer.log('RECEIVED ${products.length} PRODUCTS (Total: $totalCount)',
          name: 'ProductPagination');

      state = state.copyWith(
        products: products,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: products.length < totalCount,
        isLoading: false,
      );

      if (products.isNotEmpty) {
        _ref
            .read(productSelectionProvider.notifier)
            .updateSelectionSize(products.length);
      }
    } catch (error) {
      developer.log('ERROR FETCHING PRODUCTS: $error',
          name: 'ProductPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore ||
        state.isLoading ||
        !state.hasNextPage ||
        state.searchQuery.isNotEmpty) {
      return;
    }

    if (state.products.length >= state.totalCount) {
      state = state.copyWith(hasNextPage: false);
      return;
    }

    _isLoadingMore = true;
    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;

      developer.log('LOADING MORE PRODUCTS - Page $nextPage',
          name: 'ProductPagination');
      developer.log(
          'Current state: ${state.products.length} products, ${state.totalCount} total',
          name: 'ProductPagination');

      final params =
          ProductPaginationParams(pageNo: nextPage, rowsPerPage: _pageSize);

      final result =
          await _ref.read(getProductDataWithPagination(params).future);

      final newProducts = result.response.data;
      final totalCount = result.response.totalRecord;

      developer.log('RECEIVED ${newProducts.length} MORE PRODUCTS',
          name: 'ProductPagination');

      if (newProducts.isEmpty) {
        state = state.copyWith(
          hasNextPage: false,
          isLoading: false,
        );
        _isLoadingMore = false;
        return;
      }

      final Set<int> existingIds =
          state.products.map((product) => product.itemId).toSet();
      final List<ProductData> allProducts = [...state.products];
      int addedCount = 0;

      for (var newProduct in newProducts) {
        if (!existingIds.contains(newProduct.itemId)) {
          allProducts.add(newProduct);
          existingIds.add(newProduct.itemId);
          addedCount++;
        }
      }

      final hasMore = allProducts.length < totalCount;

      state = state.copyWith(
        products: allProducts,
        currentPage: nextPage,
        totalCount: totalCount,
        hasNextPage: hasMore,
        isLoading: false,
      );

      _ref
          .read(productSelectionProvider.notifier)
          .updateSelectionSize(allProducts.length);

      developer.log(
          'ADDED $addedCount NEW PRODUCTS. Has more: $hasMore. Total: ${allProducts.length}/$totalCount',
          name: 'ProductPagination');
    } catch (error) {
      developer.log('ERROR LOADING MORE PRODUCTS: $error',
          name: 'ProductPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> setSearchQuery(String query) async {
    developer.log('SETTING SEARCH QUERY: "$query"', name: 'ProductPagination');

    if (query.isEmpty) {
      state = state.copyWith(searchQuery: '', isSearching: false);
      await fetchProducts();
      return;
    }

    state =
        state.copyWith(searchQuery: query, isSearching: true, isLoading: true);

    try {
      final params = ProductPaginationParams(
          pageNo: 0, rowsPerPage: 100, searchQuery: query);

      final result =
          await _ref.read(getProductDataWithPagination(params).future);

      final products = result.response.data;
      final totalCount = result.response.totalRecord;

      state = state.copyWith(
          products: products,
          currentPage: 0,
          totalCount: totalCount,
          hasNextPage: false,
          isLoading: false,
          isSearching: false);

      developer.log(
          'SEARCH COMPLETED: Found ${products.length} products matching "$query"',
          name: 'ProductPagination');

      if (products.isNotEmpty) {
        _ref
            .read(productSelectionProvider.notifier)
            .updateSelectionSize(products.length);
      }
    } catch (error) {
      developer.log('ERROR SEARCHING PRODUCTS: $error',
          name: 'ProductPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> refresh() async {
    developer.log('REFRESHING PRODUCTS AND CLEARING SEARCH',
        name: 'ProductPagination');
    state = state.copyWith(searchQuery: '', isSearching: false);
    await fetchProducts(forceRefresh: true);
  }
}

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payzo_books/data/models/product_model/product_list_model.dart';
// import 'package:payzo_books/data/repository/products_api/product_list_api.dart';
// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/view/product_page/provider/product_selection.dart';
// import 'dart:developer' as developer;

// final productPaginationStateProvider =
//     StateNotifierProvider<ProductPaginationNotifier, ProductPaginationState>(
//         (ref) {
//   return ProductPaginationNotifier(ref);
// });

// class ProductPaginationState {
//   final int currentPage;
//   final List<ProductData> products;
//   final bool isLoading;
//   final bool hasNextPage;
//   final String? errorMessage;
//   final String searchQuery;
//   final bool isSearching;
//   final int totalCount;

//   ProductPaginationState({
//     this.currentPage = 0,
//     this.products = const [],
//     this.isLoading = false,
//     this.hasNextPage = true,
//     this.errorMessage,
//     this.searchQuery = '',
//     this.isSearching = false,
//     this.totalCount = 0,
//   });

//   ProductPaginationState copyWith({
//     int? currentPage,
//     List<ProductData>? products,
//     bool? isLoading,
//     bool? hasNextPage,
//     String? errorMessage,
//     String? searchQuery,
//     bool? isSearching,
//     int? totalCount,
//   }) {
//     return ProductPaginationState(
//       currentPage: currentPage ?? this.currentPage,
//       products: products ?? this.products,
//       isLoading: isLoading ?? this.isLoading,
//       hasNextPage: hasNextPage ?? this.hasNextPage,
//       errorMessage: errorMessage,
//       searchQuery: searchQuery ?? this.searchQuery,
//       isSearching: isSearching ?? this.isSearching,
//       totalCount: totalCount ?? this.totalCount,
//     );
//   }

//   List<ProductData> get filteredProducts {
//     if (searchQuery.isEmpty) return products;

//     final query = searchQuery.toLowerCase();

//     return products.where((product) {
//       return product.itemName.toLowerCase().contains(query);
//     }).toList();
//   }
// }

// class ProductPaginationNotifier extends StateNotifier<ProductPaginationState> {
//   final Ref _ref;
//   static const int _pageSize = 15;
//   bool _isLoadingMore = false;

//   ProductPaginationNotifier(this._ref) : super(ProductPaginationState()) {
//     fetchProducts();
//   }

//   Future<void> fetchProducts({bool forceRefresh = false}) async {
//     if (state.isLoading) return;

//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       final params = ProductPaginationParams(pageNo: 0, rowsPerPage: _pageSize);

//       developer.log(
//           'FETCHING INITIAL PRODUCTS - Page 0 (forceRefresh: $forceRefresh)',
//           name: 'ProductPagination');

//       // ✅ FIX: Invalidate first if force refresh, but don't delay
//       if (forceRefresh) {
//         developer.log('Force refresh: invalidating product providers',
//             name: 'ProductPagination');
//         _ref.invalidate(getProductDataWithPagination);
//         _ref.invalidate(getProductData);
//       }

//       // Read the provider (this will fetch fresh data if invalidated)
//       final result =
//           await _ref.read(getProductDataWithPagination(params).future);

//       final products = result.response.data;
//       final totalCount = result.response.totalRecord;

//       developer.log('RECEIVED ${products.length} PRODUCTS (Total: $totalCount)',
//           name: 'ProductPagination');

//       state = state.copyWith(
//         products: products,
//         currentPage: 0,
//         totalCount: totalCount,
//         hasNextPage: products.length < totalCount,
//         isLoading: false,
//       );

//       if (products.isNotEmpty) {
//         _ref
//             .read(productSelectionProvider.notifier)
//             .updateSelectionSize(products.length);
//       }
//     } catch (error) {
//       developer.log('ERROR FETCHING PRODUCTS: $error',
//           name: 'ProductPagination', error: error);
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: error.toString(),
//       );
//     }
//   }

//   Future<void> loadMoreProducts() async {
//     // Fixed conditions - removed search query check
//     if (_isLoadingMore || state.isLoading || !state.hasNextPage) {
//       developer.log(
//           'Skipping loadMore: isLoadingMore=$_isLoadingMore, isLoading=${state.isLoading}, hasNextPage=${state.hasNextPage}',
//           name: 'ProductPagination');
//       return;
//     }

//     // Check if we've loaded all products
//     if (state.products.length >= state.totalCount && state.totalCount > 0) {
//       developer.log(
//           'All products loaded: ${state.products.length}/${state.totalCount}',
//           name: 'ProductPagination');
//       state = state.copyWith(hasNextPage: false);
//       return;
//     }

//     _isLoadingMore = true;
//     state = state.copyWith(isLoading: true);

//     try {
//       final nextPage = state.currentPage + 1;

//       developer.log('LOADING MORE PRODUCTS - Page $nextPage',
//           name: 'ProductPagination');

//       final params = ProductPaginationParams(
//         pageNo: nextPage,
//         rowsPerPage: _pageSize,
//         searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
//       );

//       // ✅ FIX: Don't invalidate here, just read
//       final result =
//           await _ref.read(getProductDataWithPagination(params).future);
//       final newProducts = result.response.data;
//       final totalCount = result.response.totalRecord;

//       if (newProducts.isEmpty) {
//         developer.log('No more products to load', name: 'ProductPagination');
//         state = state.copyWith(
//           hasNextPage: false,
//           isLoading: false,
//         );
//         _isLoadingMore = false;
//         return;
//       }

//       // Combine existing and new products
//       final allProducts = [...state.products, ...newProducts];
//       final hasMore = allProducts.length < totalCount;

//       state = state.copyWith(
//         products: allProducts,
//         currentPage: nextPage,
//         totalCount: totalCount,
//         hasNextPage: hasMore,
//         isLoading: false,
//       );

//       developer.log(
//           'ADDED ${newProducts.length} MORE PRODUCTS. Has more: $hasMore. Total: ${allProducts.length}/$totalCount',
//           name: 'ProductPagination');

//       if (allProducts.isNotEmpty) {
//         _ref
//             .read(productSelectionProvider.notifier)
//             .updateSelectionSize(allProducts.length);
//       }
//     } catch (error) {
//       developer.log('ERROR LOADING MORE PRODUCTS: $error',
//           name: 'ProductPagination', error: error);
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: error.toString(),
//       );
//     } finally {
//       _isLoadingMore = false;
//     }
//   }

//   Future<void> setSearchQuery(String query) async {
//     developer.log('SETTING SEARCH QUERY: "$query"', name: 'ProductPagination');

//     if (query.isEmpty) {
//       state = state.copyWith(searchQuery: '', isSearching: false);
//       await fetchProducts(forceRefresh: true);
//       return;
//     }

//     state =
//         state.copyWith(searchQuery: query, isSearching: true, isLoading: true);

//     try {
//       final params = ProductPaginationParams(
//           pageNo: 0, rowsPerPage: 100, searchQuery: query);

//       // ✅ FIX: Invalidate and immediately read
//       _ref.invalidate(getProductDataWithPagination);
//       final result =
//           await _ref.read(getProductDataWithPagination(params).future);

//       final products = result.response.data;
//       final totalCount = result.response.totalRecord;

//       state = state.copyWith(
//           products: products,
//           currentPage: 0,
//           totalCount: totalCount,
//           hasNextPage: products.length < totalCount,
//           isLoading: false,
//           isSearching: false);

//       developer.log(
//           'SEARCH COMPLETED: Found ${products.length} products matching "$query"',
//           name: 'ProductPagination');

//       if (products.isNotEmpty) {
//         _ref
//             .read(productSelectionProvider.notifier)
//             .updateSelectionSize(products.length);
//       }
//     } catch (error) {
//       developer.log('ERROR SEARCHING PRODUCTS: $error',
//           name: 'ProductPagination', error: error);
//       state = state.copyWith(
//         isLoading: false,
//         isSearching: false,
//         errorMessage: error.toString(),
//       );
//     }
//   }

//   Future<void> refresh() async {
//     developer.log('REFRESHING PRODUCTS AND CLEARING SEARCH',
//         name: 'ProductPagination');

//     state = state.copyWith(searchQuery: '', isSearching: false);
//     await fetchProducts(forceRefresh: true);
//   }
// }
