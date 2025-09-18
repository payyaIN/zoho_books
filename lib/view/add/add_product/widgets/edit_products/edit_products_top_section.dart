import '../../../../../import_data.dart';

class EditProductsTopSection extends ConsumerWidget {
  const EditProductsTopSection({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // final isTypeToggled = ref.watch(typeExpandedProvider);
    TextEditingController itemName=TextEditingController(text: 'Laptop asset purchase');
    return FormContainer(
        height: 2,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 0, left: 15, right: 15, bottom: 18),
          child: ReusableColumn(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableSizedBox(height: 18,),
              PayzoInputField(label: 'Item Name',controller:itemName,),
              ReusableSizedBox(
                height: 8,
              ),
              PayzoBottomsheetNavigator(
                title: 'Unit',
                onTap: () {},
                trailing: 'pcs',
              ),
              ExpansionToggleButtons(
                'Type',
                true,
                [
                  FormRadioButton(
                    value: 'goods',
                    groupValue: 'goods',
                    title: 'Goods',
                    onChanged: (_) {},
                  ),
                  SizedBox(height: 16),
                  FormRadioButton(
                    value: 'Service',
                    groupValue: 'goods',
                    title: 'Service',
                    onChanged: (_) {},
                  ),
                ],
                    (_) {
                  // ref.read(typeExpandedProvider.notifier).state =
                  // !isTypeToggled;
                },
              ),
              SizedBox(height: 8),
              PayzoDivider(),
              PayzoInputField(label: 'HSN Code'),
              SizedBox(height: 8),
              CustomToggleTile(title: 'Taxable', value: true, onChanged: (value) => false,divider: false,)
            ],
          ),
        ));
  }
}
