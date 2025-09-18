import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/white_container.dart';

class BankingSummaryWidget extends StatelessWidget {
  const BankingSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteContainer(
      child: const ReusableColumn(
        children: <Widget>[
          HeadingTextPayzo(text: 'Banking Summary'),
          ReusableSizedBox(
            height: 15,
          ),
          GreyCard(
            width: 345,
            height: 289,
            borderRadius: 10,
            child: ReusableColumn(children: <Widget>[
              ReusableSizedBox(
                height: 15,
              ),
              BankingSummaryListTile(
                price: '₹-1,32,47,278.43',
                text: 'Bank Balance',
                image: 'assets/bank-svgrepo-com (1) 1.svg',
              ),
              ReusableSizedBox(
                height: 15,
              ),
              BankingSummaryListTile(
                price: '₹-1,32,47,278.43',
                text: 'Cash in Hand',
                image: 'assets/hand-holding-svgrepo-com 1.svg',
              ),
              ReusableSizedBox(
                height: 15,
              ),
              BankingSummaryListTile(
                price: '₹-1,32,47,278.43',
                text: 'Card Balance',
                image: 'assets/credit-card-02-svgrepo-com 1.svg',
              ),
              ReusableSizedBox(
                height: 15,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
