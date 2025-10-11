import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/customer_model/customer_model.dart';
import 'package:payzo_books/data/repository/customer_list_page/customer_listing_api.dart';
import 'dart:developer' as developer;

import '../../../import_data.dart';

final customerPaginationStateProvider =
    StateNotifierProvider<CustomerPaginationNotifier, CustomerPaginationState>(
        (ref) {
  return CustomerPaginationNotifier(ref);
});

class CustomerPaginationState {
  final int currentPage;
  final List<Customer> customers;
  final bool isLoading;
  final bool hasNextPage;
  final String? errorMessage;
  final String searchQuery;
  final bool isSearching;
  final int totalCount;

  CustomerPaginationState({
    this.currentPage = 0,
    this.customers = const [],
    this.isLoading = false,
    this.hasNextPage = true,
    this.errorMessage,
    this.searchQuery = '',
    this.isSearching = false,
    this.totalCount = 0,
  });

  CustomerPaginationState copyWith({
    int? currentPage,
    List<Customer>? customers,
    bool? isLoading,
    bool? hasNextPage,
    String? errorMessage,
    String? searchQuery,
    bool? isSearching,
    int? totalCount,
  }) {
    return CustomerPaginationState(
      currentPage: currentPage ?? this.currentPage,
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  List<Customer> get filteredCustomers {
    return customers;
  }
}

class CustomerPaginationNotifier
    extends StateNotifier<CustomerPaginationState> {
  final Ref _ref;
  static const int _pageSize = 15;
  bool _isLoadingMore = false;

  CustomerPaginationNotifier(this._ref) : super(CustomerPaginationState()) {
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      currentPage: 0,
    );

    try {
      final params = CustomerPaginationParams(
          pageNo: 0, rowsPerPage: _pageSize, searchQuery: null);

      developer.log('FETCHING INITIAL CUSTOMERS - Page 0',
          name: 'CustomerPagination');

      final result =
          await _ref.read(getCustomerDataWithPagination(params).future);

      final customers = result.response.response;
      final totalCount = result.response.totalRecord;

      state = state.copyWith(
        customers: customers,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: customers.length < totalCount,
        isLoading: false,
      );
    } catch (error) {
      developer.log('ERROR FETCHING CUSTOMERS: $error',
          name: 'CustomerPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> loadMoreCustomers() async {
    if (state.searchQuery.isNotEmpty) {
      await loadMoreSearchResults();
      return;
    }

    if (_isLoadingMore || state.isLoading || !state.hasNextPage) {
      return;
    }

    _isLoadingMore = true;
    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;

      developer.log('LOADING MORE CUSTOMERS - Page $nextPage',
          name: 'CustomerPagination');

      final params = CustomerPaginationParams(
          pageNo: nextPage,
          rowsPerPage: _pageSize,
          searchQuery: state.searchQuery);

      final result =
          await _ref.read(getCustomerDataWithPagination(params).future);

      final newCustomers = result.response.response;
      final totalCount = result.response.totalRecord;

      developer.log('RECEIVED ${newCustomers.length} MORE CUSTOMERS',
          name: 'CustomerPagination');

      if (newCustomers.isEmpty) {
        state = state.copyWith(
          hasNextPage: false,
          isLoading: false,
        );
        _isLoadingMore = false;
        return;
      }

      final allCustomers = [...state.customers, ...newCustomers];
      final hasMore = allCustomers.length < totalCount;

      state = state.copyWith(
        customers: allCustomers,
        currentPage: nextPage,
        totalCount: totalCount,
        hasNextPage: hasMore,
        isLoading: false,
      );

      developer.log(
          'ADDED ${newCustomers.length} NEW CUSTOMERS. Has more: $hasMore. Total: ${allCustomers.length}/$totalCount',
          name: 'CustomerPagination');
    } catch (error) {
      developer.log('ERROR LOADING MORE CUSTOMERS: $error',
          name: 'CustomerPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> setSearchQuery(String query) async {
    developer.log('SETTING SEARCH QUERY: "$query"', name: 'CustomerPagination');

    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        isSearching: false,
      );

      await fetchCustomers();
      return;
    }

    state = state.copyWith(
      searchQuery: query,
      isSearching: true,
      isLoading: true,
    );

    try {
      final params = CustomerPaginationParams(
        pageNo: 0,
        rowsPerPage: 1000,
        searchQuery: query,
      );

      final result =
          await _ref.read(getCustomerDataWithPagination(params).future);
      final customers = result.response.response;
      final totalCount = result.response.totalRecord;

      state = state.copyWith(
        customers: customers,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: false,
        isLoading: false,
        isSearching: false,
      );

      developer.log(
        'SEARCH COMPLETED: Found ${customers.length} customers matching "$query"',
        name: 'CustomerPagination',
      );
    } catch (error) {
      developer.log(
        'ERROR SEARCHING CUSTOMERS: $error',
        name: 'CustomerPagination',
        error: error,
      );
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        errorMessage: error.toString(),
      );
    }
  }

  List<Customer> get filteredCustomers => state.customers;
  Future<void> loadMoreSearchResults() async {
    if (_isLoadingMore || state.isLoading || !state.hasNextPage) {
      return;
    }

    _isLoadingMore = true;
    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;

      developer.log('LOADING MORE SEARCH RESULTS - Page $nextPage',
          name: 'CustomerPagination');

      final params = CustomerPaginationParams(
        pageNo: nextPage,
        rowsPerPage: _pageSize,
        searchQuery: state.searchQuery,
      );

      final result =
          await _ref.read(getCustomerDataWithPagination(params).future);
      final newCustomers = result.response.response;
      final totalCount = result.response.totalRecord;

      if (newCustomers.isEmpty) {
        state = state.copyWith(
          hasNextPage: false,
          isLoading: false,
        );
        _isLoadingMore = false;
        return;
      }

      final allCustomers = [...state.customers, ...newCustomers];
      final hasMore = allCustomers.length < totalCount;

      state = state.copyWith(
        customers: allCustomers,
        currentPage: nextPage,
        totalCount: totalCount,
        hasNextPage: hasMore,
        isLoading: false,
      );

      developer.log(
          'ADDED ${newCustomers.length} MORE CUSTOMERS TO SEARCH RESULTS. Has more: $hasMore. Total: ${allCustomers.length}/$totalCount',
          name: 'CustomerPagination');
    } catch (error) {
      developer.log('ERROR LOADING MORE SEARCH RESULTS: $error',
          name: 'CustomerPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  // refresh() {
  //   developer.log('REFRESHING CUSTOMERS', name: 'CustomerPagination');
  //   state = state.copyWith(searchQuery: '');
  //   fetchCustomers();
  // }

  Future<void> refresh() async {
    // ✅ Changed from void to Future<void>
    developer.log('REFRESHING CUSTOMERS', name: 'CustomerPagination');
    state = state.copyWith(searchQuery: '', isSearching: false);
    await fetchCustomers(); // ✅ Added await
  }
}
