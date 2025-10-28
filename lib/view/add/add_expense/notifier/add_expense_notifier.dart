import 'package:payzo_books/view/add/add_expense/model/add_expense_product_type_model.dart';

import '../../../../import_data.dart';
class AddExpenseProductTypeNotifier extends StateNotifier<AddExpenseProductTypeModel> {
  AddExpenseProductTypeNotifier()
      : super(
    AddExpenseProductTypeModel(
      type: 'Claimable',   // 👈 default value
      isClaimable: true,   // 👈 default bool
    ),
  );

  void updateRadio(String key, String val) {
    if (key == 'type') {
      final bool claimVal = val == 'Claimable';
      state = state.copyWith(type: val, isClaimable: claimVal);
    }
  }

  void updateField(String key, dynamic value) {
    if (key == 'isClaimable' && value is bool) {
      state = state.copyWith(isClaimable: value);
    }
    if (key == 'type' && value is String) {
      final bool claimVal = value == 'Claimable';
      state = state.copyWith(type: value, isClaimable: claimVal);
    }
  }
}
