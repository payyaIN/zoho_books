import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/main_screen/notifiers/dashboard_notifier.dart';

class CashFlowDetails extends ConsumerWidget {
  const CashFlowDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(getCashFlowDetailsAmount);
    return ReusableContainer(
      height: 192,
      width: 345,
      color: const Color(0xFFEEEEEE),
      padding: const EdgeInsets.only(left: 10, right: 10),
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          CashFlowDetailsLIist(
            color: Color(0xFF212121),
            text: 'Cash as on 01/04/2024',
            price: data.when(
                data: (data) {
                  return ReusableText(
                    text: 'SAR ${data.response.periodEndingBalance.balance}',
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
            color: Color(0xFF009725),
            text: 'Incoming',
            price: data.when(
                data: (data) {
                  return ReusableText(
                    text: 'SAR ${data.response.periodEndingBalance.balance}',
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
            text: 'Outgoing',
            price: data.when(
                data: (data) {
                  return ReusableText(
                    text: 'SAR ${data.response.periodEndingBalance.balance}',
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
            color: Color(0xFF5F00DD),
            text: 'Cash as on 31/03/2025',
            price: data.when(
                data: (data) {
                  return ReusableText(
                    text: 'SAR ${data.response.periodEndingBalance.balance}',
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
