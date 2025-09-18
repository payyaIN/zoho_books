import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_customer/add_customer_repository.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/view/add/add_vendor/notifier/add_vendor_notifier.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/utils/common_widgets/sar_textfield.dart';
import '../../../../import_data.dart';

class CustomerTypeWidget extends ConsumerWidget {
  final Map<String, TextEditingController>? controller;
  final TextEditingController openingAmountController;

  const CustomerTypeWidget(this.controller, this.openingAmountController,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCustomerExpanded = ref.watch(customerTileExpandedProvider);
    final notifier = ref.read(customerFormProvider.notifier);
    final customer = ref.watch(customerFormProvider);
    final countryList = ref.watch(getCountryList);
    final currencyName = ref.watch(openingBalanceProvider);
    final branchName = ref.watch(openingAmountProvider);

    final Map<String, String> labelToFieldKey = {
      "First Name": "firstName",
      "First Name (Arabic)": "firstNameArabic",
      "Last Name": "secondName",
      "Last Name (Arabic)": "lastNameArabic",
      "Company Name": "companyName",
      "Company Name (Arabic)": "companyNameArabic",
      "Email": "email",
      "Mobile": "mobile",
      "Work Phone Number": "workPhone",
      "Display Name": "displayName",
      "VAT Number": "vatNumber",
      "CR Number": "crNum",
    };

    return ReusablePadding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
      child: CustomExpansionTile(
        height: 466,
        title: "Customer type",
        isExpanded: isCustomerExpanded,
        onToggle: () {
          ref.read(customerTileExpandedProvider.notifier).state =
              !isCustomerExpanded;
        },
        child: ReusableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormRadioButton(
              value: 'Business',
              groupValue: customer.customerType,
              title: 'Business',
              onChanged: (value) {
                if (value != null) {
                  print("✅ Selected Customer Type: $value"); // Debug print
                  notifier.updateCustomerType(value);
                }
              },
            ),
            const SizedBox(height: 15),
            FormRadioButton(
              value: 'Individual',
              groupValue: customer.customerType,
              title: 'Individual',
              onChanged: (value) {
                if (value != null) {
                  print("✅ Selected Customer Type: $value"); // Debug print
                  notifier.updateCustomerType(value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Divider(
                color: Color.fromRGBO(228, 228, 228, 1), thickness: 1),
            ReusableColumn(
              children: labelToFieldKey.entries.map((entry) {
                final label = entry.key;
                final fieldKey = entry.value;
                final isWorkPhone = label == 'Work Phone Number';
                final isMobile = label == 'Mobile';

                return PayzoInputField(
                  keyboardType: isWorkPhone || isMobile
                      ? TextInputType.numberWithOptions()
                      : fieldKey == 'firstName' ||
                              fieldKey == 'secondName' ||
                              fieldKey == 'companyName'
                          ? TextInputType.name
                          : TextInputType.emailAddress,
                  inputFormatters: fieldKey == 'firstName' ||
                          fieldKey == 'secondName' ||
                          fieldKey == 'companyName'
                      ? PayzoInputFormatters.onlyAlphabets
                      : isWorkPhone || isMobile
                          ? PayzoInputFormatters.mobileNumber
                          : fieldKey == 'vatNumber'
                              ? PayzoInputFormatters.saudiVatNumber
                              : fieldKey == 'crNumber'
                                  ? PayzoInputFormatters.saudiCrNumber
                                  : PayzoInputFormatters.email,
                  label: label,
                  controller: controller![fieldKey],
                  required: isWorkPhone ? false : true,
                  errorText: customer.errors[fieldKey],
                  countryFlagCode: isWorkPhone
                      ? ref.watch(countryFlagCustomerProvider)
                      : isMobile
                          ? ref.watch(countryFlagCustomerMobileProvider)
                          : null,
                  countryTap: isWorkPhone || isMobile
                      ? () async {
                          await ref.read(focusUtilsProvider).unfocusAndDelay();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => countryList.when(
                              data: (data) => ReusableCountryBottomSheet(
                                title: 'Countries',
                                items: data.response
                                        ?.map((e) => e.countryName!)
                                        .toList() ??
                                    [],
                                onSelect: (selectedCountry) {
                                  final selected = data.response?.firstWhere(
                                    (e) => e.countryName == selectedCountry,
                                  );
                                  if (selected != null) {
                                    final code =
                                        selected.ccphnCode?.toString() ?? '';
                                    final flag =
                                        selected.countryFlag?.toString() ?? '';

                                    if (isWorkPhone) {
                                      ref
                                          .read(countryPhoneCustomerProvider
                                              .notifier)
                                          .state = code;
                                      ref
                                          .read(countryFlagCustomerProvider
                                              .notifier)
                                          .state = flag;
                                      notifier.updateField('phoneCode', code);
                                    } else if (isMobile) {
                                      ref
                                          .read(
                                              countryPhoneCustomerMobileProvider
                                                  .notifier)
                                          .state = code;
                                      ref
                                          .read(
                                              countryFlagCustomerMobileProvider
                                                  .notifier)
                                          .state = flag;
                                      notifier.updateField('mobileCode', code);
                                    }
                                  }
                                },
                              ),
                              error: (err, _) {
                                print('error loading countries: $err');
                                return const SizedBox();
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                          );
                        }
                      : null,
                  onChanged: (value) => notifier.updateField(fieldKey, value),
                );
              }).toList(),
            ),
            PayzoBottomsheetNavigator(
              // required: true,
              title: 'Opening Balance',
              isPayzoColor: true,
              trailing: branchName,
              // errorText: customer.errors['branchId'],
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
                              title: 'Select Opening Balance',
                              items: branches,
                              onSelect: (selectedName) {
                                final selectedBranch = data.data?.firstWhere(
                                  (b) => b.namePrimary == selectedName,
                                  orElse: () => data.data!.first,
                                );

                                if (selectedBranch != null) {
                                  notifier.updateField('branchId',
                                      selectedBranch.branchId.toString());
                                  ref
                                      .read(openingAmountProvider.notifier)
                                      .state = selectedBranch.nameSecondary!;
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
              leading: SarTextfield(
                title: customer.currencyId == '' ? 'SAR' : currencyName,
                onTap: () async {
                  final currencyList =
                      await ref.read(fetchPriceCurrencyProvider.future);

                  final currencyLabels = currencyList
                      .map((e) => e.currencyValue ?? '')
                      .where((e) => e.isNotEmpty)
                      .toSet()
                      .toList();

                  if (context.mounted) {
                    await ref.read(focusUtilsProvider).unfocusAndDelay();
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
                          notifier.updateField(
                              'currencyId', selected.currencyId.toString());
                          ref.read(openingBalanceProvider.notifier).state =
                              selected.currencyValue!;
                          debugPrint(
                              '✅ Selected Currency: ${selected.currencyValue}, ID: ${selected.currencyId}');
                        },
                      ),
                    );
                  }
                },
              ),
              label: 'Opening Amount',
              keyboardType: TextInputType.number,
              controller: openingAmountController,
              onChanged: (val) {
                final parsed = double.tryParse(val);
                if (parsed != null) {
                  notifier.updateField('openingAmount', val);
                  debugPrint(
                      '✅ Updated Opening Stock: ${notifier.state.openingAmount}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
