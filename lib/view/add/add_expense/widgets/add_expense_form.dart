import 'package:payzo_books/utils/app_data/input_formatters.dart';

import '../../../../import_data.dart';
class AddExpenseForm extends ConsumerWidget {
  const AddExpenseForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountController = ref.watch(amountControllerProvider);
    final referenceController = ref.watch(referenceControllerProvider);
    final notesController = ref.watch(notesControllerProvider);

    return CustomExpansionTile(
      height: 20,
      title: 'Expense Details',
      isExpanded: true,
      onToggle: () {},
      child: ReusableColumn(
        children: [
          PayzoBottomsheetNavigator(
            title: 'Branch',
            trailing: ref.watch(branchProvider) ?? 'Tap to select',
            onTap: () {
              ref.read(addExpenseProvider.notifier).showBranchSelector(context, ref);
            },
            required: true,
            isPayzoColor: true,
            errorText: ref.watch(branchErrorProvider),
          ),
          PayzoBottomsheetNavigator(
            title: 'Date',
            trailing: ref.read(addExpenseProvider.notifier).formatDate(ref.watch(dateProvider)),
            onTap: () async {
              ref.read(addExpenseProvider.notifier).showDatePickerAndSet(context);
            },
            required: true,
            isPayzoColor: true,
            errorText: ref.watch(dateErrorProvider),
          ),
          PayzoBottomsheetNavigator(
            title: 'Expense Account',
            trailing: ref.watch(expenseAccountProvider) ?? 'Tap to select',
            onTap: () =>
                ref.read(addExpenseProvider.notifier).showExpenseAccountSelector(context, ref),
            required: true,
            isPayzoColor: true,
            errorText: ref.watch(expenseAccountErrorProvider),
          ),
          PayzoInputField(
            label: 'Amount',
            inputFormatters: PayzoInputFormatters.onlyDecimalNumbers,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true
            ),
            required: true,
            controller: amountController,
            errorText: ref.watch(amountErrorProvider),
            leading: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => ref.read(addExpenseProvider.notifier).showCurrencySelector(context, ref),
                child: ReusableSizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      ReusableText(
                        color: AppColors.appMainColor,
                        text: ref.watch(expenseCurrencyProvider) ?? 'SAR',
                      ),
                      ReusableSizedBox(width: 10),
                      ReusableText(text: '|'),
                      ReusableSizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            ),
          ),
          PayzoBottomsheetNavigator(
            title: 'Paid Through',
            trailing: ref.watch(paidThroughProvider) ?? 'Tap to select',
            onTap: () => ref.read(addExpenseProvider.notifier).showPaidThroughSelector(context, ref),
            required: true,
            isPayzoColor: true,
            errorText: ref.watch(paidThroughErrorProvider),
          ),
          PayzoBottomsheetNavigator(
            title: 'Vendor',
            trailing: ref.watch(vendorProvider) ?? 'Tap to select',
            onTap: () => ref.read(addExpenseProvider.notifier).showVendorSelector(context, ref),
            isPayzoColor: true,
          ),
          PayzoBottomsheetNavigator(
            title: 'Tax',
            trailing: ref.watch(taxProvider) ?? 'Tap to select',
            onTap: () {
              ref.read(addExpenseProvider.notifier).showTaxSelector(context, ref);
            },
            isPayzoColor: true,
          ),
          if (ref.watch(showExemptionReasonProvider))
            PayzoInputField(
              label: 'Exemption Reason',
              controller: ref.watch(expensesExemptionReasonControllerProvider),
            ),
          PayzoInputField(
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            inputFormatters: PayzoInputFormatters.onlyDigits,
            label: 'Reference',
            controller: referenceController,
          ),
          PayzoBottomsheetNavigator(
            title: 'Customer',
            trailing: ref.watch(customerProvider) ?? 'Tap to select',
            onTap: () => ref.read(addExpenseProvider.notifier).showCustomerSelector(context, ref),
            isPayzoColor: true,
          ),
          CustomDescriptionField(
            title: 'Notes',
            controller: notesController,
          ),
        ],
      ),
    );
  }
}
