import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/model/expenses_fn_provider.dart';

Widget expensesFABBtn({
  required BuildContext context,
  required WidgetRef ref,
}) {
  final expensesSelectionState = ref.watch(expensesSelectionProvider);

  return expensesSelectionState.isSelectionMode
      ? Transform.translate(
    offset: const Offset(0, -85),
    child: floatingActionBtn(
      onPress: () {
        Navigator.pushNamed(context, RouteNames.addExpense);
      },
    ),
  )
      : floatingActionBtn(
    onPress: () {
      Navigator.pushNamed(context, RouteNames.addExpense);
    },
  );
}
