import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/shipping_method_repository.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import 'package:intl/intl.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import '../../../../data/repository/add_bills/get_branch_list_repository.dart';
import '../../../../import_data.dart';

class BillDetailsAddBills extends ConsumerStatefulWidget {
  final List<TextEditingController> controller;
  const BillDetailsAddBills({super.key,required this.controller, });

  @override
  ConsumerState<BillDetailsAddBills> createState() =>
      _BillDetailsAddBillsState();
}

class _BillDetailsAddBillsState extends ConsumerState<BillDetailsAddBills> {
  late final TextEditingController customerNotesController;
  late final TextEditingController paymentTermsController;
  late final TextEditingController termsAndConditionsController;

  void clearControllers() {
    customerNotesController.clear();
    paymentTermsController.clear();
    termsAndConditionsController.clear();
  }

  @override
  void initState() {
    super.initState();
    final state = ref.read(addBillFormProvider);

    customerNotesController = widget.controller[2];
    termsAndConditionsController = widget.controller[3];
    paymentTermsController = widget.controller[4];

    paymentTermsController.addListener(() {
      ref
          .read(addBillFormProvider.notifier)
          .updateField('paymentTerms', paymentTermsController.text);
    });

    customerNotesController.addListener(() {
      ref
          .read(addBillFormProvider.notifier)
          .updateField('customerNotes', customerNotesController.text);
    });

    termsAndConditionsController.addListener(() {
      ref
          .read(addBillFormProvider.notifier)
          .updateField('terms', termsAndConditionsController.text);
    });

    // ✅ Preload necessary GET APIs for dropdowns
    Future.microtask(() async {
      final notifier = ref.read(addBillFormProvider.notifier);
      ref.read(getVendorList);
      ref.read(fetchBranchListProvider);
      ref.read(fetchShippingMethodsProvider);
      ref.read(fetchPriceCurrencyProvider);
      ref.read(addBillFormProvider.notifier).updateField('billDate', DateTime.now());
      ref.read(addBillFormProvider.notifier).updateField('dueDate', DateTime.now());
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
    customerNotesController.dispose();
    termsAndConditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addBillFormProvider);
    final notifier = ref.read(addBillFormProvider.notifier);

    return CustomExpansionTile(
      title: 'Bill Details',
      isExpanded: true,
      onToggle: () {},
      height: 2,
      child: ReusableColumn(
        children: [
          PayzoBottomsheetNavigator(
            title: 'Select vendor',
            isPayzoColor: true,
            errorText: state.errors['vendor'],
            required: true,
            trailing: state.vendor ?? '',
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  final vendorAsync = ref
                      .watch(getVendorList); // Make sure this is watched here

                  return vendorAsync.when(
                    data: (data) {
                      final vendorNames = data.response?.response
                              ?.map((e) => e.displayName ?? '')
                              .where((e) => e.isNotEmpty)
                              .toSet()
                              .toList() ??
                          [];

                      return ReusableCountryBottomSheet(
                        title: 'Vendor',
                        items: vendorNames,
                        onSelect: (selectedVendorName) {
                          final selected = data.response?.response?.firstWhere(
                            (element) =>
                                element.displayName == selectedVendorName,
                            orElse: () => data.response!.response!.first,
                          );

                          if (selected != null) {
                            notifier.updateField('vendorId', selected.partyId);
                            notifier.updateField(
                                'vendor', selected.displayName ?? '');
                          }
                        },
                      );
                    },
                    error: (err, _) {
                      debugPrint('❌ Error fetching vendors: $err');
                      return const Center(
                          child: Text('Failed to load vendor list'));
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  );
                },
              );
            },
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            required: true,
            title: 'Branch',
            isPayzoColor: true,
            errorText: state.errors['branch'],
            trailing: state.branch ?? '',
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
                                ref
                                    .read(addBillFormProvider.notifier)
                                    .updateField('branch',
                                        selectedBranch.namePrimary ?? '');
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
            inputFormatters: PayzoInputFormatters.onlyDigits,
            keyboardType: TextInputType.numberWithOptions(),
            errorText: state.errors['billRefNo'],
            label: 'Bill Reference Number',
            onChanged: (val) => notifier.updateField('billRefNo', val),
          ),
          PayzoInputField(
            controller: widget.controller[1],
            inputFormatters: PayzoInputFormatters.onlyDigits,
            keyboardType: TextInputType.numberWithOptions(),
            errorText: state.errors['orderNo'],
            label: 'Order Number',
            onChanged: (val) => notifier.updateField('orderNo', val),
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            enabled: false,
            required: true,
            errorText: state.errors['billDate'],
            isPayzoColor: true,
            title: 'Bill Date',
            trailing: formatDate(state.billDate ?? DateTime.now()),
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              // final selectedDate = await pickDate(context);
              // if (selectedDate != null) {
              //   notifier.updateField('billDate', selectedDate);
              // }
            },
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            required: true,
            errorText: state.errors['dueDate'],
            isPayzoColor: true,
            title: 'Due Date',
            trailing: formatDate(state.dueDate ?? DateTime.now().add(Duration(days: 30))),
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              final selectedDate = await pickDate(context);
              if (selectedDate != null) {
                notifier.updateField('dueDate', selectedDate);
              }
            },
          ),
          ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
              required: true,
              errorText: state.errors['shippingMethod'],
              isPayzoColor: true,
              title: 'Shipping Method',
              trailing: state.shippingMethod ?? 'Tap to Select',
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
                                    (element) =>
                                        element.shpmName == selectedMethod,
                                    orElse: () => shippingList.first,
                                  );

                                  ref
                                      .read(addBillFormProvider.notifier)
                                      .updateField('shippingMethod',
                                          selected.shpmName ?? '');
                                },
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (err, _) {
                              print("error is:$err");
                              print('the stacktrace is:$_');
                              return Center(
                                child: Text(
                                    'Error loading shipping methods: $err'),
                              );
                            });
                      },
                    );
                  },
                );
              }),
          ReusableSizedBox(height: 15),
          PayzoBottomsheetNavigator(
            required: true,
            errorText: state.errors['currency'],
            title: 'Price Currency',
            isPayzoColor: true,
            trailing: state.currency ?? 'Tap to Select',
            onTap: () {
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
                                  .read(addBillFormProvider.notifier)
                                  .updateField(
                                      'currency', selected.currencyValue ?? '');
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(
                          child: Text('Error loading currency list: $err'),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          ReusableSizedBox(height: 15),
          CustomDescriptionField(
            // required: true,
            // errorText: state.errors['paymentTerms'],
            title: 'Payment Terms',
            controller: paymentTermsController,
          ),
          ReusableSizedBox(height: 15),
          CustomDescriptionField(
            // required: true,
            // errorText: state.errors['customerNotes'],
            title: 'Customer Notes',
            controller: customerNotesController,
          ),
          ReusableSizedBox(height: 15),
          CustomDescriptionField(
            // required: true,
            title: 'Terms and Conditions',
            controller: termsAndConditionsController,
          ),
          ReusableSizedBox(height: 15),
        ],
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
      initialDate: now.add(Duration(days: 30)), // default to 1 month ahead
      firstDate: now, // 🔒 prevents past date selection
      lastDate: DateTime(now.year + 10),
    );
  }
}
