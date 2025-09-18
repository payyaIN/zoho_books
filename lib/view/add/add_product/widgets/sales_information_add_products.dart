import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_product/get_all_account_list_repository.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/view/add/add_product/notifier/add_item_notifier.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/utils/common_widgets/sar_textfield.dart';

final salesInformationCurrencyTypeNameProvider =
    StateProvider<String>((ref) => 'SAR');

class SalesInformationAddProducts extends ConsumerWidget {
  final Map<String, TextEditingController> controllers;

  const SalesInformationAddProducts({super.key, required this.controllers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productFormProvider);
    final notifier = ref.read(productFormProvider.notifier);
    final salesInformationCurrencyTypeName =
        ref.read(salesInformationCurrencyTypeNameProvider.notifier);

    return ScalingFactor(
      child: FormContainer(
        height: 2,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 18, bottom: 18, left: 15, right: 15),
          child: ReusableColumn(
            children: [
              CustomToggleTile(
                title: 'Sales Information',
                value: product.hasSalesInfo,
                onChanged: (val) {
                  notifier.updateToggle(section: 'salesInfo', value: val);
                  notifier.updateField('salesFlag', val);
                  debugPrint('✅ Sales Info Toggled: $val');
                },
                divider: product.salesFlag == true ? true : false,
              ),
              if (product.salesFlag == true)
                ReusableColumn(children: [
                  PayzoInputField(
                    required: true,
                    leading: SarTextfield(
                      title: salesInformationCurrencyTypeName.state,
                      onTap: () async {
                        final currencyList =
                            await ref.read(fetchPriceCurrencyProvider.future);

                        final currencyLabels = currencyList
                            .map((e) => e.currencyValue ?? '')
                            .where((e) => e.isNotEmpty)
                            .toSet()
                            .toList();

                        if (context.mounted) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => ReusableCountryBottomSheet(
                              title: 'Select Currency',
                              items: currencyLabels,
                              onSelect: (selectedCurrency) {
                                final selected = currencyList.firstWhere(
                                  (e) => e.currencyValue == selectedCurrency,
                                  orElse: () => currencyList.first,
                                );

                                notifier.updateSaleInfo(
                                  salesCurrency:
                                      selected.currencyId?.toInt() ?? 0,
                                );
                                salesInformationCurrencyTypeName.state =
                                    selected.currencyValue.toString();

                                debugPrint(
                                    '✅ Selected Currency: ${selected.currencyValue}, ID: ${selected.currencyId}');
                              },
                            ),
                          );
                        }
                      },
                    ),
                    label: 'Selling Price',
                    errorText: product.errors?['sellingPrice'],
                    controller: controllers['sellingPrice'],
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null) {
                        notifier.updateSaleInfo(sellingPrice: val);
                        debugPrint(
                            '✅ Updated Opening Stock: ${notifier.state.saleInformation.sellingPrice}');
                      }
                    },
                  ),
                  // PayzoInputField(
                  //   label: 'Selling Price',
                  //   errorText: product.errors?['sellingPrice'],
                  //   controller: controllers['sellingPrice'],
                  //   onChanged: (val) => notifier.updateField('sellingPrice', val),
                  // ),
                  const ReusableSizedBox(height: 5),

                  /// ✅ Sales Account using prefetched data
                  PayzoBottomsheetNavigator(
                    required: true,
                    errorText: product.errors?['sellingAccount'],
                    title: 'Account',
                    trailing: product.account.isEmpty?'Tap to Select':product.account,
                    isPayzoColor: true,
                    onTap: () async {
                      await ref.read(focusUtilsProvider).unfocusAndDelay();

                      final accountData =
                          await ref.read(getChartOfAccountsProvider.future);

                      final accountLabels = accountData.response
                          .map((e) => e.label ?? '')
                          .where((e) => e.isNotEmpty)
                          .toSet()
                          .toList();

                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ReusableCountryBottomSheet(
                            title: 'Select Account',
                            items: accountLabels,
                            onSelect: (selectedLabel) {
                              final selectedAccount =
                                  accountData.response.firstWhere(
                                (e) => e.label == selectedLabel,
                                orElse: () => accountData.response.first,
                              );

                              // ✅ Update UI label
                              notifier.updateField(
                                  'account', selectedAccount.label ?? '');

                              // ✅ Update internal account ID for API
                              notifier.updateSaleInfo(
                                sellingAccount: selectedAccount.value ?? 0,
                              );
                              debugPrint(
                                  '🧾 Sale Info: ${notifier.state.saleInformation.toJson()}');
                            },
                          ),
                        );
                      }
                    },
                  ),

                  const ReusableSizedBox(height: 15),

                  CustomDescriptionField(
                    title: 'Description',
                    controller: controllers['salesDescription']!,
                    onChanged: (val) =>
                        notifier.updateSaleInfo(description: val),
                  ),
                  const ReusableSizedBox(height: 15),
                  CustomDescriptionField(
                    title: 'Description(Arabic)',
                    controller: controllers['salesDescriptionArabic']!,
                    onChanged: (val) =>
                        notifier.updateSaleInfo(descriptionArabic: val),
                  ),
                ])
              else
                SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
