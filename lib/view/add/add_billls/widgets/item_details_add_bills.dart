import 'package:payzo_books/data/repository/add_bills/get_all_bills_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_customer_list_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import 'package:intl/intl.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/view/add/add_billls/widgets/add_bills_item_discount.dart';

import '../../../../data/repository/add_bills/get_item_repository.dart';
import 'package:collection/collection.dart';

import '../notifier/add_bill_providers.dart';

class ItemDetailsAddBills extends ConsumerWidget {
  final int index;
  final List<TextEditingController> controllers;

  const ItemDetailsAddBills({
    super.key,
    required this.index,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addBillFormProvider);
    final notifier = ref.read(addBillFormProvider.notifier);
    final item = state.itemDetails[index];

    // Watch discount provider to decide whether to show item discount field
    final discountState = ref.watch(payzoDiscountProvider);
    final showItemDiscount =
        discountState.apply && discountState.level == PayzoDiscountLevel.item;

    return ScalingFactor(
      child: CustomExpansionTile(
        // title: 'Item ${index + 1}',
        title: 'Item',
        isExpanded: false,
        onToggle: () {},
        height: 2,
        child: ReusableColumn(children: [
          PayzoInputField(
            showList: true,
            controller: controllers[3],
            required: true,
            label: 'Item name',
            initialValue: item.rateDate?.toString() ?? '',
            errorText: state.errors['rateDate'],
            keyboardType: TextInputType.text,
            onChanged: (val) {
              // When user types manually, just update the item name in the state
              notifier.updateItemField(index, 'itemName', val);
            },
            showListTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  final itemAsync = ref.watch(fetchItemListProvider);

                  return itemAsync.when(
                    data: (data) {
                      final itemNames = data
                          .map((e) => e.itemName ?? '')
                          .where((e) => e.isNotEmpty)
                          .toSet()
                          .toList();

                      return ReusableCountryBottomSheet(
                        title: 'Item',
                        items: itemNames,
                        onSelect: (selectedItem) {
                          final unitList =
                              ref.read(fetchUnitListProvider).asData?.value ??
                                  [];

                          final selected = data
                              .firstWhere((e) => e.itemName == selectedItem);

                          // Update the controller to show the selected name
                          controllers[3].text = selected.itemName ?? '';
                          notifier.updateItemField(
                              index, 'itemName', selected.itemName ?? '');
                          notifier.updateItemField(
                              index, 'unitId', selected.unitId ?? 0);
                          notifier.updateItemField(
                              index, 'amount', selected.salesRate ?? 0.0);
                        },
                      );
                    },
                    error: (err, _) => Center(child: Text('Error: $err')),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  );
                },
              );
            },
          ),

          // PayzoBottomsheetNavigator(
          //   required: true,
          //   errorText: state.errors['itemName'],
          //   title: 'Select Item',
          //   isPayzoColor: true,
          //   trailing: item.itemName ?? '',
          //
          // ),

          const ReusableSizedBox(height: 5),

          PayzoBottomsheetNavigator(
            required: true,
            errorText: state.errors['account'],
            isPayzoColor: true,
            title: 'Account',
            trailing: item.account ?? 'Tap to Select',
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  final accountAsync = ref.watch(fetchAccountListProvider);

                  return accountAsync.when(
                    data: (data) {
                      final accountNames =
                          data.map((e) => e.accountName).toList();

                      return ReusableCountryBottomSheet(
                        title: 'Select Account',
                        items: accountNames,
                        onSelect: (selectedAccount) {
                          notifier.updateItemField(
                              index, 'account', selectedAccount);
                        },
                      );
                    },
                    error: (err, _) =>
                        Center(child: Text('Error loading accounts: $err')),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  );
                },
              );
            },
          ),

          PayzoInputField(
            required: true,
            controller: controllers[0],
            inputFormatters: PayzoInputFormatters.onlyDigits,
            label: 'Quantity',
            keyboardType: TextInputType.number,
            initialValue: item.quantity?.toString() ?? '',
            errorText: state.errors['quantity'],
            onChanged: (val) {
              final parsed = int.tryParse(val);
              notifier.updateItemField(index, 'quantity', parsed ?? 0);
              notifier.calculateItemAmount(index, ref);
            },
          ),

          PayzoBottomsheetNavigator(
            required: true,
            errorText: state.errors['unitType'],
            isPayzoColor: true,
            title: 'Unit Type',
            trailing: item.unitType ?? 'Tap to Select',
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  final unitsAsync = ref.watch(fetchUnitListProvider);

                  return unitsAsync.when(
                    data: (units) {
                      final unitNames =
                          units.map((u) => u.displayUnit).toList();

                      return ReusableCountryBottomSheet(
                        title: 'Select Unit',
                        items: unitNames,
                        onSelect: (selected) {
                          final selectedUnit = units
                              .firstWhere((u) => u.displayUnit == selected);
                          notifier.updateItemField(
                              index, 'unitType', selectedUnit.displayUnit);
                        },
                      );
                    },
                    error: (e, _) => Center(child: Text('Error: $e')),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  );
                },
              );
            },
          ),

          // // ⇢ Show item discount only when apply=true && level==item
          // if (showItemDiscount) ...[
          //   ReusableSizedBox(height: 8),
          //   AddBillItemDiscountField(
          //     controller: ref.watch(addBillItemDiscountProvider),
          //   ),
          // ],

          // Rate
          PayzoInputField(
            controller: controllers[1],
            required: true,
            label: 'Unit price/Amount',
            initialValue: item.rateDate?.toString() ?? '0.0',
            errorText: state.errors['rateDate'],
            keyboardType: TextInputType.number,
            inputFormatters: PayzoInputFormatters.onlyDigits,
            onChanged: (val) {
              notifier.updateItemField(index, 'rateDate', val);
              notifier.calculateItemAmount(index,ref);
            },
          ),

          if (showItemDiscount)PayzoInputField(
            controller: controllers[4],
            required: true,
            label: 'Discount',
            initialValue: item.discountAmount?.toString() ?? '',
            errorText: state.errors['discountAmount'],
            keyboardType: TextInputType.number,
            leading: GestureDetector(
              child: ReusableSizedBox(
                width: 40,
                child: ReusableRow(children:<Widget>[
                  ReusableText(text: '${ref.watch(addBillItemDiscountCurrencyStringProvider)}'),
                  ReusableSizedBox(width: 5,),
                  Icon(Icons.keyboard_arrow_down)
                ]),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    final taxOptions = [
                      '\$',
                      '%'
                    ];

                    return ReusableCountryBottomSheet(
                      title: 'Select discount type',
                      items: taxOptions,
                      onSelect: (selectedDiscount) {
                        final isDollar = selectedDiscount == '\$';

                        // update the per-item flag first
                        notifier.updateItemField(index, 'discountIsCurrency', isDollar);

                        // update the small provider/string used for display (optional)
                        ref.read(addBillItemDiscountCurrencyStringProvider.notifier).state = selectedDiscount;

                        // recalc now that the item has correct flag
                        notifier.calculateItemAmount(index, ref);
                      },
                    );
                  },
                );
              },
            ),
            onChanged: (val) {
              final parsedDiscount = double.tryParse(val) ?? 0.0;
              notifier.updateItemField(index, 'discountAmount', parsedDiscount);
              controllers[4].text = parsedDiscount.toString();
              notifier.calculateItemAmount(index, ref);
            },
          ),

          PayzoBottomsheetNavigator(
            required: true,
            errorText: state.errors['taxType'],
            isPayzoColor: true,
            title: 'Tax Type',
            trailing: item.taxType ?? 'Tap to Select',
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  final taxAsync = ref.watch(fetchAllTaxesProvider);
                  return taxAsync.when(
                    data: (data) {
                      // Combine all tax names (Others + DefaultTax)
                      final taxOptions = [
                        ...data.others.map((e) => e.taxName),
                        ...data.defaultTax.map((e) => e.taxName),
                      ];

                      return ReusableCountryBottomSheet(
                        title: 'Select Tax Type',
                        items: taxOptions,
                        onSelect: (selectedTax) {
                          notifier.updateItemField(
                              index, 'taxType', selectedTax);
                        },
                      );
                    },
                    error: (e, _) =>
                        Center(child: Text('Error loading tax types: $e')),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  );
                },
              );
            },
          ),

          // // Customer Details
          // PayzoBottomsheetNavigator(
          //   required: true,
          //   errorText: state.errors['customerDate'],
          //   isPayzoColor: true,
          //   title: 'Customer',
          //   trailing: item.customerDate?.toString() ?? 'Tap to Select',
          //   onTap: () async {
          //     await ref.read(focusUtilsProvider).unfocusAndDelay();
          //
          //     showModalBottomSheet(
          //       context: context,
          //       isScrollControlled: true,
          //       backgroundColor: Colors.transparent,
          //       builder: (_) {
          //         final customerAsync = ref.watch(fetchCustomerListProvider);
          //         return customerAsync.when(
          //           data: (data) {
          //             final customerNames = data
          //                 .map((e) => e.displayName ?? '')
          //                 .where((name) => name.isNotEmpty)
          //                 .toList();
          //
          //             return ReusableCountryBottomSheet(
          //               title: 'Select Customer',
          //               items: customerNames,
          //               onSelect: (selectedName) {
          //                 final selected = data.firstWhere(
          //                       (c) => c.displayName == selectedName,
          //                   orElse: () => data.first,
          //                 );
          //
          //                 notifier.updateItemField(
          //                     index, 'customerDate', selected.displayName ?? '');
          //                 notifier.updateItemField(
          //                     index, 'customerId', selected.partyId ?? 0);
          //               },
          //             );
          //           },
          //           error: (e, _) =>
          //               Center(child: Text('Error loading customers: $e')),
          //           loading: () =>
          //           const Center(child: CircularProgressIndicator()),
          //         );
          //       },
          //     );
          //   },
          // ),

          // PayzoInputField(
          //   controller: controllers[2],
          //   required: true,
          //   inputFormatters: PayzoInputFormatters.onlyDigits,
          //   label: 'Amount',
          //   keyboardType: TextInputType.number,
          //   initialValue: item.amount?.toStringAsFixed(2) ?? '0.00',
          //   errorText: state.errors['amount'],
          //   onChanged: (val) {
          //     final parsed = double.tryParse(val);
          //     notifier.updateItemField(index, 'amount', parsed ?? 0.0);
          //   },
          // ),
          const ReusableSizedBox(height: 5),
          PayzoBottomsheetNavigator(
            title: 'Amount',
            divider: false,
            trailing: item.amount.toString().isEmpty?'0.00':item.amount.toString(),
            errorText: state.errors['amount'],
            onTap: () {},
            enabled: false,
            isPayzoColor: true,
            navigationButton: false,
          ),

          const ReusableSizedBox(height: 5),
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
