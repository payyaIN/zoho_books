import '../../../../../import_data.dart';

class EditPurchaseSectionAddProduct extends StatelessWidget {
  const EditPurchaseSectionAddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = TextEditingController();
    TextEditingController purchaseRateController = TextEditingController(text: '0.00');
    return ScalingFactor(
        child: FormContainer(
            height: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 18, bottom: 18, left: 15, right: 15),
              child: ReusableColumn(children: [
                CustomToggleTile(
                    title: 'Purchase Information',
                    value: true,
                    onChanged: (value) {},
                    divider: true),
                PayzoInputField(label: 'Purchase Rate',controller: purchaseRateController,),
                ReusableSizedBox(
                  height: 15,
                ),
                PayzoBottomsheetNavigator(
                  isPayzoColor: true,
                  title: 'Account',
                  trailing: 'Cost of goods sold',
                  onTap: () {},
                ),
                ReusableSizedBox(
                  height: 15,
                ),
                CustomDescriptionField(
                  title: 'Description',
                  controller: descriptionController,
                )
              ]),
            )));
  }
}
