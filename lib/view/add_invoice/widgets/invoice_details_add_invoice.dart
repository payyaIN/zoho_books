import 'package:intl/intl.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/shipping_method_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_bank_account_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_customer_list_repo.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import 'package:payzo_books/view/add_invoice/notifier/add_invoice_form_notifier.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import '../../../import_data.dart';
import '../../../utils/focus_utility/focus_utility.dart';

class InvoiceDetailsAddInvoice extends ConsumerStatefulWidget {
  final List<TextEditingController> controller;

  const InvoiceDetailsAddInvoice({super.key,required this.controller, });

  @override
  ConsumerState<InvoiceDetailsAddInvoice> createState() =>
      _InvoiceDetailsAddInvoiceState();
}

class _InvoiceDetailsAddInvoiceState
    extends ConsumerState<InvoiceDetailsAddInvoice> {
  late final TextEditingController paymentTermsController;
  late final TextEditingController customerNotesController;
  late final TextEditingController termsAndConditionsController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(invoiceFormProvider);
    customerNotesController = widget.controller[2];
    termsAndConditionsController = widget.controller[3];
    paymentTermsController = widget.controller[4];

    paymentTermsController.addListener(() {
      ref
          .read(invoiceFormProvider.notifier)
          .updateField('paymentTerms', paymentTermsController.text);
    });

    customerNotesController.addListener(() {
      ref
          .read(invoiceFormProvider.notifier)
          .updateField('customerNotes', customerNotesController.text);
    });

    termsAndConditionsController.addListener(() {
      ref
          .read(invoiceFormProvider.notifier)
          .updateField('terms', termsAndConditionsController.text);
    });

    // 👇 Preload all required APIs
    Future.microtask(() async {
      ref.read(fetchCustomerListProvider.future);
      ref.read(fetchBranchListProvider.future);
      ref.read(fetchShippingMethodsProvider.future);
      ref.read(fetchBankAccountListProvider.future);
      ref.read(fetchPriceCurrencyProvider.future);

      ref.read(invoiceFormProvider.notifier).updateField('invoiceDate', DateTime.now());
      ref.read(invoiceFormProvider.notifier).updateField('expiryDate', DateTime.now());
      ref.read(invoiceFormProvider.notifier).updateField('supplyDate', DateTime.now());

      final notifier = ref.read(invoiceFormProvider.notifier);

      // 🚚 Set default shipping method "Land Freight"
      final shippingMethods = await ref.read(fetchShippingMethodsProvider.future);
      final landFreight = shippingMethods.firstWhere(
            (method) => method.shpmName == "Land Freight",
        orElse: () => shippingMethods.first,
      );
      notifier.updateField('shippingMethod', landFreight.shpmName ?? '');
      notifier.updateField('shippingMethodId', landFreight.shpmId);

      // 💵 Set default price currency "SAR"
      final currencyList = await ref.read(fetchPriceCurrencyProvider.future);
      final sarCurrency = currencyList.firstWhere(
            (currency) => currency.currencyValue == "SAR",
        orElse: () => currencyList.first,
      );
      notifier.updateField('currency', sarCurrency.currencyValue ?? '');
      notifier.updateField('currencyId', sarCurrency.currencyId); // ✅ Important for backend payload
    });
  }

  @override
  void dispose() {
    paymentTermsController.dispose();
    customerNotesController.dispose();
    termsAndConditionsController.dispose();
    widget.controller[0].dispose();
    widget.controller[1].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceFormProvider);
    final notifier = ref.read(invoiceFormProvider.notifier);

    return ScalingFactor(
      child: CustomExpansionTile(
        title: 'Invoice Details',
        isExpanded: true,
        onToggle: () {},
        height: 2,
        child: ReusableColumn(children: [
          PayzoBottomsheetNavigator(
            required: true,
            isPayzoColor: true,
            title: 'Customer Name',
            trailing: state.customerName ?? '',
            errorText: state.errors['customerName'],
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              // 👇 Prefetch the data before showing the bottom sheet
              final customerAsync =
                  await ref.read(fetchCustomerListProvider.future);

              final customerNames = customerAsync
                  .map((e) => e.displayName ?? '')
                  .where((e) => e.isNotEmpty)
                  .toSet()
                  .toList();

              // 👇 Open bottom sheet with prefetched data (very fast now)
              if (context.mounted) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ReusableCountryBottomSheet(
                    title: 'Customer',
                    items: customerNames,
                    onSelect: (selectedName) {
                      final selectedCustomer = customerAsync.firstWhere(
                        (e) => e.displayName == selectedName,
                        orElse: () => customerAsync.first,
                      );

                      if (selectedCustomer.displayName != null) {
                        notifier.updateField(
                            'customerName', selectedCustomer.displayName!);
                        notifier.updateField(
                            'customerId', selectedCustomer.partyId!);
                      }
                    },
                  ),
                );
              }
            },
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            required: true,
            title: 'Branch',
            isPayzoColor: true,
            trailing: state.branch ?? '',
            errorText: state.errors['branch'],
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Consumer(
                    builder: (context, ref, _) {
                      final branchAsync = ref.watch(fetchBranchListProvider);

                      return branchAsync.when(
                        data: (data) {
                          final branches = data.data
                                  ?.map((b) => b.namePrimary ?? '')
                                  .where((name) => name.isNotEmpty)
                                  .toList() ??
                              [];

                          return ReusableCountryBottomSheet(
                            title: 'Select Branch',
                            items: branches,
                            onSelect: (selectedName) {
                              final selectedBranch = data.data?.firstWhere(
                                (b) => b.namePrimary == selectedName,
                                orElse: () => data.data!.first,
                              );

                              if (selectedBranch != null) {
                                final notifier =
                                    ref.read(invoiceFormProvider.notifier);
                                notifier.updateField(
                                    'branch', selectedBranch.namePrimary ?? '');
                                notifier.updateField('branchId',
                                    selectedBranch.branchId); // ✅ Set branchId
                                debugPrint(
                                    '✅ Selected Branch ID: ${selectedBranch.branchId}');
                              }
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(
                            child: Text('Failed to load branches: $err')),
                      );
                    },
                  );
                },
              );
            },
          ),
          PayzoInputField(
            controller: widget.controller[0],
            required: true,
            keyboardType: TextInputType.numberWithOptions(),
            inputFormatters: PayzoInputFormatters.onlyDigits,
            label: 'Invoice Reference Number',
            initialValue: state.invoiceRefNo,
            errorText: state.errors['invoiceRefNo'],
            onChanged: (val) => notifier.updateField('invoiceRefNo', val),
          ),
          PayzoInputField(
            controller: widget.controller[1],
            inputFormatters: PayzoInputFormatters.onlyDigits,
            keyboardType: TextInputType.numberWithOptions(),
            label: 'Order Number',
            initialValue: state.orderNo,
            onChanged: (val) => notifier.updateField('orderNo', val),
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            enabled: false,
            required: true,
            errorText: state.errors['invoiceDate'],
            title: 'Invoice Date',
            trailing: formatDate(state.invoiceDate ?? DateTime.now()),
            isPayzoColor: true,
            onTap: () async {},
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            required: true,
            errorText: state.errors['expiryDate'],
            title: 'Expiry Date',
            trailing: formatDate(state.expiryDate ?? DateTime.now()),
            isPayzoColor: true,
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              final selected = await pickDate(context);
              if (selected != null) {
                notifier.updateField('expiryDate', selected);
              }
            },
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            required: true,
            isPayzoColor: true,
            errorText: state.errors['supplyDate'],
            title: 'Invoice Supply Date',
            trailing: formatDate(state.supplyDate ?? DateTime.now()),
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();

              final selected = await pickDate(context);
              if (selected != null) {
                notifier.updateField('supplyDate', selected);
              }
            },
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            required: true,
            isPayzoColor: true,
            errorText: state.errors['shippingMethod'],
            title: 'Shipping Method',
            trailing: state.shippingMethod??'Tap to select',
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Consumer(
                    builder: (context, ref, _) {
                      final shippingAsync =
                          ref.watch(fetchShippingMethodsProvider);

                      return shippingAsync.when(
                        data: (shippingList) {
                          final methods = shippingList
                              .map((method) => method.shpmName ?? '')
                              .where((name) => name.isNotEmpty)
                              .toList();

                          return ReusableCountryBottomSheet(
                            title: 'Select Shipping Method',
                            items: methods,
                            onSelect: (selectedMethod) {
                              final selected = shippingList.firstWhere(
                                (element) => element.shpmName == selectedMethod,
                                orElse: () => shippingList.first,
                              );

                              ref
                                  .read(invoiceFormProvider
                                      .notifier) // ✅ Use invoice provider
                                  .updateField('shippingMethod',
                                      selected.shpmName ?? '');
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) {
                          debugPrint("❌ Error loading shipping methods: $err");
                          return Center(
                              child:
                                  Text('Error loading shipping methods: $err'));
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            required: true,
            isPayzoColor: true,
            title: 'Select Bank Account',
            trailing: state.bankAccount ?? 'Tap to Select',
            errorText: state.errors['bankAccount'],
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Consumer(
                    builder: (context, ref, _) {
                      final accountAsync =
                          ref.watch(fetchBankAccountListProvider);

                      return accountAsync.when(
                        data: (bankAccounts) {
                          final accountNames = bankAccounts
                              .map((e) => e.accountName ?? '')
                              .where((name) => name.isNotEmpty)
                              .toList();

                          return ReusableCountryBottomSheet(
                            title: 'Select Bank Account',
                            items: accountNames,
                            onSelect: (selectedName) {
                              final selectedAccount = bankAccounts.firstWhere(
                                (e) => e.accountName == selectedName,
                                orElse: () => bankAccounts.first,
                              );

                              ref
                                  .read(invoiceFormProvider.notifier)
                                  .updateField('bankAccount',
                                      selectedAccount.accountName ?? '');
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(
                            child: Text('Error loading bank accounts: $err')),
                      );
                    },
                  );
                },
              );
            },
          ),
          ReusableSizedBox(height: 10),
          PayzoBottomsheetNavigator(
            required: true,
            title: 'Price Currency',
            trailing: state.currency ?? 'Tap to Select',
            errorText: state.errors['currency'],
            isPayzoColor: true,
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Consumer(
                    builder: (context, ref, _) {
                      final currencyAsync =
                          ref.watch(fetchPriceCurrencyProvider);

                      return currencyAsync.when(
                        data: (currencyList) {
                          final currencyNames = currencyList
                              .map((e) => e.currencyValue ?? '')
                              .where((e) => e.isNotEmpty)
                              .toList();

                          return ReusableCountryBottomSheet(
                            title: 'Select Currency',
                            items: currencyNames,
                            onSelect: (selectedCurrency) {
                              final selected = currencyList.firstWhere(
                                (element) =>
                                    element.currencyValue == selectedCurrency,
                                orElse: () => currencyList.first,
                              );

                              ref
                                  .read(invoiceFormProvider.notifier)
                                  .updateField(
                                      'currency', selected.currencyValue ?? '');
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(
                            child: Text('Error loading currency list: $err')),
                      );
                    },
                  );
                },
              );
              // Optional: fallback default currency
              notifier.updateField('currency', 'INR');
            },
          ),
          ReusableSizedBox(height: 10),
          CustomDescriptionField(
              // errorText: state.errors['paymentTerms'],
              // required: true,
              title: 'Payment Terms',
              controller: paymentTermsController),
          ReusableSizedBox(height: 15),
          CustomDescriptionField(
              // errorText: state.errors['customerNotes'],
              // required: true,
              title: 'Customer Notes',
              controller: customerNotesController),
          ReusableSizedBox(height: 15),
          CustomDescriptionField(
              // errorText: state.errors['terms'],
              // required: true,
              title: 'Terms and Conditions',
              controller: termsAndConditionsController),
          ReusableSizedBox(height: 15),
        ]),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Tap to Select';
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );
  }
}
