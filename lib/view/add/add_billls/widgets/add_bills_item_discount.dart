import 'package:payzo_books/import_data.dart';
import '../../../../utils/app_data/input_formatters.dart';
import '../notifier/add_bill_form_notifier.dart';
import '../notifier/add_bill_providers.dart';

class AddBillItemDiscountField extends ConsumerWidget {
  const AddBillItemDiscountField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use item-level currency provider
    final selectedCurrency = ref.watch(addBillItemCurrencySelector) ?? 'SAR';

    return PayzoInputField(
      label: 'Discount',
      inputFormatters: PayzoInputFormatters.onlyDecimalNumbers,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      required: true,
      controller: controller,
      onChanged: (value) {
        // Print user input
        print("🧮 Typing Item Discount: $value");

        // Update AddBill form state (keeps existing behaviour)
        ref.read(addBillFormProvider.notifier).updateField('discount', value);
      },
      // errorText: ref.watch(addBillGlobalDiscountErrorProvider),
      leading: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          // call the item-level selector on the notifier
          onTap: () => ref
              .read(addBillFormProvider.notifier)
              .showAddBillItemCurrencySelector(context, ref),
          child: ReusableSizedBox(
            width: 50,
            child: Row(
              children: [
                ReusableText(
                  color: AppColors.appMainColor,
                  text: selectedCurrency,
                ),
                const ReusableSizedBox(width: 10),
                const ReusableText(text: '|'),
                const ReusableSizedBox(width: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
