import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/main_screen/notifiers/dashboard_notifier.dart';

class IncomeAndExpenseDetails extends ConsumerWidget {
  const IncomeAndExpenseDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(fetchIncomeAndExpenses);
    return ReusableContainer(
      color: const Color(0xFFEEEEEE),
      padding: const EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          CashFlowDetailsLIist(
            color: Color(0xFF009725),
            text: 'Income',
            price: data.when(
                data: (data) {
                  return ReusableText(
                    text: 'SAR ${data.response!.totalIncome}',
                    color: Color(0xFF0C0C0C),
                    fontSize: 14,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                  );
                },
                error: (err, _) {
                  print(_);
                  print('error is $err');
                  return SizedBox();
                },
                loading: () => ReusableSizedBox(
                    width: 10, height: 10, child: CircularProgressIndicator()
                )
            ),
            divider: true,
          ),
          CashFlowDetailsLIist(
            color: Color(0xFFC05300),
            text: 'Expense',
            price: data.when(
                data: (data) {
                  return ReusableText(
                    text: 'SAR ${data.response!.totalExpense}',
                    color: Color(0xFF0C0C0C),
                    fontSize: 14,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                  );
                },
                error: (err, _) {
                  print(_);
                  print('error is $err');
                  return SizedBox();
                },
                loading: () => ReusableSizedBox(
                    width: 10, height: 10, child: CircularProgressIndicator()
                )
            ),
            divider: false,
          ),
        ],
      ),
    );
  }
}
