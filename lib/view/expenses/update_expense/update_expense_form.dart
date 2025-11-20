import 'package:payzo_books/utils/app_data/input_formatters.dart';
import '../../../../import_data.dart';

class UpdateExpenseForm extends ConsumerStatefulWidget {
  const UpdateExpenseForm({super.key});

  @override
  ConsumerState<UpdateExpenseForm> createState() => _UpdateExpenseFormState();
}

class _UpdateExpenseFormState extends ConsumerState<UpdateExpenseForm> {
  late final TextEditingController _amountController;
  late final VoidCallback _amountListener;

  @override
  void initState() {
    super.initState();
    // read the controller from provider (provider owns its lifecycle)
    _amountController = ref.read(amountControllerProvider);

    _amountListener = () {
      // schedule after frame to avoid provider modifications during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // calculateTotal will update subtotal, tax and total providers
        ref.read(addExpenseProvider.notifier).calculateTotal(context, ref);
      });
    };

    _amountController.addListener(_amountListener);
  }

  @override
  void dispose() {
    // remove listener but do NOT dispose controller if the provider owns it
    _amountController.removeListener(_amountListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amountController = ref.watch(amountControllerProvider);
    final referenceController = ref.watch(referenceControllerProvider);
    final expenseInfoController = ref.watch(expenseInfoControllerProvider);
    final notesController = ref.watch(notesControllerProvider);
    final product = ref.watch(productTypeProvider);
    final notifier = ref.read(productTypeProvider.notifier);

    return CustomExpansionTile(
      height: 20,
      title: 'Expense Details',
      isExpanded: true,
      onToggle: () {},
      child: ReusableColumn(
        children: [
          PayzoBottomsheetNavigator(
            onUnselect: () {
              ref.invalidate(branchProvider);
            },
            title: 'Branch',
            trailing: ref.watch(branchProvider) ?? 'Tap to Select',
            onTap: () {
              ref
                  .read(addExpenseProvider.notifier)
                  .showBranchSelector(context, ref);
            },
            required: true,
            isPayzoColor: true,
            errorText: ref.watch(branchErrorProvider),
          ),
          PayzoBottomsheetNavigator(
            title: 'Date',
            trailing: ref
                .read(addExpenseProvider.notifier)
                .formatDate(ref.watch(dateProvider)),
            onTap: () async {
              ref
                  .read(addExpenseProvider.notifier)
                  .showDatePickerAndSet(context);
            },
            required: true,
            isPayzoColor: true,
            errorText: ref.watch(dateErrorProvider),
          ),
          PayzoBottomsheetNavigator(
            onUnselect: () {
              ref.invalidate(expenseAccountProvider);
            },
            title: 'Expense Account',
            trailing: ref.watch(expenseAccountProvider) ?? 'Tap to Select',
            onTap: () => ref
                .read(addExpenseProvider.notifier)
                .showExpenseAccountSelector(context, ref),
            required: true,
            isPayzoColor: true,
            errorText: ref.watch(expenseAccountErrorProvider),
          ),

          // AMOUNT FIELD (no onChanged needed; listener updates totals)
          PayzoInputField(
            label: 'Amount',
            inputFormatters: PayzoInputFormatters.onlyDecimalNumbers,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            required: true,
            controller: amountController,
            errorText: ref.watch(amountErrorProvider),
            leading: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => ref
                    .read(addExpenseProvider.notifier)
                    .showCurrencySelector(context, ref),
                child: ReusableSizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      ReusableText(
                        color: AppColors.appMainColor,
                        text: ref.watch(expenseCurrencyProvider) ?? 'SAR',
                      ),
                      const ReusableSizedBox(width: 10),
                      const ReusableText(text: '|'),
                      const ReusableSizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            ),
          ),

          PayzoBottomsheetNavigator(
            onUnselect: () {
              ref.invalidate(paidThroughProvider);
            },
            title: 'Paid Through',
            trailing: ref.watch(paidThroughProvider) ?? 'Tap to Select',
            onTap: () => ref
                .read(addExpenseProvider.notifier)
                .showPaidThroughSelector(context, ref),
            required: true,
            isPayzoColor: true,
            errorText: ref.watch(paidThroughErrorProvider),
          ),
          PayzoBottomsheetNavigator(
            onUnselect: () {
              ref.invalidate(vendorProvider);
            },
            title: 'Vendor',
            trailing: ref.watch(vendorProvider) ?? 'Tap to Select',
            onTap: () => ref
                .read(addExpenseProvider.notifier)
                .showVendorSelector(context, ref),
            isPayzoColor: true,
          ),
          PayzoBottomsheetNavigator(
            onUnselect: () {
              ref.invalidate(taxProvider);
            },
            title: 'Tax',
            trailing: ref.watch(taxProvider) ?? 'Tap to Select',
            onTap: () {
              ref
                  .read(addExpenseProvider.notifier)
                  .showTaxSelector(context, ref);
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
            onUnselect: () {
              ref.invalidate(customerProvider);
              ref.read(customerProvider.notifier).state = 'Tap to Select';
            },
            title: 'Customer',
            trailing: ref.watch(customerProvider) ?? 'Tap to Select',
            onTap: () => ref
                .read(addExpenseProvider.notifier)
                .showCustomerSelector(context, ref),
            isPayzoColor: true,
          ),
          PayzoInputField(
            keyboardType: TextInputType.text,
            inputFormatters: PayzoInputFormatters.onlyAlphabets,
            label: 'Expense Info',
            controller: expenseInfoController,
          ),
          const ReusableSizedBox(height: 10),
          FormRadioButton(
            value: 'Claimable',
            groupValue: product.type,
            title: 'Claimable',
            onChanged: (val) {
              notifier.updateRadio('type', val!);
              notifier.updateField('isClaimable', val == 'Claimable');
            },
          ),
          const ReusableSizedBox(height: 10),
          FormRadioButton(
            value: 'Non-claimable',
            groupValue: product.type,
            title: 'Non-claimable',
            onChanged: (val) {
              notifier.updateRadio('type', val!);
              notifier.updateField('isClaimable', val == 'Claimable');
            },
          ),
          const ReusableSizedBox(height: 10),
          CustomDescriptionField(
            title: 'Notes',
            controller: notesController,
          ),
        ],
      ),
    );
  }
}
