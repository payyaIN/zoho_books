import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/widgets/expense_appbar.dart';
import 'package:payzo_books/view/expenses/widgets/expense_body_data.dart';
import 'package:payzo_books/view/expenses/widgets/expense_fab_button.dart';
import 'package:payzo_books/view/expenses/widgets/expense_search_data.dart';
import 'package:payzo_books/view/expenses/widgets/expenses_checkbox_btn.dart';
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
        appBar: expensesAppBar(
          context: context,
          ref: ref,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(),
                ExpensesSearchData(),
                ExpensesBodyData(),
              ],
            ),
            ExpensesCheckBoxSection(),
          ],
        ),
        floatingActionButton: expensesFABBtn(
          context: context,
          ref: ref,
        ),
      ),
    );
  }
}
