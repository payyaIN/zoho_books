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

import '../../../../data/repository/add_bills/get_item_repository.dart';
import 'package:collection/collection.dart';

class ItemDetailsAddBills extends ConsumerWidget {
  final int index;
  final List <TextEditingController> controllers;
  const ItemDetailsAddBills({super.key, required this.index,required this.controllers, });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addBillFormProvider);
    final notifier = ref.read(addBillFormProvider.notifier);
    final item = state.itemDetails[index];

    return ScalingFactor(
      child: CustomExpansionTile(
        // title: 'Item ${index + 1}',
        title: 'Item',
        isExpanded: false,
        onToggle: () {},
        height: 2,
        child: ReusableColumn(children: [
          PayzoBottomsheetNavigator(
            required: true,
            errorText: state.errors['itemName'],
            title: 'Select Item',
            isPayzoColor: true,
            trailing: item.itemName ?? '',
            onTap: () async {
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
                          final unitList = ref.read(fetchUnitListProvider).asData?.value ?? [];

                          final selected = data.firstWhere((e) => e.itemName == selectedItem);
                          // final matchedUnit = unitList.firstWhereOrNull(
                          //       (unit) => unit.unitId == selected.unitId,
                          // );

                          notifier.updateItemField(index, 'itemName', selected.itemName ?? '');
                          notifier.updateItemField(index, 'unitId', selected.unitId ?? 0);
                          // notifier.updateItemField(index, 'unitType', matchedUnit?.displayUnit ?? '');
                          notifier.updateItemField(index, 'amount', selected.salesRate ?? 0.0);


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

          ReusableSizedBox(height: 5),

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
            },
          ),
          // PayzoInputField(
          //   label: 'Unit Type',
          //   initialValue: item.unitType ?? '',
          //   onChanged: (val) =>
          //       notifier.updateItemField(index, 'unitType', val),
          // ),
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

          ReusableSizedBox(height: 5),

          // PayzoBottomsheetNavigator(
          //   required: true,
          //   errorText: state.errors['rateDate'],
          //   isPayzoColor: true,
          //   title: 'Rate',
          //   trailing: formatDate(item.rateDate),
          //   onTap: () async {
          //     await ref.read(focusUtilsProvider).unfocusAndDelay();
          //     final selectedDate = await pickDate(context);
          //     if (selectedDate != null) {
          //       notifier.updateItemField(index, 'rateDate', selectedDate);
          //     }
          //   },
          // ),
          // 🔥 Rate
          PayzoInputField(
            controller: controllers[1],
            required: true,
            label: 'Rate',
            initialValue: item.rateDate?.toString() ?? '',
            errorText: state.errors['rateDate'],
            keyboardType: TextInputType.number,
            inputFormatters: PayzoInputFormatters.onlyDigits,
            onChanged: (val) {
              notifier.updateItemField(index, 'rateDate', val);
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
          // 🔥 Customer Details
          PayzoBottomsheetNavigator(
            required: true,
            errorText: state.errors['customerDate'],
            isPayzoColor: true,
            title: 'Customer',
            trailing: item.customerDate?.toString() ?? 'Tap to Select',
            onTap: () async {
              await ref.read(focusUtilsProvider).unfocusAndDelay();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  final customerAsync = ref.watch(fetchCustomerListProvider);
                  return customerAsync.when(
                    data: (data) {
                      final customerNames = data
                          .map((e) => e.displayName ?? '')
                          .where((name) => name.isNotEmpty)
                          .toList();

                      return ReusableCountryBottomSheet(
                        title: 'Select Customer',
                        items: customerNames,
                        onSelect: (selectedName) {
                          final selected = data.firstWhere(
                                (c) => c.displayName == selectedName,
                            orElse: () => data.first,
                          );

                          notifier.updateItemField(index, 'customerDate', selected.displayName ?? '');
                          notifier.updateItemField(index, 'customerId', selected.partyId ?? 0);
                        },
                      );
                    },
                    error: (e, _) =>
                        Center(child: Text('Error loading customers: $e')),
                    loading: () =>
                    const Center(child: CircularProgressIndicator()),
                  );
                },
              );
            },
          ),
          PayzoInputField(
            controller:controllers[2],
            required: true,
            inputFormatters: PayzoInputFormatters.onlyDigits,
            label: 'Amount',
            keyboardType: TextInputType.number,
            initialValue: item.amount?.toStringAsFixed(2) ?? '',
            errorText: state.errors['amount'],
            onChanged: (val) {
              final parsed = double.tryParse(val);
              notifier.updateItemField(index, 'amount', parsed ?? 0.0);
            },
          ),

          ReusableSizedBox(height: 5),
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
