import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/model/expenses_fn_provider.dart';

PreferredSizeWidget expensesAppBar({
  required BuildContext context,
  required WidgetRef ref,
}) {
  final expensesSelectionState = ref.watch(expensesSelectionProvider);
  final expensesSelectionNotifier = ref.read(expensesSelectionProvider.notifier);

  return reusableAppBarWithSuffixWidget(
    context: context,
    showTitle: true,
    showBackButton: true,
    isSuffixText: true,
    title: 'Expenses',
    suffixText: expensesSelectionState.isSelectionMode
        ? AppText.cancel
        : AppText.select,
    onSuffixTap: () {
      expensesSelectionNotifier.toggleSelectionMode();
    },
  );
}
