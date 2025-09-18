import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/invoice_model/invoice_list_model.dart';
import 'package:payzo_books/data/repository/invoice_api/invoice_detail_api.dart';
import 'package:payzo_books/view/invoice_screen/provider/invoice_fn_provider.dart';
import 'dart:developer' as developer;

import '../../../import_data.dart';

// final invoicePaginationStateProvider =
//     StateNotifierProvider<InvoicePaginationNotifier, InvoicePaginationState>(
//         (ref) {
//   return InvoicePaginationNotifier(ref);
// });

// class InvoicePaginationState {
//   final int currentPage;
//   final List<InvoiceData> invoices;
//   final bool isLoading;
//   final bool hasNextPage;
//   final String? errorMessage;
//   final String searchQuery;
//   final bool isSearching;

//   InvoicePaginationState({
//     this.currentPage = 0,
//     this.invoices = const [],
//     this.isLoading = false,
//     this.hasNextPage = true,
//     this.errorMessage,
//     this.searchQuery = '',
//     this.isSearching = false,
//   });

//   InvoicePaginationState copyWith({
//     int? currentPage,
//     List<InvoiceData>? invoices,
//     bool? isLoading,
//     bool? hasNextPage,
//     String? errorMessage,
//     String? searchQuery,
//     bool? isSearching,
//   }) {
//     return InvoicePaginationState(
//       currentPage: currentPage ?? this.currentPage,
//       invoices: invoices ?? this.invoices,
//       isLoading: isLoading ?? this.isLoading,
//       hasNextPage: hasNextPage ?? this.hasNextPage,
//       errorMessage: errorMessage,
//       searchQuery: searchQuery ?? this.searchQuery,
//       isSearching: isSearching ?? this.isSearching,
//     );
//   }

//   List<InvoiceData> get filteredInvoices => invoices;
// }

// class InvoicePaginationNotifier extends StateNotifier<InvoicePaginationState> {
//   final Ref _ref;
//   static const int _pageSize = 15;

//   InvoicePaginationNotifier(this._ref) : super(InvoicePaginationState()) {
//     fetchInvoices();
//   }

//   Future<void> fetchInvoices() async {
//     if (state.isLoading) return;

//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       final params = InvoicePaginationParams(pageNo: 0, rowsPerPage: _pageSize);

//       final result =
//           await _ref.read(getInvoiceDataWithPagination(params).future);

//       final invoices = result.invoiceData ?? [];
//       final totalRecords = result.totalCount ?? 0;

//       state = state.copyWith(
//         invoices: invoices,
//         currentPage: 0,
//         hasNextPage: ((0 + 1) * _pageSize) < totalRecords,
//         isLoading: false,
//       );

//       print(
//           'Loaded ${invoices.length} invoices. Has more: ${state.hasNextPage}, Total: $totalRecords');

//       if (invoices.isNotEmpty) {
//         _ref
//             .read(invoiceSelectionProvider.notifier)
//             .updateSelectionSize(invoices.length);
//       }
//     } catch (error) {
//       print('Error fetching initial invoices: $error');
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: error.toString(),
//       );
//     }
//   }

//   Future<void> loadMoreInvoices() async {
//     if (state.isLoading || !state.hasNextPage || state.searchQuery.isNotEmpty)
//       return;

//     state = state.copyWith(isLoading: true);

//     try {
//       final nextPage = state.currentPage + 1;
//       final params =
//           InvoicePaginationParams(pageNo: nextPage, rowsPerPage: _pageSize);

//       print('Fetching more invoices page $nextPage');

//       final result =
//           await _ref.read(getInvoiceDataWithPagination(params).future);

//       final newInvoices = result.invoiceData ?? [];
//       final totalRecords = result.totalCount ?? 0;

//       final allInvoices = [...state.invoices, ...newInvoices];

//       state = state.copyWith(
//         invoices: allInvoices,
//         currentPage: nextPage,
//         hasNextPage: ((nextPage + 1) * _pageSize) < totalRecords,
//         isLoading: false,
//       );

//       _ref
//           .read(invoiceSelectionProvider.notifier)
//           .updateSelectionSize(allInvoices.length);

//       print(
//           'Added ${newInvoices.length} more invoices. Has more: ${state.hasNextPage}');
//     } catch (error) {
//       print('Error loading more invoices: $error');
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: error.toString(),
//       );
//     }
//   }

//   Future<void> setSearchQuery(String query) async {
//     print('Setting invoice search query to: "$query"');

//     state =
//         state.copyWith(searchQuery: query, isSearching: true, isLoading: true);

//     if (query.isEmpty) {
//       await fetchInvoices();
//       return;
//     }

//     try {
//       final params = InvoicePaginationParams(
//           pageNo: 0, rowsPerPage: _pageSize, searchQuery: query);

//       final result =
//           await _ref.read(getInvoiceDataWithPagination(params).future);

//       final invoices = result.invoiceData ?? [];
//       final totalRecords = result.totalCount ?? 0;

//       state = state.copyWith(
//           invoices: invoices,
//           currentPage: 0,
//           hasNextPage: ((0 + 1) * _pageSize) < totalRecords,
//           isLoading: false,
//           isSearching: false);

//       print(
//           'Invoice search completed. Found ${invoices.length} invoices matching "$query"');

//       if (invoices.isNotEmpty) {
//         _ref
//             .read(invoiceSelectionProvider.notifier)
//             .updateSelectionSize(invoices.length);
//       }
//     } catch (error) {
//       print('Error searching invoices: $error');
//       state = state.copyWith(
//         isLoading: false,
//         isSearching: false,
//         errorMessage: error.toString(),
//       );
//     }
//   }

//   void refresh() {
//     print('Refreshing invoices and clearing search');
//     state = state.copyWith(searchQuery: '');
//     fetchInvoices();
//   }
// }

final invoicePaginationStateProvider =
    StateNotifierProvider<InvoicePaginationNotifier, InvoicePaginationState>(
        (ref) {
  return InvoicePaginationNotifier(ref);
});

class InvoicePaginationState {
  final int currentPage;
  final List<InvoiceData> invoices;
  final bool isLoading;
  final bool hasNextPage;
  final String? errorMessage;
  final String searchQuery;
  final bool isSearching;
  final int totalCount;

  InvoicePaginationState({
    this.currentPage = 0,
    this.invoices = const [],
    this.isLoading = false,
    this.hasNextPage = true,
    this.errorMessage,
    this.searchQuery = '',
    this.isSearching = false,
    this.totalCount = 0,
  });

  InvoicePaginationState copyWith({
    int? currentPage,
    List<InvoiceData>? invoices,
    bool? isLoading,
    bool? hasNextPage,
    String? errorMessage,
    String? searchQuery,
    bool? isSearching,
    int? totalCount,
  }) {
    return InvoicePaginationState(
      currentPage: currentPage ?? this.currentPage,
      invoices: invoices ?? this.invoices,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  List<InvoiceData> get filteredInvoices {
    if (searchQuery.isEmpty) return invoices;

    return invoices.where((invoice) {
      if (invoice.invoiceNumber
          .toLowerCase()
          .contains(searchQuery.toLowerCase())) {
        return true;
      }

      if (invoice.invoiceCustomerName
          .toLowerCase()
          .contains(searchQuery.toLowerCase())) {
        return true;
      }

      return false;
    }).toList();
  }
}

class InvoicePaginationNotifier extends StateNotifier<InvoicePaginationState> {
  final Ref _ref;
  static const int _pageSize = 15;
  bool _isLoadingMore = false;

  InvoicePaginationNotifier(this._ref) : super(InvoicePaginationState()) {
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final params = InvoicePaginationParams(pageNo: 0, rowsPerPage: _pageSize);

      developer.log('FETCHING INITIAL INVOICES - Page 0',
          name: 'InvoicePagination');

      final result =
          await _ref.read(getInvoiceDataWithPagination(params).future);

      final invoices = result.invoiceData ?? [];
      final totalCount = result.totalCount ?? 0;

      developer.log('RECEIVED ${invoices.length} INVOICES (Total: $totalCount)',
          name: 'InvoicePagination');

      state = state.copyWith(
        invoices: invoices,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: invoices.length < totalCount,
        isLoading: false,
      );

      if (invoices.isNotEmpty) {
        _ref
            .read(invoiceSelectionProvider.notifier)
            .updateSelectionSize(invoices.length);
      }
    } catch (error) {
      developer.log('ERROR FETCHING INVOICES: $error',
          name: 'InvoicePagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> loadMoreInvoices() async {
    if (_isLoadingMore ||
        state.isLoading ||
        !state.hasNextPage ||
        state.searchQuery.isNotEmpty) {
      return;
    }

    if (state.invoices.length >= state.totalCount) {
      state = state.copyWith(hasNextPage: false);
      return;
    }

    _isLoadingMore = true;
    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;

      developer.log('LOADING MORE INVOICES - Page $nextPage',
          name: 'InvoicePagination');
      developer.log(
          'Current state: ${state.invoices.length} invoices, ${state.totalCount} total',
          name: 'InvoicePagination');

      final pageOffset = nextPage * _pageSize;
      final paramsWithOffset = InvoicePaginationParams(
          pageNo: pageOffset,
          rowsPerPage: _pageSize,
          searchQuery: state.searchQuery);

      final result = await _ref
          .read(getInvoiceDataWithPagination(paramsWithOffset).future);

      final newInvoices = result.invoiceData ?? [];
      final totalCount = result.totalCount ?? state.totalCount;

      developer.log('RECEIVED ${newInvoices.length} MORE INVOICES',
          name: 'InvoicePagination');

      if (newInvoices.isEmpty) {
        state = state.copyWith(
          hasNextPage: false,
          isLoading: false,
        );
        _isLoadingMore = false;
        return;
      }

      final Set<int> existingIds =
          state.invoices.map((invoice) => invoice.invoiceId).toSet();
      final List<InvoiceData> allInvoices = [...state.invoices];
      int addedCount = 0;

      for (var newInvoice in newInvoices) {
        if (!existingIds.contains(newInvoice.invoiceId)) {
          allInvoices.add(newInvoice);
          existingIds.add(newInvoice.invoiceId);
          addedCount++;
        }
      }

      final hasMore = allInvoices.length < totalCount;

      state = state.copyWith(
        invoices: allInvoices,
        currentPage: nextPage,
        totalCount: totalCount,
        hasNextPage: hasMore,
        isLoading: false,
      );

      _ref
          .read(invoiceSelectionProvider.notifier)
          .updateSelectionSize(allInvoices.length);

      developer.log(
          'ADDED $addedCount NEW INVOICES. Has more: $hasMore. Total: ${allInvoices.length}/$totalCount',
          name: 'InvoicePagination');
    } catch (error) {
      developer.log('ERROR LOADING MORE INVOICES: $error',
          name: 'InvoicePagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> setSearchQuery(String query) async {
    developer.log('SETTING SEARCH QUERY: "$query"', name: 'InvoicePagination');

    if (query.isEmpty) {
      state = state.copyWith(searchQuery: '', isSearching: false);
      await fetchInvoices();
      return;
    }

    state =
        state.copyWith(searchQuery: query, isSearching: true, isLoading: true);

    try {
      final params = InvoicePaginationParams(
          pageNo: 0, rowsPerPage: 100, searchQuery: query);

      final result =
          await _ref.read(getInvoiceDataWithPagination(params).future);

      final invoices = result.invoiceData ?? [];
      final totalCount = result.totalCount ?? 0;

      state = state.copyWith(
          invoices: invoices,
          currentPage: 0,
          totalCount: totalCount,
          hasNextPage: false,
          isLoading: false,
          isSearching: false);

      developer.log(
          'SEARCH COMPLETED: Found ${invoices.length} invoices matching "$query"',
          name: 'InvoicePagination');

      if (invoices.isNotEmpty) {
        _ref
            .read(invoiceSelectionProvider.notifier)
            .updateSelectionSize(invoices.length);
      }
    } catch (error) {
      developer.log('ERROR SEARCHING INVOICES: $error',
          name: 'InvoicePagination', error: error);
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        errorMessage: error.toString(),
      );
    }
  }

  void refresh() {
    developer.log('REFRESHING INVOICES AND CLEARING SEARCH',
        name: 'InvoicePagination');
    state = state.copyWith(searchQuery: '');
    fetchInvoices();
  }
}
