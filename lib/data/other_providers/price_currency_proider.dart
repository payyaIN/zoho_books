import 'package:payzo_books/data/models/price_currency_model/price_currency_model.dart';
import 'package:payzo_books/import_data.dart';

class CurrencyNotifier extends StateNotifier<PriceCurrencyModel?> {
  CurrencyNotifier() : super(null);

  void setCurrencyData(PriceCurrencyModel currencyModel) {
    state = currencyModel;
  }

  void clearCurrencyData() {
    state = null;
  }
}

final currencyProvider =
    StateNotifierProvider<CurrencyNotifier, PriceCurrencyModel?>((ref) {
  return CurrencyNotifier();
});

final selectedCurrencyProvider = StateProvider<CurrencyItem?>((ref) => null);

void setSelectedCurrency(WidgetRef ref, CurrencyItem currency) {
  ref.read(selectedCurrencyProvider.notifier).state = currency;
}

CurrencyItem? getSelectedCurrency(WidgetRef ref) {
  return ref.read(selectedCurrencyProvider);
}

final currencyByIdProvider =
    Provider.family<CurrencyItem?, int>((ref, currencyId) {
  final currencyModel = ref.watch(currencyProvider);
  if (currencyModel == null) return null;

  try {
    return currencyModel.currencies
        .firstWhere((currency) => currency.currencyId == currencyId);
  } catch (e) {
    print('Currency with ID $currencyId not found');
    return null;
  }
});

final currencyByValueProvider =
    Provider.family<CurrencyItem?, String>((ref, currencyValue) {
  final currencyModel = ref.watch(currencyProvider);
  if (currencyModel == null) return null;

  try {
    return currencyModel.currencies
        .firstWhere((currency) => currency.currencyValue == currencyValue);
  } catch (e) {
    print('Currency with value $currencyValue not found');
    return null;
  }
});
