import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/bill_model/bill_model.dart';
import 'package:payzo_books/data/repository/bills_api/bills_api.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_fn_provider.dart';
import 'dart:developer' as developer;

import '../../../import_data.dart';

final billPaginationStateProvider =
    StateNotifierProvider<BillPaginationNotifier, BillPaginationState>((ref) {
  return BillPaginationNotifier(ref);
});

class BillPaginationState {
  final int currentPage;
  final List<BillData> bills;
  final bool isLoading;
  final bool hasNextPage;
  final String? errorMessage;
  final String searchQuery;
  final bool isSearching;
  final int totalCount;

  BillPaginationState({
    this.currentPage = 0,
    this.bills = const [],
    this.isLoading = false,
    this.hasNextPage = true,
    this.errorMessage,
    this.searchQuery = '',
    this.isSearching = false,
    this.totalCount = 0,
  });

  BillPaginationState copyWith({
    int? currentPage,
    List<BillData>? bills,
    bool? isLoading,
    bool? hasNextPage,
    String? errorMessage,
    String? searchQuery,
    bool? isSearching,
    int? totalCount,
  }) {
    return BillPaginationState(
      currentPage: currentPage ?? this.currentPage,
      bills: bills ?? this.bills,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  List<BillData> get filteredBills {
    if (searchQuery.isEmpty) return bills;

    return bills.where((bill) {
      if (bill.billInvoiceNumber
          .toUpperCase()
          .contains(searchQuery.toUpperCase())) {
        return true;
      }

      if (bill.billVenderName
          .toLowerCase()
          .contains(searchQuery.toLowerCase())) {
        return true;
      }

      if (bill.productDetails.isNotEmpty) {
        for (var product in bill.productDetails) {
          if (product.productName
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
            return true;
          }
        }
      }

      return false;
    }).toList();
  }
}

class BillPaginationNotifier extends StateNotifier<BillPaginationState> {
  final Ref _ref;
  static const int _pageSize = 15;
  bool _isLoadingMore = false;

  BillPaginationNotifier(this._ref) : super(BillPaginationState()) {
    fetchBills();
  }

  Future<void> fetchBills() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final params = BillPaginationParams(pageNo: 0, rowsPerPage: _pageSize);

      developer.log('FETCHING INITIAL BILLS - Page 0', name: 'BillPagination');

      final result = await _ref.read(getBillDataWithPagination(params).future);

      final bills = result.billData ?? [];
      final totalCount = result.totalCount ?? 0;

      developer.log('RECEIVED ${bills.length} BILLS (Total: $totalCount)',
          name: 'BillPagination');

      state = state.copyWith(
        bills: bills,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: bills.length < totalCount,
        isLoading: false,
      );

      if (bills.isNotEmpty) {
        _ref
            .read(billSelectionProvider.notifier)
            .updateSelectionSize(bills.length);
      }
    } catch (error) {
      developer.log('ERROR FETCHING BILLS: $error',
          name: 'BillPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> loadMoreBills() async {
    if (_isLoadingMore ||
        state.isLoading ||
        !state.hasNextPage ||
        state.searchQuery.isNotEmpty) {
      return;
    }

    if (state.bills.length >= state.totalCount) {
      state = state.copyWith(hasNextPage: false);
      return;
    }

    _isLoadingMore = true;
    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;

      developer.log('LOADING MORE BILLS - Page $nextPage',
          name: 'BillPagination');
      developer.log(
          'Current state: ${state.bills.length} bills, ${state.totalCount} total',
          name: 'BillPagination');

      final params =
          BillPaginationParams(pageNo: nextPage, rowsPerPage: _pageSize);

      final result = await _ref.read(getBillDataWithPagination(params).future);

      final newBills = result.billData ?? [];
      final totalCount = result.totalCount ?? state.totalCount;

      developer.log('RECEIVED ${newBills.length} MORE BILLS',
          name: 'BillPagination');

      if (newBills.isEmpty) {
        state = state.copyWith(
          hasNextPage: false,
          isLoading: false,
        );
        _isLoadingMore = false;
        return;
      }

      final Set<int> existingIds =
          state.bills.map((bill) => bill.billId).toSet();
      final List<BillData> allBills = [...state.bills];
      int addedCount = 0;

      for (var newBill in newBills) {
        if (!existingIds.contains(newBill.billId)) {
          allBills.add(newBill);
          existingIds.add(newBill.billId);
          addedCount++;
        }
      }

      final hasMore = allBills.length < totalCount;

      state = state.copyWith(
        bills: allBills,
        currentPage: nextPage,
        totalCount: totalCount,
        hasNextPage: hasMore,
        isLoading: false,
      );

      _ref
          .read(billSelectionProvider.notifier)
          .updateSelectionSize(allBills.length);

      developer.log(
          'ADDED $addedCount NEW BILLS. Has more: $hasMore. Total: ${allBills.length}/$totalCount',
          name: 'BillPagination');
    } catch (error) {
      developer.log('ERROR LOADING MORE BILLS: $error',
          name: 'BillPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> setSearchQuery(String query) async {
    developer.log('SETTING SEARCH QUERY: "$query"', name: 'BillPagination');

    if (query.isEmpty) {
      state = state.copyWith(searchQuery: '', isSearching: false);
      await fetchBills();
      return;
    }

    state =
        state.copyWith(searchQuery: query, isSearching: true, isLoading: true);

    try {
      final params =
          BillPaginationParams(pageNo: 0, rowsPerPage: 100, searchQuery: query);

      final result = await _ref.read(getBillDataWithPagination(params).future);

      final bills = result.billData ?? [];
      final totalCount = result.totalCount ?? 0;

      state = state.copyWith(
          bills: bills,
          currentPage: 0,
          totalCount: totalCount,
          hasNextPage: false,
          isLoading: false,
          isSearching: false);

      developer.log(
          'SEARCH COMPLETED: Found ${bills.length} bills matching "$query"',
          name: 'BillPagination');

      if (bills.isNotEmpty) {
        _ref
            .read(billSelectionProvider.notifier)
            .updateSelectionSize(bills.length);
      }
    } catch (error) {
      developer.log('ERROR SEARCHING BILLS: $error',
          name: 'BillPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        errorMessage: error.toString(),
      );
    }
  }

  // void refresh() {
  //   developer.log('REFRESHING BILLS AND CLEARING SEARCH',
  //       name: 'BillPagination');
  //   state = state.copyWith(searchQuery: '');
  //   fetchBills();
  // }

  Future<void> refresh() async {
    // ✅ Make it async
    developer.log('REFRESHING BILLS AND CLEARING SEARCH',
        name: 'BillPagination');
    state = state.copyWith(searchQuery: '', isSearching: false);
    await fetchBills(); // ✅ Add await
  }
}
