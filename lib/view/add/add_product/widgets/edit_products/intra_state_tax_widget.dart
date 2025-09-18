import 'package:payzo_books/import_data.dart';

class IntraStateTaxWidget extends StatelessWidget {
  const IntraStateTaxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
        child: FormContainer(
          height: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 18,bottom: 18,left: 15,right: 15),
            child: ReusableColumn(
              children: [
                PayzoBottomsheetNavigator(
                      title: 'Intra State Tax Rate',
                      trailing: 'GST18 [18%]',
                      onTap: () {},
                    ),
                ReusableSizedBox(
                  height: 5,
                ),
                PayzoBottomsheetNavigator(
                      title: 'State',
                      trailing: 'GST18 [18%]',
                      divider: false,
                      onTap: () {},
                    ),
              ],
            ),
          ),
        ));
  }
}
