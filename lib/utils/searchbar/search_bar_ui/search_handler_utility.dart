import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

class SearchHandler {
  final WidgetRef ref;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Timer? _debounceTimer;
  final Duration _debounceDelay;
  final void Function(String) _onSearch;
  final void Function()? _onClear;

  SearchHandler({
    required this.ref,
    required void Function(String) onSearch,
    void Function()? onClear,
    Duration? debounceDelay,
  })  : _onSearch = onSearch,
        _onClear = onClear,
        _debounceDelay = debounceDelay ?? const Duration(milliseconds: 300);

  void handleSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(_debounceDelay, () {
      developer.log('Searching after debounce: "$query"',
          name: 'SearchHandler');
      _onSearch(query);
    });
  }

  void clearSearch() {
    controller.clear();
    if (_onClear != null) {
      _onClear!();
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
    controller.dispose();
    focusNode.dispose();
  }
}

// final invoiceSearchHandlerProvider = Provider<SearchHandler>((ref) {
//   final invoicePagination = ref.read(invoicePaginationStateProvider.notifier);
  
//   final handler = SearchHandler(
//     ref: ref,
//     onSearch: (query) {
//       invoicePagination.setSearchQuery(query);
//     },
//     onClear: () {
//       invoicePagination.refresh();
//     },
//   );
  
//   ref.onDispose(() {
//     handler.dispose();
//   });
  
//   return handler;
// });

// final productSearchHandlerProvider = Provider<SearchHandler>((ref) {
//   final productPagination = ref.read(productPaginationStateProvider.notifier);
  
//   final handler = SearchHandler(
//     ref: ref,
//     onSearch: (query) {
//       productPagination.setSearchQuery(query);
//     },
//     onClear: () {
//       productPagination.refresh();
//     },
//   );
  
//   ref.onDispose(() {
//     handler.dispose();
//   });
  
//   return handler;
// });

// final customerSearchHandlerProvider = Provider<SearchHandler>((ref) {
//   final customerPagination = ref.read(customerPaginationStateProvider.notifier);
  
//   final handler = SearchHandler(
//     ref: ref,
//     onSearch: (query) {
//       customerPagination.setSearchQuery(query);
//     },
//     onClear: () {
//       customerPagination.refresh();
//     },
//   );
  
//   ref.onDispose(() {
//     handler.dispose();
//   });
  
//   return handler;
// });

// final vendorSearchHandlerProvider = Provider<SearchHandler>((ref) {
//   final vendorPagination = ref.read(vendorPaginationStateProvider.notifier);
  
//   final handler = SearchHandler(
//     ref: ref,
//     onSearch: (query) {
//       vendorPagination.setSearchQuery(query);
//     },
//     onClear: () {
//       vendorPagination.refresh();
//     },
//   );
  
//   ref.onDispose(() {
//     handler.dispose();
//   });
  
//   return handler;
// });

// final billSearchHandlerProvider = Provider<SearchHandler>((ref) {
//   final billPagination = ref.read(billPaginationStateProvider.notifier);
  
//   final handler = SearchHandler(
//     ref: ref,
//     onSearch: (query) {
//       billPagination.setSearchQuery(query);
//     },
//     onClear: () {
//       billPagination.refresh();
//     },
//   );
  
//   ref.onDispose(() {
//     handler.dispose();
//   });
  
//   return handler;
// });