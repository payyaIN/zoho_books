import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_customer/add_customer_repository.dart';
import 'package:payzo_books/data/repository/add_vendor/add_vendor_repository.dart';
import 'package:payzo_books/data/repository/add_vendor/get_state_list_repository.dart';
import 'package:payzo_books/data/repository/vendor_api/vendor_listing/vendor_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/common_widgets/reusable_snackbar.dart';
import 'package:payzo_books/view/add/add_vendor/notifier/add_vendor_notifier.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/utils/common_widgets/sar_textfield.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';

import '../../../data/repository/add_vendor/get_country_list_repository.dart';

final vendorBillingTileExpandedProvider = StateProvider<bool>((ref) => false);
final vendorShippingTileExpandedProvider = StateProvider<bool>((ref) => false);
final sameAsBillingToggleProvider = StateProvider<bool>((ref) => false);

class AddVendor extends ConsumerStatefulWidget {
  const AddVendor({super.key});

  @override
  ConsumerState<AddVendor> createState() => _AddVendorState();
}

class _AddVendorState extends ConsumerState<AddVendor> {
  final vendorControllers = <String, TextEditingController>{
    'firstName': TextEditingController(),
    'firstNameArabic': TextEditingController(),
    'secondName': TextEditingController(),
    'secondNameArabic': TextEditingController(),
    'companyName': TextEditingController(),
    'companyNameArabic': TextEditingController(),
    'email': TextEditingController(),
    'mobile': TextEditingController(),
    'workPhone': TextEditingController(),
    'vatNumber': TextEditingController(),
    'crNumber': TextEditingController(),
  };
  TextEditingController openingAmount = TextEditingController();
  final topSectionLabels = <String, String>{
    'firstName': 'First Name',
    'firstNameArabic': 'First Name(Arabic)',
    'secondName': 'Last Name',
    'secondNameArabic': 'Last Name(Arabic)',
    'companyName': 'Company Name',
    'companyNameArabic': 'Company Name(Arabic)',
    'email': 'Email',
    'mobile': 'Mobile',
    'workPhone': 'Work Phone',
    'vatNumber': 'VAT Number',
    'crNumber': 'CR Number',
  };
  final billingAddressLabels = <String, String>{
    'building': 'Building Number',
    // 'street': 'Street',
    'streetAddress': 'Street Address',
    'city': 'City',
    'streetAddressArabic': 'Street Address (Arabic)',
    'cityArabic': 'City (Arabic)',
    'zip': 'Zip',
  };
  final shippingAddressLabels = <String, String>{
    'building': 'Building Number',
    // 'street': 'Street',
    'streetAddress': 'Street Address',
    'city': 'City',
    'streetAddressArabic': 'Street Address (Arabic)',
    'cityArabic': 'City (Arabic)',
    'zip': 'Zip',
  };

  final billingControllers = <String, TextEditingController>{
    // 'country': TextEditingController(),
    // 'state': TextEditingController(),
    'building': TextEditingController(),
    // 'street': TextEditingController(),
    'streetAddress': TextEditingController(),
    'streetAddressArabic': TextEditingController(),
    'city': TextEditingController(),
    'cityArabic': TextEditingController(),
    'zip': TextEditingController(),
  };

  final shippingControllers = <String, TextEditingController>{
    // 'country': TextEditingController(),
    // 'state': TextEditingController(),
    'building': TextEditingController(),
    // 'street': TextEditingController(),
    'streetAddress': TextEditingController(),
    'streetAddressArabic': TextEditingController(),
    'city': TextEditingController(),
    'cityArabic': TextEditingController(),
    'zip': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();

    // Preload country and state lists
    Future.microtask(() {
      ref.read(getCountryList);
      ref.read(getStateList);
      ref.watch(fetchBranchListProvider);
      ref.watch(fetchPriceCurrencyProvider);
    });
  }

  @override
  void dispose() {
    vendorControllers.values.forEach((c) => c.dispose());
    billingControllers.values.forEach((c) => c.dispose());
    shippingControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorState = ref.watch(vendorFormProvider);
    final notifier = ref.read(vendorFormProvider.notifier);
    final isBillingExpanded = ref.watch(vendorBillingTileExpandedProvider);
    final isShippingExpanded = ref.watch(vendorShippingTileExpandedProvider);
    final state = ref.read(vendorFormProvider);
    final data = ref.watch(getCountryList);
    final stateData = ref.watch(getStateList);
    final sameAsBilling = ref.watch(sameAsBillingToggleProvider);
    final customer = ref.watch(customerFormProvider);
    final countryList = ref.watch(getCountryList);
    final currencyName = ref.watch(openingBalanceProvider);
    final branchName = ref.watch(openingAmountProvider);
    final sameAddress = ref.read(sameAsBillingToggleProvider.notifier).state;

    return ScalingFactor(
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            final notifier = ref.read(vendorFormProvider.notifier);
            notifier.clearForm();
            ref.read(sameAsBillingToggleProvider.notifier).state = false;
            for (final controller in vendorControllers.values) {
              controller.clear();
            }
            for (final controller in billingControllers.values) {
              controller.clear();
            }
            for (final controller in shippingControllers.values) {
              controller.clear();
            }
          }
        },
        child: Scaffold(
          appBar: reusableAppBar(
              title: 'Add Vendor', context: context, showBackButton: true),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(22),
            child: ReusableColumn(
              children: [
                FormContainer(
                  height: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 15, right: 15, bottom: 18),
                    child: ReusableColumn(
                      children: [
                        ReusableColumn(
                          children: vendorControllers.entries
                              .map((entry) => PayzoInputField(
                                    label: topSectionLabels[entry.key] ??
                                        entry.key,
                                    inputFormatters: entry.key == 'workPhone'
                                        ? PayzoInputFormatters.mobileNumber
                                        : entry.key == 'vatNumber'
                                            ? PayzoInputFormatters
                                                .saudiVatNumber
                                            : entry.key == 'crNumber'
                                                ? PayzoInputFormatters
                                                    .saudiCrNumber
                                                : entry.key == 'mobile'
                                                    ? PayzoInputFormatters
                                                        .mobileNumber
                                                    : entry.key == 'email'
                                                        ? PayzoInputFormatters
                                                            .email
                                                        : entry.key ==
                                                                    'firstNameArabic' ||
                                                                entry.key ==
                                                                    'secondNameArabic' ||
                                                                entry.key ==
                                                                    'companyNameArabic'
                                                            ? PayzoInputFormatters
                                                                .onlyArabic
                                                            : PayzoInputFormatters
                                                                .onlyAlphabets,
                                    keyboardType: entry.key == 'workPhone' ||
                                            entry.key == 'mobile' ||
                                            entry.key == 'vatNumber' ||
                                            entry.key == 'crNumber'
                                        ? TextInputType.phone
                                        : entry.key == 'email'
                                            ? TextInputType.emailAddress
                                            : TextInputType.text,
                                    required: entry.key == 'companyName' ||
                                            entry.key == 'companyNameArabic'
                                        ? true
                                        : false,
                                    countryTap: entry.key == 'workPhone'
                                        ? () async {
                                            await ref
                                                .read(focusUtilsProvider)
                                                .unfocusAndDelay();
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (_) => data.when(
                                                data: (data) =>
                                                    ReusableCountryBottomSheet(
                                                  title: 'Countries',
                                                  items: data.response
                                                          ?.map((e) =>
                                                              e.countryName!)
                                                          .toList() ??
                                                      [],
                                                  onSelect: (selectedCountry) {
                                                    final selected = data
                                                        .response
                                                        ?.firstWhere(
                                                      (element) =>
                                                          element.countryName ==
                                                          selectedCountry,
                                                    );
                                                    if (selected != null) {
                                                      ref
                                                          .read(
                                                              countryPhoneProvider
                                                                  .notifier)
                                                          .state = selected
                                                              .ccphnCode
                                                              ?.toString() ??
                                                          '';
                                                      ref
                                                          .read(
                                                              countryFlagProvider
                                                                  .notifier)
                                                          .state = selected
                                                              .countryFlag
                                                              ?.toString() ??
                                                          '';
                                                      notifier.updateField(
                                                          'phoneCode',
                                                          selected.ccphnCode
                                                                  ?.toString() ??
                                                              ''); // ✅ Added for workPhone
                                                    }
                                                  },
                                                ),
                                                error: (err, _) {
                                                  print(_);
                                                  print('error is $err');
                                                  return SizedBox();
                                                },
                                                loading: () => ReusableSizedBox(
                                                  width: 10,
                                                  height: 10,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            );
                                          }
                                        : () async {
                                            await ref
                                                .read(focusUtilsProvider)
                                                .unfocusAndDelay();
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (_) => data.when(
                                                data: (data) =>
                                                    ReusableCountryBottomSheet(
                                                  title: 'Countries',
                                                  items: data.response
                                                          ?.map((e) =>
                                                              e.countryName!)
                                                          .toList() ??
                                                      [],
                                                  onSelect: (selectedCountry) {
                                                    final selected = data
                                                        .response
                                                        ?.firstWhere(
                                                      (element) =>
                                                          element.countryName ==
                                                          selectedCountry,
                                                    );
                                                    if (selected != null) {
                                                      ref
                                                          .read(
                                                              countryPhoneMobileProvider
                                                                  .notifier)
                                                          .state = selected
                                                              .ccphnCode
                                                              ?.toString() ??
                                                          '';
                                                      ref
                                                          .read(
                                                              countryFlagMobileProvider
                                                                  .notifier)
                                                          .state = selected
                                                              .countryFlag
                                                              ?.toString() ??
                                                          '';
                                                      notifier.updateField(
                                                          'mobileCode',
                                                          selected.ccphnCode
                                                                  ?.toString() ??
                                                              ''); // ✅ Added for mobile
                                                    }
                                                  },
                                                ),
                                                error: (err, _) {
                                                  print(_);
                                                  print('error is $err');
                                                  return SizedBox();
                                                },
                                                loading: () => ReusableSizedBox(
                                                  width: 10,
                                                  height: 10,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            );
                                          },
                                    controller: entry.value,
                                    errorText: vendorState.errors[entry.key],
                                    countryFlagCode: entry.key == 'workPhone'
                                        ? ref.watch(countryFlagProvider)
                                        : entry.key == 'mobile'
                                            ? ref.watch(
                                                countryFlagMobileProvider)
                                            : null,
                                    onChanged: (value) =>
                                        notifier.updateField(entry.key, value),
                                  ))
                              .toList(),
                        ),
                        // PayzoBottomsheetNavigator(
                        //   title: 'Opening Balance',
                        //   isPayzoColor: true,
                        //   trailing: branchName,
                        //   // errorText: customer.errors['branchId'],
                        //   onTap: () async {
                        //     await ref
                        //         .read(focusUtilsProvider)
                        //         .unfocusAndDelay();
                        //
                        //     showModalBottomSheet(
                        //       context: context,
                        //       isScrollControlled: true,
                        //       backgroundColor: Colors.transparent,
                        //       builder: (context) {
                        //         return Consumer(
                        //           builder: (context, ref, _) {
                        //             final branchAsync =
                        //                 ref.watch(fetchBranchListProvider);
                        //
                        //             return branchAsync.when(
                        //               data: (data) {
                        //                 final branches = data.data
                        //                         ?.map(
                        //                             (b) => b.namePrimary ?? '')
                        //                         .where(
                        //                             (name) => name.isNotEmpty)
                        //                         .toList() ??
                        //                     [];
                        //
                        //                 return ReusableCountryBottomSheet(
                        //                   title: 'Select Opening Balance',
                        //                   items: branches,
                        //                   onSelect: (selectedName) {
                        //                     final selectedBranch =
                        //                         data.data?.firstWhere(
                        //                       (b) =>
                        //                           b.namePrimary == selectedName,
                        //                       orElse: () => data.data!.first,
                        //                     );
                        //
                        //                     if (selectedBranch != null) {
                        //                       notifier
                        //                           .updateOpeningBalanceField(
                        //                               'branch',
                        //                               selectedBranch.branchId);
                        //                       ref
                        //                               .read(
                        //                                   openingAmountProvider
                        //                                       .notifier)
                        //                               .state =
                        //                           selectedBranch.nameSecondary!;
                        //                     }
                        //                   },
                        //                 );
                        //               },
                        //               loading: () => const Center(
                        //                   child: CircularProgressIndicator()),
                        //               error: (err, _) => Center(
                        //                   child: Text(
                        //                       'Failed to load branches: $err')),
                        //             );
                        //           },
                        //         );
                        //       },
                        //     );
                        //   },
                        // ),
                        // PayzoInputField(
                        //   leading: SarTextfield(
                        //     title: () {
                        //       final currencyId = vendorState
                        //               .openingBalance['currency']
                        //               ?.toString() ??
                        //           '';
                        //       if (currencyId.isEmpty) return 'SAR';
                        //
                        //       // Fetch currency list synchronously if already cached in provider
                        //       final currencyListAsync =
                        //           ref.watch(fetchPriceCurrencyProvider);
                        //
                        //       return currencyListAsync.when(
                        //         data: (currencyList) {
                        //           final selected = currencyList.firstWhere(
                        //             (e) =>
                        //                 e.currencyId.toString() == currencyId,
                        //             orElse: () => currencyList.first,
                        //           );
                        //           return selected.currencyValue ?? 'SAR';
                        //         },
                        //         loading: () => 'Loading...',
                        //         error: (_, __) => 'SAR',
                        //       );
                        //     }(),
                        //     onTap: () async {
                        //       final currencyList = await ref
                        //           .read(fetchPriceCurrencyProvider.future);
                        //
                        //       final currencyLabels = currencyList
                        //           .map((e) => e.currencyValue ?? '')
                        //           .where((e) => e.isNotEmpty)
                        //           .toSet()
                        //           .toList();
                        //
                        //
                        //       if (context.mounted) {
                        //         await ref
                        //             .read(focusUtilsProvider)
                        //             .unfocusAndDelay();
                        //         showModalBottomSheet(
                        //           context: context,
                        //           isScrollControlled: true,
                        //           backgroundColor: Colors.transparent,
                        //           builder: (_) => ReusableCountryBottomSheet(
                        //             title: 'Select Currency',
                        //             items: currencyLabels,
                        //             onSelect: (selectedCurrency) {
                        //               final selected = currencyList.firstWhere(
                        //                 (e) =>
                        //                     e.currencyValue == selectedCurrency,
                        //                 orElse: () => currencyList.first,
                        //               );
                        //               notifier.updateOpeningBalanceField(
                        //                   'currency', selected.currencyId);
                        //               ref
                        //                   .read(openingBalanceProvider.notifier)
                        //                   .state = selected.currencyValue!;
                        //               debugPrint(
                        //                   '✅ Selected Currency: ${selected.currencyValue}, ID: ${selected.currencyId}');
                        //             },
                        //           ),
                        //         );
                        //       }
                        //     },
                        //   ),
                        //   label: 'Opening Amount',
                        //   controller: openingAmount,
                        //   errorText: customer.errors['currencyId'],
                        //   keyboardType: TextInputType.number,
                        //   onChanged: (val) {
                        //     final parsed = double.tryParse(val);
                        //     if (parsed != null) {
                        //       notifier.updateOpeningBalanceField('amount', val);
                        //       debugPrint('✅ Updated Opening Amount: $val');
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                CustomExpansionTile(
                  title: 'Billing Address',
                  isExpanded: isBillingExpanded,
                  onToggle: () => ref
                      .read(vendorBillingTileExpandedProvider.notifier)
                      .state = !isBillingExpanded,
                  height: 0,
                  child: ReusableColumn(
                    children: [
                      PayzoBottomsheetNavigator(
                        onUnselect: () {
                          notifier.clearBillingCountry();
                          showPayzoSnackBar(
                              context: context,
                              ref: ref,
                              message: 'Billing Country cleared',
                              type: PayzoSnackType.success);
                        },
                        required: true,
                        title: 'Country',
                        errorText: vendorState.errors['billing_country'],
                        trailing: state.billingAddress['country']!.isEmpty ||
                                state.billingAddress['country'] == ''
                            ? 'Tap to Select'
                            : '${state.billingAddress['country']}',
                        isPayzoColor: true,
                        onTap: () async {
                          await ref.read(focusUtilsProvider).unfocusAndDelay();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => data.when(
                                data: (data) => ReusableCountryBottomSheet(
                                      title: 'Countries',
                                      items: data.response
                                              ?.map((e) => e.countryName ?? '')
                                              .toList() ??
                                          [],
                                      onSelect: (selectedCountry) {
                                        final selected = data.response
                                            ?.firstWhere((element) =>
                                                element.countryName ==
                                                selectedCountry);
                                        if (selected != null) {
                                          notifier.updateBillingAddress(
                                              'country',
                                              selected.countryName ?? '');
                                          ref
                                                  .read(countryCodeProvider
                                                      .notifier)
                                                  .state =
                                              selected.ccid?.toString() ?? '';
                                        }
                                      },
                                    ),
                                error: (err, _) {
                                  print(_);
                                  print('error is $err');
                                  return SizedBox();
                                },
                                loading: () => ReusableSizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator())),
                          );
                        },
                      ),
                      PayzoBottomsheetNavigator(
                        required: true,
                        title: 'State',
                        errorText: vendorState.errors['billing_state'],
                        trailing: state.billingAddress['state']!.isEmpty ||
                                state.billingAddress['state'] == ''
                            ? 'Tap to Select'
                            : '${state.billingAddress['state']}',
                        isPayzoColor: true,
                        onUnselect: () {
                          notifier.clearBillingState();
                          showPayzoSnackBar(
                              context: context,
                              ref: ref,
                              message: 'Billing state cleared',
                              type: PayzoSnackType.success);
                        },
                        onTap: () async {
                          await ref.read(focusUtilsProvider).unfocusAndDelay();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => stateData.when(
                                data: (data) => ReusableCountryBottomSheet(
                                      title: 'State',
                                      items: data.response
                                              ?.map((e) => e.rName ?? '')
                                              .toList() ??
                                          [],
                                      onSelect: (selectedCountry) {
                                        notifier.updateBillingAddress(
                                            'state', selectedCountry);
                                      },
                                    ),
                                error: (err, _) {
                                  print(_);
                                  print('error is $err');
                                  return SizedBox();
                                },
                                loading: () => ReusableSizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator())),
                          );
                        },
                      ),
                      ReusableColumn(
                        children: billingControllers.entries
                            .map((entry) => PayzoInputField(
                                label: billingAddressLabels[entry.key] ??
                                    entry.key,
                                keyboardType: entry.key == 'building' ||
                                        entry.key == 'zip'
                                    ? TextInputType.numberWithOptions()
                                    : TextInputType.text,
                                inputFormatters: entry.key == 'building' ||
                                        entry.key == 'zip'
                                    ? PayzoInputFormatters.onlyFiveDigits
                                    : entry.key == 'street'
                                        ? PayzoInputFormatters.street
                                        : PayzoInputFormatters.city,
                                controller: entry.value,
                                required: entry.key == 'city' ||
                                    entry.key == 'cityArabic',
                                errorText:
                                    vendorState.errors['billing_${entry.key}'],
                                onChanged: (value) {
                                  notifier.updateBillingAddress(
                                      entry.key, value);

                                  // ✅ Also update shipping if sameAsBilling toggle is ON
                                  if (ref.read(sameAsBillingToggleProvider)) {
                                    if (shippingControllers
                                        .containsKey(entry.key)) {
                                      shippingControllers[entry.key]?.text =
                                          value;
                                    }
                                    notifier.updateShippingAddress(
                                        entry.key, value);
                                  }
                                }))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                FormContainer(
                  height: 2,
                  child: ReusablePadding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 18, bottom: 18),
                    child: CustomToggleTile(
                      title: 'Use Billing Address as Shipping Address',
                      value: sameAsBilling,
                      onChanged: (value) {
                        ref.read(sameAsBillingToggleProvider.notifier).state =
                            value;

                        final notifier = ref.read(vendorFormProvider.notifier);
                        notifier.updateSameAddressFlag(value);

                        if (value) {
                          // ✅ Copy billing text controllers to shipping
                          billingControllers.forEach((key, billingController) {
                            if (shippingControllers.containsKey(key)) {
                              shippingControllers[key]!.text =
                                  billingController.text;
                            }
                          });

                          // ✅ Also copy country and state to shipping address state
                          final billing =
                              ref.read(vendorFormProvider).billingAddress;
                          notifier.state = notifier.state.copyWith(
                            shippingAddress: Map.from(billing),
                          );
                        } else {
                          // 🧹 Clear all shipping fields (including country/state)
                          shippingControllers.forEach((key, controller) {
                            controller.clear();
                          });

                          notifier.state = notifier.state.copyWith(
                            shippingAddress: {
                              'country': '',
                              'state': '',
                              'building': '',
                              'streetAddress': '',
                              'streetAddressArabic': '',
                              'city': '',
                              'zip': '',
                            },
                          );
                        }
                      },
                      divider: false,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                CustomExpansionTile(
                  title: 'Shipping Address',
                  isExpanded: isShippingExpanded,
                  onToggle: () => ref
                      .read(vendorShippingTileExpandedProvider.notifier)
                      .state = !isShippingExpanded,
                  height: 0,
                  child: Column(
                    children: [
                      PayzoBottomsheetNavigator(
                        onUnselect: () {
                          notifier.clearShippingCountry();
                          showPayzoSnackBar(
                              context: context,
                              ref: ref,
                              message: 'Shipping country cleared',type: PayzoSnackType.success);
                        },
                        enabled: sameAddress == true ? false : true,
                        errorText: vendorState.errors['shipping_country'],
                        required: true,
                        title: 'Country',
                        trailing: state.shippingAddress['country']!.isEmpty ||
                                state.shippingAddress['country'] == ''
                            ? 'Tap to Select'
                            : '${state.shippingAddress['country']}',
                        isPayzoColor: true,
                        onTap: () async {
                          await ref.read(focusUtilsProvider).unfocusAndDelay();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => data.when(
                                data: (data) => ReusableCountryBottomSheet(
                                      title: 'Countries',
                                      items: data.response
                                              ?.map((e) => e.countryName ?? '')
                                              .toList() ??
                                          [],
                                      onSelect: (selectedCountry) {
                                        final selected = data.response
                                            ?.firstWhere((element) =>
                                                element.countryName ==
                                                selectedCountry);
                                        if (selected != null) {
                                          notifier.updateShippingAddress(
                                              'country',
                                              selected.countryName ?? '');
                                          ref
                                                  .read(countryCodeProvider
                                                      .notifier)
                                                  .state =
                                              selected.ccid?.toString() ?? '';
                                        }
                                      },
                                    ),
                                error: (err, _) {
                                  print(_);
                                  print('error is $err');
                                  return SizedBox();
                                },
                                loading: () => ReusableSizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator())),
                          );
                        },
                      ),
                      PayzoBottomsheetNavigator(
                        onUnselect: () {
                          notifier.clearShippingState();
                          showPayzoSnackBar(
                              context: context,
                              ref: ref,
                              message: 'Shipping state cleared',type: PayzoSnackType.success);
                        },
                        enabled: sameAddress == true ? false : true,
                        required: true,
                        title: 'State',
                        errorText: vendorState.errors['shipping_state'],
                        trailing: state.shippingAddress['state']!.isEmpty ||
                                state.shippingAddress['state'] == ''
                            ? 'Tap to Select'
                            : '${state.shippingAddress['state']}',
                        isPayzoColor: true,
                        onTap: () async {
                          await ref.read(focusUtilsProvider).unfocusAndDelay();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => stateData.when(
                                data: (data) => ReusableCountryBottomSheet(
                                      title: 'State',
                                      items: data.response
                                              ?.map((e) => e.rName ?? '')
                                              .toList() ??
                                          [],
                                      onSelect: (selectedCountry) {
                                        notifier.updateShippingAddress(
                                            'state', selectedCountry);
                                      },
                                    ),
                                error: (err, _) {
                                  print(_);
                                  print('error is $err');
                                  return SizedBox();
                                },
                                loading: () => ReusableSizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator())),
                          );
                        },
                      ),
                      Column(
                        children: shippingControllers.entries
                            .map((entry) => PayzoInputField(
                                  enabled: sameAddress == true ? false : true,
                                  keyboardType: entry.key == 'building' ||
                                          entry.key == 'zip'
                                      ? TextInputType.numberWithOptions()
                                      : TextInputType.text,
                                  inputFormatters: entry.key ==
                                              'streetAddressArabic' ||
                                          entry.key == 'cityArabic'
                                      ? PayzoInputFormatters.onlyArabic
                                      : entry.key == 'building' ||
                                              entry.key == 'zip'
                                          ? PayzoInputFormatters.onlyFiveDigits
                                          : entry.key == 'street'
                                              ? PayzoInputFormatters.street
                                              : PayzoInputFormatters.city,
                                  label: shippingAddressLabels[entry.key] ??
                                      entry.key,
                                  controller: entry.value,
                                  required: entry.key == 'city' ||
                                      entry.key == 'cityArabic',
                                  errorText: vendorState
                                      .errors['shipping_${entry.key}'],
                                  // ✅ Match key pattern
                                  onChanged: (value) => notifier
                                      .updateShippingAddress(entry.key, value),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: PayzoFormSubmitTwoButtons(
              safeArea: true,
              cancelText: 'Clear',
              saveText: 'Save',
              cancelOnPressed: () {
                ref.read(openingAmountProvider.notifier).state =
                    'Tap to Select';
                openingAmount.text = '';
                vendorControllers.values.forEach((c) => c.clear());
                billingControllers.values.forEach((c) => c.clear());
                shippingControllers.values.forEach((c) => c.clear());
                ref.read(sameAsBillingToggleProvider.notifier).state = false;
                notifier.clearForm();
              },
              saveOnPressed: () async {
                notifier.validateFieldsAndUpdateState();
                final state = ref.read(vendorFormProvider);
                debugPrint("🔍 Vendor State: ${state.toJson()}");

                if (state.errors.isEmpty) {
                  // Show the loader dialog
                  showPayzoProgress(context: context);

                  try {
                    final response = await ref
                        .read(registerVendorRepoProvider)
                        .registerVendor();

                    // Close the loader
                    Navigator.pop(context);

                    if (!response.error) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Success"),
                          content: Text(
                              "Vendor registered successfully.\nTransaction ID: ${response.transactionId}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                notifier.clearForm();
                                Navigator.pop(context); // close success dialog
                                ref.invalidate(getVendorDataWithPagination);
                                // await Future.delayed(
                                // Duration(milliseconds: 50));
                                ref.read(bottomNavBarProvider.notifier).state =
                                    4; // 🔄 set to Vendor/Product index
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteNames.homeScreen,
                                  (route) => false,
                                );
                                Navigator.pushNamed(
                                    context, RouteNames.vendorScreen);
                                ref
                                    .read(sameAsBillingToggleProvider.notifier)
                                    .state = false;
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Error"),
                          content: Text(response.errorMsg ?? "Unknown error"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    Navigator.pop(context); // Close loader on error too
                    debugPrint("❌ Error registering vendor: $e");
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Exception"),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                }
              }),
        ),
      ),
    );
  }
}
