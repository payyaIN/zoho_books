import 'package:payzo_books/data/models/tax/associated_tax_model.dart';
import 'package:payzo_books/import_data.dart';

class AssociateTaxNotifier extends StateNotifier<GetAssociateTaxModel?> {
  AssociateTaxNotifier() : super(null);

  void setAssociateTaxData(GetAssociateTaxModel taxModel) {
    state = taxModel;
  }

  void clearAssociateTaxData() {
    state = null;
  }
}

final associateTaxProvider =
    StateNotifierProvider<AssociateTaxNotifier, GetAssociateTaxModel?>((ref) {
  return AssociateTaxNotifier();
});

final selectedAssociateTaxProvider =
    StateProvider<AssociateTax?>((ref) => null);

void setSelectedAssociateTax(WidgetRef ref, AssociateTax tax) {
  ref.read(selectedAssociateTaxProvider.notifier).state = tax;
}

AssociateTax? getSelectedAssociateTax(WidgetRef ref) {
  return ref.read(selectedAssociateTaxProvider);
}

final activeAssociateTaxesProvider =
    Provider.family<List<AssociateTax>, GetAssociateTaxModel?>((ref, model) {
  if (model == null || model.response.taxes.isEmpty) {
    return [];
  }

  return model.response.taxes.where((tax) => tax.tcdAtive == 1).toList();
});
