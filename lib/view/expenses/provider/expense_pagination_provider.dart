import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/view/expenses/model/expenses_fn_provider.dart';
import 'package:payzo_books/view/expenses/model/get_expense_list_model.dart';
import 'dart:developer' as developer;

import 'package:payzo_books/view/expenses/repo/expense_repo.dart';

import '../../../import_data.dart';

final expensesPaginationStateProvider =
    StateNotifierProvider<ExpensesPaginationNotifier, ExpensesPaginationState>(
        (ref) {
  return ExpensesPaginationNotifier(ref);
});

class ExpensesPaginationState {
  final int currentPage;
  final List<Data> expenses;
  final bool isLoading;
  final bool hasNextPage;
  final String? errorMessage;
  final String searchQuery;
  final bool isSearching;
  final int totalCount;

  ExpensesPaginationState({
    this.currentPage = 0,
    this.expenses = const [],
    this.isLoading = false,
    this.hasNextPage = true,
    this.errorMessage,
    this.searchQuery = '',
    this.isSearching = false,
    this.totalCount = 0,
  });

  ExpensesPaginationState copyWith({
    int? currentPage,
    List<Data>? expenses,
    bool? isLoading,
    bool? hasNextPage,
    String? errorMessage,
    String? searchQuery,
    bool? isSearching,
    int? totalCount,
  }) {
    return ExpensesPaginationState(
      currentPage: currentPage ?? this.currentPage,
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  List<Data> get filteredExpenses {
    if (searchQuery.isEmpty) return expenses;

    return expenses.where((expense) {
      final ref = expense.reference?.toString().toLowerCase() ?? '';
      final vendor = expense.vendor?.toLowerCase() ?? '';
      final amount = expense.expenseAmount?.toString().toLowerCase() ?? '';

      return ref.contains(searchQuery.toLowerCase()) ||
          vendor.contains(searchQuery.toLowerCase()) ||
          amount.contains(searchQuery.toLowerCase());
    }).toList();
  }
}

class ExpensesPaginationNotifier
    extends StateNotifier<ExpensesPaginationState> {
  final Ref _ref;
  static const int _pageSize = 15;
  bool _isLoadingMore = false;

  ExpensesPaginationNotifier(this._ref) : super(ExpensesPaginationState()) {
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final params = {
        "pageNo": 0,
        "rowPerPage": _pageSize,
        "requestCriteria": {"reference": ""},
        "sortingCriteria": {}
      };

      developer.log('FETCHING INITIAL EXPENSES - Page 0',
          name: 'ExpensesPagination');

      final result =
          await _ref.read(getExpenseDataWithPagination(params).future);

      final expenses = result.response?.data ?? [];
      final totalCount = result.response?.totalRecord?.toInt() ?? 0;

      developer.log('RECEIVED ${expenses.length} EXPENSES (Total: $totalCount)',
          name: 'ExpensesPagination');

      state = state.copyWith(
        expenses: expenses,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: expenses.length < totalCount,
        isLoading: false,
      );

      if (expenses.isNotEmpty) {
        _ref
            .read(expensesSelectionProvider.notifier)
            .updateSelectionSize(expenses.length);
      }
    } catch (error) {
      developer.log('ERROR FETCHING EXPENSES: $error',
          name: 'ExpensesPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> loadMoreExpenses() async {
    if (_isLoadingMore ||
        state.isLoading ||
        !state.hasNextPage ||
        state.searchQuery.isNotEmpty) {
      return;
    }

    if (state.expenses.length >= state.totalCount) {
      state = state.copyWith(hasNextPage: false);
      return;
    }

    _isLoadingMore = true;
    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;

      developer.log('LOADING MORE EXPENSES - Page $nextPage',
          name: 'ExpensesPagination');

      final params = {
        "pageNo": nextPage,
        "rowPerPage": _pageSize,
        "requestCriteria": {"reference": ""},
        "sortingCriteria": {}
      };

      final result =
          await _ref.read(getExpenseDataWithPagination(params).future);

      final newExpenses = result.response?.data ?? [];
      final totalCount =
          result.response?.totalRecord?.toInt() ?? state.totalCount;

      final Set<int> existingIds =
          state.expenses.map((e) => e.expenseId?.toInt() ?? -1).toSet();
      final List<Data> allExpenses = [...state.expenses];
      int addedCount = 0;

      for (var newExpense in newExpenses) {
        if (!existingIds.contains(newExpense.expenseId?.toInt() ?? -1)) {
          allExpenses.add(newExpense);
          existingIds.add(newExpense.expenseId?.toInt() ?? -1);
          addedCount++;
        }
      }

      final hasMore = allExpenses.length < totalCount;

      state = state.copyWith(
        expenses: allExpenses,
        currentPage: nextPage,
        totalCount: totalCount,
        hasNextPage: hasMore,
        isLoading: false,
      );

      _ref
          .read(expensesSelectionProvider.notifier)
          .updateSelectionSize(allExpenses.length);

      developer.log(
          'ADDED $addedCount NEW EXPENSES. Has more: $hasMore. Total: ${allExpenses.length}/$totalCount',
          name: 'ExpensesPagination');
    } catch (error) {
      developer.log('ERROR LOADING MORE EXPENSES: $error',
          name: 'ExpensesPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> setSearchQuery(String query) async {
    developer.log('SETTING SEARCH QUERY: "$query"', name: 'ExpensesPagination');

    if (query.isEmpty) {
      state = state.copyWith(searchQuery: '', isSearching: false);
      await fetchExpenses();
      return;
    }

    state = state.copyWith(
      searchQuery: query,
      isSearching: true,
      isLoading: true,
    );

    try {
      final params = {
        "pageNo": 0,
        "rowPerPage": 100,
        "requestCriteria": {"reference": query},
        "sortingCriteria": {}
      };

      final result =
          await _ref.read(getExpenseDataWithPagination(params).future);

      final expenses = result.response?.data ?? [];
      final totalCount = result.response?.totalRecord?.toInt() ?? 0;

      state = state.copyWith(
        expenses: expenses,
        currentPage: 0,
        totalCount: totalCount,
        hasNextPage: false,
        isLoading: false,
        isSearching: false,
      );

      if (expenses.isNotEmpty) {
        _ref
            .read(expensesSelectionProvider.notifier)
            .updateSelectionSize(expenses.length);
      }

      developer.log(
          'SEARCH COMPLETED: Found ${expenses.length} matching "$query"',
          name: 'ExpensesPagination');
    } catch (error) {
      developer.log('ERROR SEARCHING EXPENSES: $error',
          name: 'ExpensesPagination', error: error);
      state = state.copyWith(
        isLoading: false,
        isSearching: false,
        errorMessage: error.toString(),
      );
    }
  }

  // void refresh() {
  //   developer.log('REFRESHING EXPENSES AND CLEARING SEARCH', name: 'ExpensesPagination');
  //   state = state.copyWith(searchQuery: '');
  //   fetchExpenses();
  // }

  Future<void> refresh() async {
    // ✅ Make it async
    developer.log('REFRESHING EXPENSES AND CLEARING SEARCH',
        name: 'ExpensesPagination');
    state = state.copyWith(searchQuery: '', isSearching: false);
    await fetchExpenses(); // ✅ Add await
  }
}
