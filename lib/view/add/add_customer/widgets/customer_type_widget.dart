// customer_type_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_customer/add_customer_repository.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/view/add/add_vendor/notifier/add_vendor_notifier.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/utils/common_widgets/sar_textfield.dart';
import '../../../../data/repository/add_vendor/get_country_list_repository.dart';
import '../../../../import_data.dart';
import '../../../../utils/common_widgets/form_check_box.dart';
import '../providers/add_customer_providers.dart';

class CustomerTypeWidget extends ConsumerWidget {
  final Map<String, TextEditingController> controller;
  final TextEditingController openingAmountController;

  const CustomerTypeWidget(this.controller, this.openingAmountController, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCustomerExpanded = ref.watch(customerTileExpandedProvider);
    final notifier = ref.read(customerFormProvider.notifier);
    final customer = ref.watch(customerFormProvider);
    final countryList = ref.watch(getCountryList);
    final currencyName = ref.watch(openingBalanceProvider);

    // Errors map from notifier provider
    final errors = ref.watch(customerErrorsProvider);

    // Fields mapping (Primary Contact, Arabic names, Company info)
    final List<Map<String, String>> fields = [
      {'label': 'First Name', 'key': 'firstName'},
      {'label': 'First Name (Arabic)', 'key': 'firstNameArabic'},
      {'label': 'Last Name', 'key': 'secondName'},
      {'label': 'Last Name (Arabic)', 'key': 'secondNameArabic'},
      {'label': 'Company Name*', 'key': 'companyName'},
      {'label': 'Company Name (Arabic)*', 'key': 'companyNameArabic'},
      {'label': 'Email Address', 'key': 'email'},
      {'label': 'Mobile Number', 'key': 'mobile'},
      {'label': 'Work Phone Number', 'key': 'workPhone'},
      {'label': 'VAT Number', 'key': 'vatNumber'},
      {'label': 'Customer CR', 'key': 'crNum'},
    ];

    return ReusablePadding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
      child: CustomExpansionTile(
        height: 520,
        title: "Customer type",
        isExpanded: isCustomerExpanded,
        onToggle: () {
          ref.read(customerTileExpandedProvider.notifier).state = !isCustomerExpanded;
        },
        child: ReusableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Type radios
            FormRadioButton(
              value: 'BUSINESS',
              groupValue: customer.customerType ?? 'BUSINESS',
              title: 'Business',
              onChanged: (value) {
                if (value != null) {
                  notifier.state = notifier.state.copyWith(customerType: value);
                }
              },
            ),
            const SizedBox(height: 12),
            FormRadioButton(
              value: 'INDIVIDUAL',
              groupValue: customer.customerType ?? 'BUSINESS',
              title: 'Individual',
              onChanged: (value) {
                if (value != null) {
                  notifier.state = notifier.state.copyWith(customerType: value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Divider(color: Color.fromRGBO(228, 228, 228, 1), thickness: 1),
            const SizedBox(height: 8),

            // Primary & Company fields (including Arabic)
            ReusableColumn(
              children: fields.map((m) {
                final label = m['label']!;
                final key = m['key']!;
                final isPhoneField = key == 'workPhone' || key == 'mobile';

                final keyboardType = isPhoneField ? TextInputType.numberWithOptions() : TextInputType.text;

                final inputFormatter = (key == 'firstName' ||
                    key == 'secondName' ||
                    key == 'companyName' ||
                    key == 'firstNameArabic' ||
                    key == 'secondNameArabic' ||
                    key == 'companyNameArabic')
                    ? PayzoInputFormatters.onlyAlphabets
                    : isPhoneField
                    ? PayzoInputFormatters.mobileNumber
                    : PayzoInputFormatters.email;

                return PayzoInputField(
                  label: label,
                  controller: controller[key],
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatter,
                  required: key == 'companyName' || key == 'companyNameArabic',
                  errorText: errors[key],
                  countryFlagCode: key == 'workPhone'
                      ? ref.watch(countryFlagCustomerProvider)
                      : key == 'mobile'
                      ? ref.watch(countryFlagCustomerMobileProvider)
                      : null,
                  countryTap: (key == 'workPhone' || key == 'mobile')
                      ? () async {
                    await ref.read(focusUtilsProvider).unfocusAndDelay();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => countryList.when(
                        data: (data) {
                          final items = (data.response ?? [])
                              .map((e) => e.countryName ?? '')
                              .where((s) => s.isNotEmpty)
                              .toList();
                          return ReusableCountryBottomSheet(
                            title: 'Countries',
                            items: items,
                            onSelect: (selectedCountry) {
                              final selected = (data.response ?? []).firstWhere(
                                    (e) => e.countryName == selectedCountry,
                                orElse: () => (data.response ?? []).first,
                              );

                              final code = (selected.ccphnCode?.toString() ?? '');
                              final flag = (selected.countryFlag?.toString() ?? '');

                              if (key == 'workPhone') {
                                ref.read(countryPhoneCustomerProvider.notifier).state = code;
                                ref.read(countryFlagCustomerProvider.notifier).state = flag;
                                notifier.updateField('phoneCode', code);
                              } else {
                                ref.read(countryPhoneCustomerMobileProvider.notifier).state = code;
                                ref.read(countryFlagCustomerMobileProvider.notifier).state = flag;
                                notifier.updateField('mobileCode', code);
                              }
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) {
                          debugPrint('error loading countries: $err');
                          return const SizedBox();
                        },
                      ),
                    );
                  }
                      : null,
                  onChanged: (val) {
                    notifier.updateField(key, val);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Taxed & Government checkboxes
            FormCheckbox(
              value: customer.taxedOrganization ?? false,
              onChanged: (v) =>
              notifier.state = notifier.state.copyWith(taxedOrganization: v ?? false),
              title: 'Is this customer a taxed organization?',
            ),
            const SizedBox(height: 8),
            FormCheckbox(
              value: customer.governmentEntity ?? false,
              onChanged: (v) =>
              notifier.state = notifier.state.copyWith(governmentEntity: v ?? false),
              title: 'Is this customer a government entity?',
            ),

            const SizedBox(height: 12),

            // Opening amount selector
            PayzoInputField(
              leading: SarTextfield(
                title: (customer.openingBalance?.currency == null)
                    ? 'SAR'
                    : currencyName,
                onTap: () async {
                  final currencyList =
                  await ref.read(fetchPriceCurrencyProvider.future);

                  final currencyLabels = currencyList
                      .map((e) => e.currencyValue ?? '')
                      .where((e) => e.isNotEmpty)
                      .toSet()
                      .toList();

                  if (!context.mounted) return;
                  await ref.read(focusUtilsProvider).unfocusAndDelay();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => ReusableCountryBottomSheet(
                      title: 'Select Currency',
                      items: currencyLabels,
                      onSelect: (selectedCurrency) {
                        final selected = currencyList.firstWhere(
                              (e) => e.currencyValue == selectedCurrency,
                          orElse: () => currencyList.first,
                        );
                        notifier.updateField(
                            'currencyId', (selected.currencyId ?? '').toString());
                        ref
                            .read(openingBalanceProvider.notifier)
                            .state = selected.currencyValue ?? 'SAR';
                        debugPrint(
                            '✅ Selected Currency: ${selected.currencyValue}, ID: ${selected.currencyId}');
                      },
                    ),
                  );
                },
              ),
              label: 'Opening Amount',
              keyboardType: TextInputType.number,
              controller: openingAmountController,
              onChanged: (val) {
                final parsed = double.tryParse(val);
                if (parsed != null) {
                  notifier.updateField('openingAmount', val);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
