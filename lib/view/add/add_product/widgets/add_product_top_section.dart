import 'package:payzo_books/data/repository/add_bills/get_item_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/view/add/add_product/notifier/add_item_notifier.dart';
import 'package:payzo_books/view/add/add_product/widgets/tax_showing_widget.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import '../../../../import_data.dart';

final exemptionReasonControllerProvider =
    Provider<TextEditingController>((ref) {
  return TextEditingController();
});

class AddProductTopSection extends ConsumerWidget {
  final Map<String, TextEditingController> controllers;

  const AddProductTopSection({super.key, required this.controllers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productFormProvider);
    final notifier = ref.read(productFormProvider.notifier);
    final exemptionReasonController =
        ref.watch(exemptionReasonControllerProvider);
    final taxDataAsync = ref.watch(fetchAllTaxesProvider);
    if (taxDataAsync is AsyncData && product.taxPreference.isEmpty) {
      final standardRate = taxDataAsync.value!.defaultTax.firstWhere(
        (e) => e.taxName == 'Standard Rate',
        orElse: () => taxDataAsync.value!.defaultTax.first,
      );

      // Trigger state update once with default "Standard Rate"
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.updateField('taxPreference', standardRate.taxName);
        notifier.updateTaxPreferences(
          taxId: standardRate.taxId,
          taxType: standardRate.taxType,
        );
      });
    }

    final selectedDefaultTax = taxDataAsync.maybeWhen(
      data: (taxData) => taxData.defaultTax.firstWhere(
        (e) => e.taxName == product.taxPreference,
        orElse: () => taxData.defaultTax[1],
      ),
      orElse: () => null,
    );

    return FormContainer(
      height: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 18),
        child: ReusableColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Item Name Field
            PayzoInputField(
              inputFormatters: PayzoInputFormatters.onlyAlphabets,
              required: true,
              label: 'Item Name',
              controller: controllers['itemName'],
              errorText: product.errors?['itemName'],
              onChanged: (val) {
                notifier.updateField('name', val);
                notifier.updateField('itemName', val);
              },
            ),
            const ReusableSizedBox(height: 8),

            /// ✅ Item Name arabic Field
            PayzoInputField(
              inputFormatters: PayzoInputFormatters.onlyAlphabets,
              required: true,
              label: 'Item Name(Arabic)',
              controller: controllers['itemNameArabic'],
              errorText: product.errors?['itemNameArabic'],
              onChanged: (val) {
                // notifier.updateField('name', val);
                notifier.updateField('itemNameArabic', val);
              },
            ),
            const ReusableSizedBox(height: 8),

            /// ✅ Unit Dropdown
            PayzoBottomsheetNavigator(
              required: true,
              title: 'Unit',
              isPayzoColor: true,
              trailing: product.unit,
              errorText: product.errors?['unitId'],
              // ✅ Note: use 'unitId'
              onTap: () async {
                await ref.read(focusUtilsProvider).unfocusAndDelay();
                final itemList = await ref.read(fetchUnitListProvider.future);
                // 👇 Forcefully unfocus any text field

                final itemNames = itemList
                    .map((e) => e.displayUnit ?? '')
                    .where((e) => e.isNotEmpty)
                    .toSet()
                    .toList();

                if (context.mounted) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => ReusableCountryBottomSheet(
                      title: 'Unit',
                      items: itemNames,
                      onSelect: (selectedItem) {
                        final selected = itemList.firstWhere(
                          (e) => e.displayUnit == selectedItem,
                        );

                        notifier.updateField('unit', selected.displayUnit);
                        notifier.updateField('unitId', selected.unitId);
                        debugPrint(
                            "✅ Unit selected: ${selected.displayUnit}, ID: ${selected.unitId}");
                      },
                    ),
                  );
                }
              },
            ),

            /// ✅ Type (Goods/Service)
            ExpansionToggleButtons(
              'Type',
              true,
              [
                FormRadioButton(
                  value: 'goods',
                  groupValue: product.type,
                  title: 'Goods',
                  onChanged: (val) {
                    notifier.updateRadio('type', val!);
                    notifier.updateField('typeBool', val == 'goods');
                    debugPrint(
                        "✅ Type: ${product.type}, Bool: ${val == 'goods'}");
                  },
                ),
                const SizedBox(height: 16),
                FormRadioButton(
                  value: 'Service',
                  groupValue: product.type,
                  title: 'Service',
                  onChanged: (val) {
                    notifier.updateRadio('type', val!);
                    notifier.updateField('typeBool', val == 'goods');
                    debugPrint(
                        "✅ Type: ${product.type}, Bool: ${val == 'goods'}");
                  },
                ),
              ],
              (p0) {},
            ),

            const SizedBox(height: 8),
            const PayzoDivider(),

            /// ✅ HSN Code
            PayzoInputField(
              inputFormatters: PayzoInputFormatters.hsnCode,
              keyboardType: TextInputType.numberWithOptions(),
              label: product.type=='goods'?'HS Code':'SAC',
              controller: controllers['hsnCode'],
              errorText: product.errors?['code'],
              onChanged: (val) => notifier.updateField('code', val),
            ),
            const SizedBox(height: 8),

            /// ✅ Tax Preference
            PayzoBottomsheetNavigator(
              required: true,
              title: 'Tax Preference',
              isPayzoColor: true,
              trailing: product.taxPreference,
              errorText: product.errors?['taxPreference'],
              onTap: () async {
                await ref.read(focusUtilsProvider).unfocusAndDelay();
                final taxData = await ref.read(fetchAllTaxesProvider.future);

                final taxNames = [
                  ...taxData.others.map((e) => e.taxName),
                  ...taxData.defaultTax.map((e) => e.taxName),
                ];

                if (context.mounted) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => ReusableCountryBottomSheet(
                      title: 'Select Tax Preference',
                      items: taxNames,
                      onSelect: (selectedTax) {
                        final selected = [
                          ...taxData.others.map((e) => {
                                'id': e.taxId,
                                'type': e.taxType,
                                'name': e.taxName
                              }),
                          ...taxData.defaultTax.map((e) => {
                                'id': e.taxId,
                                'type': e.taxType,
                                'name': e.taxName
                              }),
                        ].firstWhere((e) => e['name'] == selectedTax);

                        notifier.updateField('taxPreference', selectedTax);
                        notifier.updateTaxPreferences(
                          taxId: selected['id'] as int,
                          taxType: selected['type'] as String,
                        );
                        debugPrint(
                            '✅ Selected Tax: $selectedTax | ID: ${selected['id']} | Type: ${selected['type']}');
                      },
                    ),
                  );
                }
              },
            ),

            if (product.taxPreference == 'Non-Taxable') ...[
              const SizedBox(height: 8),

              CustomDescriptionField(
                errorText: product.errors?['exemptionReason'],
                required: true,
                title: 'Exemption Reason',
                controller: exemptionReasonController,
                onChanged: (value) {
                  debugPrint('📝 Exemption Reason updated: $value');
                  notifier.updateField('exemptionReason', value);
                },
              ),
            ],
            if (selectedDefaultTax != null &&
                (product.taxPreference == 'Standard Rate' ||
                    product.taxPreference == 'Zero Tax')) ...[
              const SizedBox(height: 8),
              TaxShowingWidget(
                title: selectedDefaultTax.taxName,
                subTitle: 'Tax Rate',
                detail:
                    '${selectedDefaultTax.taxName} (${selectedDefaultTax.tcdTaxRate.toStringAsFixed(2)}%)',
              ),
            ],
            PayzoDivider(),
            ExpansionToggleButtons(
              'Category',
              true,
              [
                FormRadioButton(
                  value: 'Trade',
                  groupValue: product.purchaseType,
                  title: 'Trade',
                  onChanged: (val) {
                    print('good val:$val');
                    notifier.updateRadio(
                        'purchaseType', val!); // 'Trade' for UI
                    notifier.updatePurchaseInfo(
                        purchaseType: 1); // 1 for API
                    notifier.updateToggle(section: 'purchaseInfo', value: true);
                    notifier.updateField('purchaseFlag', true);
                    notifier.updateToggle(section: 'salesInfo', value: true);
                    notifier.updateField('salesFlag', true);
                    debugPrint(
                        '✅ Purchase Info type: ${notifier.state.purchaseInformation.purchaseType}');
                  },
                ),
                ReusableSizedBox(height: 5),
                FormRadioButton(
                  value: 'Assets',
                  groupValue: product.purchaseType,
                  title: 'Assets',
                  onChanged: (val) {
                    notifier.updateRadio('purchaseType', val!);
                    notifier.updatePurchaseInfo(purchaseType: 2);
                    notifier.updateToggle(section: 'purchaseInfo', value: false);
                    notifier.updateField('purchaseFlag', false);
                    notifier.updateToggle(section: 'salesInfo', value: false);
                    notifier.updateField('salesFlag', false);
                    debugPrint(
                        '✅ Purchase Info type: ${notifier.state.purchaseInformation.purchaseType}');
                  },
                ),
                ReusableSizedBox(height: 5),
                FormRadioButton(
                  value: 'Expense',
                  groupValue: product.purchaseType,
                  title: 'Expense',
                  onChanged: (val) {
                    notifier.updateRadio('purchaseType', val!);
                    notifier.updatePurchaseInfo(purchaseType: 3);
                    notifier.updateToggle(section: 'purchaseInfo', value: false);
                    notifier.updateField('purchaseFlag', false);
                    notifier.updateToggle(section: 'salesInfo', value: false);
                    notifier.updateField('salesFlag', false);
                    debugPrint(
                        '✅ Purchase Info type: ${notifier.state.purchaseInformation.purchaseType}');
                  },
                ),
              ],
                  (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
