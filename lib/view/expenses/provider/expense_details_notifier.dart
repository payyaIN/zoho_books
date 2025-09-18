import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/model/expense_detail_model.dart';
import 'package:payzo_books/view/expenses/model/get_expense_list_model.dart';

/// Notifier for handling selected expense list item
class ExpenseDetailsNotifier extends StateNotifier<GetExpenseListModel?> {
  ExpenseDetailsNotifier() : super(null);

  void select(GetExpenseListModel expense) {
    state = expense;
  }

  void clear() {
    state = null;
  }
}

/// Holds the selected expense from the list
final expenseSelectionProvider =
StateNotifierProvider<ExpenseDetailsNotifier, GetExpenseListModel?>(
      (ref) => ExpenseDetailsNotifier(),
);

/// Holds detailed data for a specific expense (from expense detail API)
final selectedExpenseDetailProvider =
StateProvider<ExpenseDetailModel?>((ref) => null);

/// Helper to set selected detailed expense data
void setSelectedExpenseDetail(
    WidgetRef ref, ExpenseDetailModel expenseDetail) {
  ref.read(selectedExpenseDetailProvider.notifier).state = expenseDetail;
}

/// Helper to retrieve the currently selected detailed expense
ExpenseDetailModel? getSelectedExpenseDetail(WidgetRef ref) {
  return ref.read(selectedExpenseDetailProvider);
}

/// Extracts the first valid item from the selected expense list model (if available)
final specificExpenseProvider =
Provider.family<GetExpenseListModel?, GetExpenseListModel?>(
      (ref, model) {
    final data = model?.response?.data;
    if (data == null || data.isEmpty) return null;
    return model;
  },
);
