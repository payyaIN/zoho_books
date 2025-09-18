import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/country_list/get_country_list_model.dart';
import 'package:payzo_books/data/repository/add_vendor/get_country_list_repository.dart';

import '../../../import_data.dart';

class CountryListNotifier
    extends StateNotifier<AsyncValue<GetCountryListModel?>> {
  final GetCountryListRepository _repository;

  CountryListNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchCountryList();
  }

  Future<void> fetchCountryList() async {
    try {
      state = const AsyncValue.loading();
      final result = await _repository.fetchData();
      state = AsyncValue.data(result);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final countryListProvider = StateNotifierProvider<CountryListNotifier,
    AsyncValue<GetCountryListModel?>>((ref) {
  final repository = ref.read(getCountryListProvider);
  return CountryListNotifier(repository);
});
