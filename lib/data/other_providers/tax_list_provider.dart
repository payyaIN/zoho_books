import 'package:payzo_books/data/models/tax/tax_list_model.dart';
import 'package:payzo_books/import_data.dart';

class SpecificTaxNotifier extends StateNotifier<GetTaxListModel?> {
  SpecificTaxNotifier() : super(null);

  void setTaxData(GetTaxListModel taxModel) {
    state = taxModel;
  }

  void clearTaxData() {
    state = null;
  }
}

final specificTaxProvider =
    StateNotifierProvider<SpecificTaxNotifier, GetTaxListModel?>((ref) {
  return SpecificTaxNotifier();
});

final selectedIGSTTaxProvider = StateProvider<IGSTTax?>((ref) => null);

void setSelectedIGSTTax(WidgetRef ref, IGSTTax tax) {
  ref.read(selectedIGSTTaxProvider.notifier).state = tax;
}

IGSTTax? getSelectedIGSTTax(WidgetRef ref) {
  return ref.read(selectedIGSTTaxProvider);
}

final activeIGSTTaxesProvider =
    Provider.family<List<IGSTTax>, GetTaxListModel?>((ref, model) {
  if (model == null || model.response.igstTax.isEmpty) {
    return [];
  }

  return model.response.igstTax.where((tax) => tax.tcdAtive == 1).toList();
});
