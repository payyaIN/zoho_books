import 'package:payzo_books/import_data.dart';
import '../../../../utils/app_data/input_formatters.dart';
import '../notifier/add_bill_form_notifier.dart';
import '../notifier/add_bill_providers.dart';

class GlobalDiscountField extends ConsumerWidget {
  const GlobalDiscountField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency =
        ref.watch(addBillGlobalDiscountCurrencyProvider) ?? 'SAR';

    return PayzoInputField(
      label: 'Discount',
      inputFormatters: PayzoInputFormatters.onlyDecimalNumbers,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      required: true,
      controller: controller,
      onChanged: (value) {
        // ✅ Print user input
        print("🧮 Typing Discount: $value");

        // ✅ (Optional) Update AddBill form state — if you want to store it
        ref.read(addBillFormProvider.notifier).updateField('discount', value);
      },
      // errorText: ref.watch(addBillGlobalDiscountErrorProvider),
      leading: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () => ref
              .read(addBillFormProvider.notifier)
              .showAddBillCurrencySelector(context, ref),
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
