import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/home_page/widgets/income_and_expenses/widgets/income_and_expense_details.dart';
import 'package:payzo_books/view/home_page/widgets/income_and_expenses/widgets/income_expence_chart.dart';

class IncomeAndExpensesWidget extends StatelessWidget {
  const IncomeAndExpensesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteContainer(
      child: ReusableColumn(
        children: <Widget>[
          HeadingTextPayzo(text: 'Income and Expenses'),
          ReusableSizedBox(height: 15),
          ReusableSizedBox(height: 15),
          IncomeExpenceChart(),
          ReusableSizedBox(height: 15),
          IncomeAndExpenseDetails(),
        ],
      ),
    );
  }
}
