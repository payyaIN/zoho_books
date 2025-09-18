import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payzo_books/data/repository/add_bills/get_all_bills_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_item_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/view/add_invoice/notifier/add_invoice_form_notifier.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';

class ItemDetailsAddInvoice extends ConsumerStatefulWidget {
  final int index;
  final List <TextEditingController> controllers;
  const ItemDetailsAddInvoice({super.key, required this.index,required this.controllers, });

  @override
  ConsumerState<ItemDetailsAddInvoice> createState() =>
      _ItemDetailsAddInvoiceState();
}

class _ItemDetailsAddInvoiceState extends ConsumerState<ItemDetailsAddInvoice> {
  @override
  void initState() {
    super.initState();

    // 🔄 Prefetch all required GET APIs on widget init
    Future.microtask(() {
      ref.read(fetchItemListProvider);
      ref.read(fetchAccountListProvider);
      ref.read(fetchUnitListProvider);
      ref.read(fetchAllTaxesProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceFormProvider);
    final notifier = ref.read(invoiceFormProvider.notifier);
    final item = state.itemDetails[widget.index];

    return ScalingFactor(
      child: CustomExpansionTile(
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
                          final selected = data.firstWhere((e) => e.itemName == selectedItem);

                          notifier.updateItemField(widget.index, 'prodId', selected.itemId);
                          notifier.updateItemField(widget.index, 'prodCatId', selected.itemId); // ✅ Add this line
                          notifier.updateItemField(widget.index, 'itemName', selected.itemName ?? '');
                          // notifier.updateItemField(widget.index, 'unitType', selected.unitId?.toString() ?? '');
                          notifier.updateItemField(widget.index, 'amount', selected.salesRate ?? 0.0);
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
                          data.map((e) => e.accountName ?? '').toList();
                      return ReusableCountryBottomSheet(
                        title: 'Select Account',
                        items: accountNames,
                        onSelect: (selectedAccount) {
                          notifier.updateItemField(
                              widget.index, 'account', selectedAccount);
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
            controller: widget.controllers[0],
            required: true,
            label: 'Quantity',
            keyboardType: TextInputType.number,
            initialValue: item.quantity?.toString() ?? '',
            errorText: state.errors['quantity'],
            onChanged: (val) {
              final parsed = int.tryParse(val);
              notifier.updateItemField(widget.index, 'quantity', parsed ?? 0);
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
                          units.map((u) => u.displayUnit ?? '').toList();
                      return ReusableCountryBottomSheet(
                        title: 'Select Unit',
                        items: unitNames,
                        onSelect: (selected) {
                          final selectedUnit = units
                              .firstWhere((u) => u.displayUnit == selected);
                          notifier.updateItemField(widget.index, 'unitType',
                              selectedUnit.displayUnit);
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
          PayzoInputField(
            controller: widget.controllers[1],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: PayzoInputFormatters.onlyDecimalNumbers,
            required: true,
            label: 'Rate',
            initialValue: item.rateDate ?? '0',
            errorText: state.errors['rateDate'],
            onChanged: (val) {
              notifier.updateItemField(widget.index, 'rateDate', val);
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
                      final taxOptions = [
                        ...data.others.map((e) => e.taxName),
                        ...data.defaultTax.map((e) => e.taxName),
                      ];

                      // ✅ Print debug info
                      print("🟢 Total Tax Options: ${taxOptions.length}");
                      print("📋 Tax Options: $taxOptions");

                      return ReusableCountryBottomSheet(
                        title: 'Select Tax Type',
                        items: taxOptions,
                        onSelect: (selectedTax) {
                          print(
                              "✅ Selected Tax Type: $selectedTax"); // ⬅️ print selected
                          notifier.updateItemField(
                              widget.index, 'taxType', selectedTax);
                        },
                      );
                    },
                    error: (e, _) {
                      print('🔴 Tax API Error: $e');
                      return Center(child: Text('Error: $e'));
                    },
                    loading: () {
                      print('⏳ Loading tax types...');
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                },
              );
            },
          ),
          // PayzoBottomsheetNavigator(
          //   required: true,
          //   errorText: state.errors['customerDate'],
          //   isPayzoColor: true,
          //   title: 'Customer Date',
          //   trailing: item.customerDate!,
          //   onTap: () async {
          //     await ref.read(focusUtilsProvider).unfocusAndDelay();
          //     final selectedDate = await pickDate(context);
          //     if (selectedDate != null) {
          //       notifier.updateItemField(
          //           widget.index, 'customerDate', selectedDate);
          //     }
          //   },
          // ),
          ReusableSizedBox(height: 12),
          PayzoInputField(
            controller: widget.controllers[2],
            required: true,
            label: 'Amount',
            keyboardType: TextInputType.number,
            initialValue: item.amount?.toStringAsFixed(2) ?? '',
            errorText: state.errors['amount'],
            onChanged: (val) {
              final parsed = double.tryParse(val);
              notifier.updateItemField(widget.index, 'amount', parsed ?? 0.0);
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
