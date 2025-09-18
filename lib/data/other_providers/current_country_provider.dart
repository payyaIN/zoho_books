import 'package:payzo_books/data/models/current_country.dart/current_country_model.dart';
import 'package:payzo_books/import_data.dart';

class CurrentCountryNotifier extends StateNotifier<GetCurrentCountryModel?> {
  CurrentCountryNotifier() : super(null);

  void setCurrentCountryData(GetCurrentCountryModel countryModel) {
    state = countryModel;
  }

  void clearCurrentCountryData() {
    state = null;
  }
}

final currentCountryProvider =
    StateNotifierProvider<CurrentCountryNotifier, GetCurrentCountryModel?>(
        (ref) {
  return CurrentCountryNotifier();
});

final countryDetailsProvider = Provider<Map<String, dynamic>?>((ref) {
  final currentCountry = ref.watch(currentCountryProvider);

  if (currentCountry == null) return null;

  return {
    "countryCode": currentCountry.countryCode,
  };
});
