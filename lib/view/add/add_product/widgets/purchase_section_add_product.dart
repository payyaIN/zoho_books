import 'package:payzo_books/data/models/add_product/get_product_account_list.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_product/get_all_account_list_repository.dart';
import 'package:payzo_books/data/repository/add_product/get_asset_details_repo.dart';
import 'package:payzo_books/data/repository/add_product/get_product_account_list_repo.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/utils/common_widgets/sar_textfield.dart';

import '../../../../import_data.dart';
import '../notifier/add_item_notifier.dart';

final purchaseInformationCurrencyTypeNameProvider =
    StateProvider<String>((ref) => 'SAR');

class PurchaseSectionAddProduct extends ConsumerWidget {
  final Map<String, TextEditingController> controllers;

  const PurchaseSectionAddProduct({super.key, required this.controllers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productFormProvider);
    final notifier = ref.read(productFormProvider.notifier);
    final salesInformationCurrencyTypeName =
        ref.read(salesInformationCurrencyTypeNameProvider.notifier);
    final accountData = ref.watch(getChartOfAccountsProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (accountData is AsyncData &&
          product.purchaseInformation.purchaseType == 1 &&
          product.inventoryFlag == true &&
          product.inventoryDto.stockAccountId == 0) {
        final defaultInventoryAccount = accountData.value?.response.firstWhere(
              (e) => (e.label ?? '').toLowerCase() == 'inventory',
          orElse: () => accountData.value!.response.first,
        );

        notifier.updateInventoryDto(
          stockAccountId: defaultInventoryAccount?.value ?? 0,
          stockAccountName: defaultInventoryAccount?.label ?? '',
        );
      }
    });
    return ScalingFactor(
      child: FormContainer(
        height: 2,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 18, bottom: 18, left: 15, right: 15),
          child: ReusableColumn(
            children: [
              CustomToggleTile(
                title: 'Purchase Information',
                value: product.hasPurchaseInfo,
                onChanged: (val) {
                  notifier.updateToggle(section: 'purchaseInfo', value: val);
                  notifier.updateField('purchaseFlag', val);
                  debugPrint('✅ Purchase Info Toggled: $val');
                },
                divider: product.purchaseFlag == true ? true : false,
              ),
              if (product.purchaseFlag == true)
                ReusableColumn(children: [
                  ExpansionToggleButtons(
                    'Type',
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
                          debugPrint(
                              '✅ Purchase Info type: ${notifier.state.purchaseInformation.purchaseType}');
                        },
                      ),
                    ],
                    (_) {},
                  ),

                  ReusableSizedBox(height: 15),
                  PayzoDivider(),
                  PayzoInputField(
                      inputFormatters: PayzoInputFormatters.onlyDecimalNumbers,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

                                  notifier.updatePurchaseInfo(
                                    costCurrency:
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
                      label: 'Cost Price',
                      errorText: product.errors?['costPrice'] ?? '',
                      controller: controllers['costPrice'],
                      // onChanged: (val) => notifier.updateField('costPrice', val),
                      onChanged: (val) {
                        notifier.updateField('costPrice', val);
                        notifier.updatePurchaseInfo(costPrice: val);

                        // ✅ Access updated state directly from the notifier
                        final updatedState = notifier.state;
                        debugPrint(
                            '✅ Purchase Info costPrice: ${updatedState.purchaseInformation.costPrice}');
                      }),

                  ReusableSizedBox(height: 5),

                  /// ✅ Preferred Vendor (preloaded)
                  PayzoBottomsheetNavigator(
                    title: 'Preferred Vendor',
                    isPayzoColor: true,
                    trailing: product.preferredVendor,
                    onTap: () async {
                      await ref.read(focusUtilsProvider).unfocusAndDelay();
                      final vendorData = await ref.read(getVendorList.future);
                      final vendors = vendorData.response?.response ?? [];

                      final vendorNames = vendors
                          .map((e) => e.displayName ?? '')
                          .where((e) => e.isNotEmpty)
                          .toList();

                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ReusableCountryBottomSheet(
                            title: 'Vendor',
                            items: vendorNames,
                            onSelect: (selectedName) {
                              final selected = vendors.firstWhere(
                                (e) => e.displayName == selectedName,
                                orElse: () => vendors.first,
                              );

                              // Update name in UI
                              notifier.updateField('preferredVendor',
                                  selected.displayName ?? '');

                              // Update vendor ID in purchaseInformation
                              notifier.updatePurchaseInfo(
                                  preferedVendor: selected.partyId ?? 0);

                              debugPrint(
                                  '✅ Preferred Vendor: ${selected.displayName}, ID: ${selected.partyId}');
                            },
                          ),
                        );
                      }
                    },
                  ),

                  ReusableSizedBox(height: 5),

                  /// ✅ Purchase Account (preloaded)
                  PayzoBottomsheetNavigator(
                    required: true,
                    isPayzoColor: true,
                    errorText: product.errors?['purchaseAccount'],
                    title: 'Account',
                    trailing: product.purchaseAccount,
                    onTap: () async {
                      await ref.read(focusUtilsProvider).unfocusAndDelay();
                      final accountData =
                          await ref.read(getProductAccountsProvider.future);
                      final allItems = accountData.expenseAccounts
                          .expand((group) => group.items);

                      final accountLabels = allItems
                          .map((e) => e.label ?? '')
                          .where((label) => label.isNotEmpty)
                          .toList();

                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ReusableCountryBottomSheet(
                              title: 'Purchase Account',
                              items: accountLabels,
                              onSelect: (selected) {
                                final selectedItem = allItems.firstWhere(
                                  (e) => e.label == selected,
                                  orElse: () => AccountItem(),
                                );

                                if (selectedItem.label != null &&
                                    selectedItem.value != null) {
                                  // Update UI label
                                  notifier.updateField(
                                      'purchaseAccount', selectedItem.label!);

                                  // Update API field (ID)
                                  notifier.updatePurchaseInfo(
                                      purchaseAccount: selectedItem.value!);
                                }
                                debugPrint(
                                    '✅ Selected Purchase Account Label: ${selectedItem.label}');
                                debugPrint(
                                    '✅ Selected Purchase Account ID: ${selectedItem.value}');
                              }),
                        );
                      }
                    },
                  ),

                  ReusableSizedBox(height: 15),
                  if (notifier.state.purchaseInformation.purchaseType == 2)
                    ReusableColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PayzoBottomsheetNavigator(
                            required: true,
                            isPayzoColor: true,
                            title: 'Category Type',
                            errorText:product.errors?['categoryType'] ,
                            trailing: product.categoryType ?? 'Tap to select',
                            onTap: () async {
                              await ref
                                  .read(focusUtilsProvider)
                                  .unfocusAndDelay();
                              final assetData = await ref
                                  .read(fetchAssertDetailsProvider.future);
                              final categories = assetData.categoryList ?? [];

                              final categoryNames = categories
                                  .map((e) => e.categoryType ?? '')
                                  .where((name) => name.isNotEmpty)
                                  .toList();

                              if (context.mounted) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => ReusableCountryBottomSheet(
                                    title: 'Select Category Type',
                                    items: categoryNames,
                                    onSelect: (selectedName) {
                                      final selectedItem =
                                          categories.firstWhere(
                                        (e) => e.categoryType == selectedName,
                                        orElse: () => categories.first,
                                      );

                                      notifier.updateField('categoryType',
                                          selectedItem.categoryType ?? '');
                                      notifier.updatePurchaseInfo(
                                          categoryType: selectedItem.id);
                                      debugPrint(
                                          "✅ Category selected: ${selectedItem.categoryType}, ID: ${notifier.state.purchaseInformation.categoryType}");
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          ReusableSizedBox(height: 15),
                        ]),
                  CustomDescriptionField(
                      title: 'Description',
                      controller: controllers['purchaseDescription']!,
                      onChanged: (val) =>
                          notifier.updatePurchaseInfo(description: val)),
                  ReusableSizedBox(height: 15),
                  CustomDescriptionField(
                    title: 'Description(Arabic)',
                    controller: controllers['purchaseDescriptionArabic']!,
                    onChanged: (val) =>
                        notifier.updatePurchaseInfo(descriptionArabic: val)
                  ),
                  if (product.purchaseInformation.purchaseType == 1)
                    ReusableColumn(
                      children: [
                        ReusableSizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            notifier.updateField(
                                'inventoryFlag', !product.inventoryFlag);
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  checkboxTheme: CheckboxThemeData(
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                child: Checkbox(
                                  activeColor: AppColors.appMainColor,
                                  value: product.inventoryFlag,
                                  onChanged: (value) {
                                    notifier.updateField(
                                        'inventoryFlag', value);
                                  },
                                ),
                              ),
                              ReusableText(
                                text: 'Track Inventory for this Item',
                                fontFamily: 'SF Pro Display',
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color.fromRGBO(51, 51, 51, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (product.purchaseInformation.purchaseType == 1 &&
                      product.inventoryFlag == true)
                    ReusableColumn(children: [
                      ReusableSizedBox(height: 15),
                      PayzoBottomsheetNavigator(
                        errorText: product.errors?['stockAccount'],
                        required: true,
                        title: 'Inventory Account',
                        trailing: product.inventoryDto.stockAccountName.isEmpty
                            ? 'Tap to Select'
                            : product.inventoryDto.stockAccountName,
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

                                  notifier.updateInventoryDto(
                                    stockAccountId: selectedAccount.value ?? 0,
                                    stockAccountName:
                                        selectedAccount.label ?? '',
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      PayzoInputField(
                          required: true,
                          label: 'Opening Stock',
                          inputFormatters: PayzoInputFormatters.noSpecialChars,
                          errorText: product.errors?['stockCurrency'] ?? '',
                          controller: controllers['openingStock'],
                          onChanged: (val) {
                            notifier.updateInventoryDto(
                                openingStock: double.parse(val));
                            // ✅ Access updated state directly from the notifier
                            final updatedState = notifier.state;
                            debugPrint(
                                '✅ Purchase Info costPrice: ${updatedState.inventoryDto.openingStock}');
                          }),
                      PayzoInputField(
                        required: true,
                        leading: SarTextfield(
                          title: product.inventoryDto.stockCurrencyName.isEmpty
                              ? 'SAR'
                              : product.inventoryDto.stockCurrencyName,
                          onTap: () async {
                            final currencyList = await ref
                                .read(fetchPriceCurrencyProvider.future);

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
                                      (e) =>
                                          e.currencyValue == selectedCurrency,
                                      orElse: () => currencyList.first,
                                    );

                                    notifier.updateInventoryDto(
                                      stockCurrency:
                                          selected.currencyId?.toInt() ?? 0,
                                      stockCurrencyName:
                                          selected.currencyValue ??
                                              '', // <-- Add this
                                    );

                                    debugPrint(
                                        '✅ Selected Currency: ${selected.currencyValue}, ID: ${selected.currencyId}');
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        label: 'Opening Stock Rate per Unit',
                        errorText: product.errors?['openingStockRate'] ?? '',
                        controller: controllers['openingStockRate'],
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final parsed = double.tryParse(val);
                          if (parsed != null) {
                            notifier.updateInventoryDto(
                                openingStockRate: parsed);
                            debugPrint(
                                '✅ Updated Opening Stock: ${notifier.state.inventoryDto.openingStockRate}');
                          }
                        },
                      )
                    ])
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
