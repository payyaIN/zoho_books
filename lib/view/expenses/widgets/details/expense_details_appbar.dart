import 'package:payzo_books/import_data.dart';

PreferredSizeWidget expenseDetailAppBar({required BuildContext context}) {
  return reusableAppBar(
    title: 'Expense Details',
    showBackButton: true,
    context: context,
  );
}
