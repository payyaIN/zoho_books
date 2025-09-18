import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../import_data.dart';

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});

class SearchState {
  final String query;
  final List<String> items;
  final List<String> filteredItems;

  SearchState({
    this.query = '',
    this.items = const [],
    this.filteredItems = const [],
  });

  SearchState copyWith({
    String? query,
    List<String>? items,
    List<String>? filteredItems,
  }) {
    return SearchState(
      query: query ?? this.query,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(SearchState());

  void updateSearchQuery(String query) {
    final filteredItems = state.items
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    state = state.copyWith(
      query: query,
      filteredItems: filteredItems,
    );
  }

  void setItems(List<String> items) {
    state = state.copyWith(
      items: items,
      filteredItems: items,
    );
  }

  void clearSearch() {
    state = state.copyWith(
      query: '',
      filteredItems: state.items,
    );
  }
}
