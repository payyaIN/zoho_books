import 'package:payzo_books/data/models/tax/all_tax_list_model.dart';
import 'package:payzo_books/import_data.dart';

class TaxNotifier extends StateNotifier<GetAllTaxListModel?> {
  TaxNotifier() : super(null);

  void setTaxList(GetAllTaxListModel taxListModel) {
    state = taxListModel;
  }

  void clearTaxList() {
    state = null;
  }
}

final taxListProvider =
    StateNotifierProvider<TaxNotifier, GetAllTaxListModel?>((ref) {
  return TaxNotifier();
});

final selectedTaxProvider = StateProvider<DefaultTax?>((ref) => null);

void setSelectedTax(WidgetRef ref, DefaultTax tax) {
  ref.read(selectedTaxProvider.notifier).state = tax;
}

DefaultTax? getSelectedTax(WidgetRef ref) {
  return ref.read(selectedTaxProvider);
}

final defaultTaxFilterProvider =
    Provider.family<List<DefaultTax>, GetAllTaxListModel?>((ref, model) {
  if (model == null) {
    return [];
  }
  return model.defaultTax;
});

final othersTaxFilterProvider =
    Provider.family<List<TaxItem>, GetAllTaxListModel?>((ref, model) {
  if (model == null) {
    return [];
  }
  return model.others;
});
