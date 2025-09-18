import 'package:payzo_books/import_data.dart';
class CashFlowWidget extends StatelessWidget {
  const CashFlowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteContainer(
      child: const ReusableColumn(
        children: <Widget>[
          HeadingTextPayzo(text: 'Cash Flow'),
          ReusableSizedBox(height: 15),
          ReusableSizedBox(height: 15),
          CashFlowChart(),
          ReusableSizedBox(height: 15),
          CashFlowDetails()
        ],
      ),
    );
  }
}
