import 'package:payzo_books/data/models/vendor_model/vendor_model.dart';
import 'package:payzo_books/data/repository/vendor_api/vendor_listing/vendor_api.dart';
import 'package:payzo_books/import_data.dart';
import 'dart:developer' as developer;

final vendorPaginationStateProvider =
    StateNotifierProvider<VendorPaginationNotifier, VendorPaginationState>(
        (ref) {
  return VendorPaginationNotifier(ref);
});

class VendorPaginationState {
  final int currentPage;
  final List<Vendor> vendors;
  final bool isLoading;
  final bool hasNextPage;
  final String? errorMessage;
  final String searchQuery;
  final bool isSearching;
  final int totalCount;

  VendorPaginationState({
    this.currentPage = 0,
    this.vendors = const [],
    this.isLoading = false,
    this.hasNextPage = true,
    this.errorMessage,
    this.searchQuery = '',
    this.isSearching = false,
    this.totalCount = 0,
  });

  VendorPaginationState copyWith({
    int? currentPage,
    List<Vendor>? vendors,
    bool? isLoading,
    bool? hasNextPage,
    String? errorMessage,
    String? searchQuery,
    bool? isSearching,
    int? totalCount,
  }) {
    return VendorPaginationState(
      currentPage: currentPage ?? this.currentPage,
      vendors: vendors ?? this.vendors,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  List<Vendor> get filteredVendors {
    return vendors;
  }
}

class VendorPaginationNotifier extends StateNotifier<VendorPaginationState> {
  final Ref _ref;
  static const int _pageSize = 15;
  bool _isLoadingMore = false;

  VendorPaginationNotifier(this._ref) : super(VendorPaginationState()) {
    fetchVendors();
  }

  Future<void> fetchVendors() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      currentPage: 0,
    );

    try {
      final params = VendorPaginationParams(
          pageNo: 0, rowsPerPage: _pageSize, searchQuery: null);

      developer.log('FETCHING INITIAL VENDORS - Page 0',
          name: 'VendorPagination');

      final result =
          await _ref.read(getVendorDataWithPagination(params).future);

      final vendors = result.response.response;
      final totalCount = result.response.totalRecord;

      state = state.copyWith(
        vendors: vendors,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: vendors.length < totalCount,
        isLoading: false,
      );
    } catch (error) {
      developer.log('ERROR FETCHING VENDORS: $error',
          name: 'VendorPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> loadMoreVendors() async {
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

      developer.log('LOADING MORE VENDORS - Page $nextPage',
          name: 'VendorPagination');
      developer.log(
          'Current state: ${state.vendors.length} vendors, ${state.totalCount} total',
          name: 'VendorPagination');

      final params = VendorPaginationParams(
          pageNo: nextPage,
          rowsPerPage: _pageSize,
          searchQuery: state.searchQuery);

      final result =
          await _ref.read(getVendorDataWithPagination(params).future);

      final newVendors = result.response.response;
      final totalCount = result.response.totalRecord;

      developer.log('RECEIVED ${newVendors.length} MORE VENDORS',
          name: 'VendorPagination');

      if (newVendors.isEmpty) {
        state = state.copyWith(
          hasNextPage: false,
          isLoading: false,
        );
        _isLoadingMore = false;
        return;
      }
      final allVendors = [...state.vendors, ...newVendors];
      final hasMore = allVendors.length < totalCount;

      state = state.copyWith(
        vendors: allVendors,
        currentPage: nextPage,
        totalCount: totalCount,
        hasNextPage: hasMore,
        isLoading: false,
      );

      developer.log(
          'ADDED ${newVendors.length} NEW VENDORS. Has more: $hasMore. Total: ${allVendors.length}/$totalCount',
          name: 'VendorPagination');
    } catch (error) {
      developer.log('ERROR LOADING MORE VENDORS: $error',
          name: 'VendorPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> setSearchQuery(String query) async {
    developer.log('SETTING SEARCH QUERY: "$query"', name: 'VendorPagination');

    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        isSearching: false,
      );

      await fetchVendors();
      return;
    }

    state = state.copyWith(
      searchQuery: query,
      isSearching: true,
      isLoading: true,
    );

    try {
      final params = VendorPaginationParams(
        pageNo: 0,
        rowsPerPage: 1000,
        searchQuery: query,
      );

      final result =
          await _ref.read(getVendorDataWithPagination(params).future);
      final vendors = result.response.response;
      final totalCount = result.response.totalRecord;

      state = state.copyWith(
        vendors: vendors,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: false,
        isLoading: false,
        isSearching: false,
      );

      developer.log(
        'SEARCH COMPLETED: Found ${vendors.length} vendors matching "$query"',
        name: 'VendorPagination',
      );
    } catch (error) {
      developer.log(
        'ERROR SEARCHING VENDORS: $error',
        name: 'VendorPagination',
        error: error,
      );
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        errorMessage: error.toString(),
      );
    }
  }

  List<Vendor> get filteredVendors => state.vendors;

  Future<void> loadMoreSearchResults() async {
    if (_isLoadingMore || state.isLoading || !state.hasNextPage) {
      return;
    }

    _isLoadingMore = true;
    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;

      developer.log('LOADING MORE SEARCH RESULTS - Page $nextPage',
          name: 'VendorPagination');

      final params = VendorPaginationParams(
        pageNo: nextPage,
        rowsPerPage: _pageSize,
        searchQuery: state.searchQuery,
      );

      final result =
          await _ref.read(getVendorDataWithPagination(params).future);
      final newVendors = result.response.response;
      final totalCount = result.response.totalRecord;

      if (newVendors.isEmpty) {
        state = state.copyWith(
          hasNextPage: false,
          isLoading: false,
        );
        _isLoadingMore = false;
        return;
      }

      final allVendors = [...state.vendors, ...newVendors];
      final hasMore = allVendors.length < totalCount;

      state = state.copyWith(
        vendors: allVendors,
        currentPage: nextPage,
        totalCount: totalCount,
        hasNextPage: hasMore,
        isLoading: false,
      );

      developer.log(
          'ADDED ${newVendors.length} MORE VENDORS TO SEARCH RESULTS. Has more: $hasMore. Total: ${allVendors.length}/$totalCount',
          name: 'VendorPagination');
    } catch (error) {
      developer.log('ERROR LOADING MORE SEARCH RESULTS: $error',
          name: 'VendorPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  // refresh() {
  //   developer.log('REFRESHING VENDORS', name: 'VendorPagination');
  //   state = state.copyWith(searchQuery: '');
  //   fetchVendors();
  // }

  Future<void> refresh() async {
    // ✅ Changed from void to Future<void>
    developer.log('REFRESHING VENDORS', name: 'VendorPagination');
    state = state.copyWith(searchQuery: '', isSearching: false);
    await fetchVendors(); // ✅ Added await
  }
}
