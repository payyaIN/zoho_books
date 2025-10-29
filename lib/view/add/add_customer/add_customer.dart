// add_customer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_customer/add_customer_model.dart';
import 'package:payzo_books/data/repository/customer_list_page/customer_listing_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_customer/providers/add_customer_providers.dart';
import 'package:payzo_books/view/add/add_vendor/notifier/add_vendor_notifier.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';

import '../../../data/repository/add_bills/get_branch_list_repository.dart';
import '../../../data/repository/add_bills/get_price_currency_repository.dart';
import '../../../data/repository/add_customer/add_customer_repository.dart';
import '../../../data/repository/add_vendor/get_country_list_repository.dart';
import '../../../data/repository/add_vendor/get_state_list_repository.dart'
    show getStateList;
import '../../../data/repository/add_vendor/get_state_list_repository.dart'
    as state_repo;

// label providers so selected names appear in UI immediately
final billingCountryLabelProvider = StateProvider<String>((ref) => '');
final shippingCountryLabelProvider = StateProvider<String>((ref) => '');
final billingStateLabelProvider = StateProvider<String>((ref) => '');
final shippingStateLabelProvider = StateProvider<String>((ref) => '');

final customerSameAsBillingToggleProvider = StateProvider<bool>((ref) => false);

class AddCustomer extends ConsumerStatefulWidget {
  const AddCustomer({super.key});

  @override
  ConsumerState<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends ConsumerState<AddCustomer> {
  late final Map<String, TextEditingController> customerTypeController;
  late final Map<String, TextEditingController> billController;
  late final Map<String, TextEditingController> shippingController;
  late final TextEditingController openingAmountController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getCountryList);
      ref.read(getStateList);
      ref.read(fetchBranchListProvider);
      ref.read(fetchPriceCurrencyProvider);
    });

    customerTypeController = {
      "firstName": TextEditingController(),
      "secondName": TextEditingController(),
      "firstNameArabic": TextEditingController(),
      "secondNameArabic": TextEditingController(),
      "companyName": TextEditingController(),
      "companyNameArabic": TextEditingController(),
      "email": TextEditingController(),
      "mobile": TextEditingController(),
      "workPhone": TextEditingController(),
      "vatNumber": TextEditingController(),
      "crNum": TextEditingController(),
      "documentType": TextEditingController(),
      "documentNumber": TextEditingController(),
      "expiryDate": TextEditingController(),
      "contact_firstName": TextEditingController(),
      "contact_lastName": TextEditingController(),
      "contact_mobile": TextEditingController(),
      "remark": TextEditingController(),
    };

    openingAmountController = TextEditingController();

    billController = {
      "building": TextEditingController(),
      "street": TextEditingController(),
      "streetArabic": TextEditingController(),
      "city": TextEditingController(),
      "cityArabic": TextEditingController(),
      "zip": TextEditingController(),
    };

    shippingController = {
      "building": TextEditingController(),
      "street": TextEditingController(),
      "streetArabic": TextEditingController(),
      "city": TextEditingController(),
      "cityArabic": TextEditingController(),
      "zip": TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (final controller in customerTypeController.values) {
      controller.dispose();
    }
    for (final controller in billController.values) {
      controller.dispose();
    }
    for (final controller in shippingController.values) {
      controller.dispose();
    }
    openingAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBillingExpanded = ref.watch(billingTileExpandedProvider);
    final isShippingExpanded = ref.watch(shippingTileExpandedProvider);
    final countryData = ref.watch(getCountryList);
    final stateData = ref.watch(getStateList);
    final customerState = ref.watch(customerFormProvider);

    // watch errors from notifier provider
    final errors = ref.watch(customerErrorsProvider);

    void clearFormAndControllers() {
      final notifier = ref.read(customerFormProvider.notifier);

      // Clear customer type controllers
      for (final controller in customerTypeController.values) {
        controller.clear();
      }

      // Clear billing address controllers
      for (final controller in billController.values) {
        controller.clear();
      }

      // Clear shipping address controllers
      for (final controller in shippingController.values) {
        controller.clear();
      }

      // Clear notifier form state
      notifier.clearForm();

      // Collapse expansion tiles if needed
      ref.read(billingTileExpandedProvider.notifier).state = false;
      ref.read(shippingTileExpandedProvider.notifier).state = false;
      ref.read(openingAmountProvider.notifier).state = '';
      notifier.updateField('openingAmount', '');
      openingAmountController.text = '';
      // clear label providers
      ref.read(billingCountryLabelProvider.notifier).state = '';
      ref.read(shippingCountryLabelProvider.notifier).state = '';
      ref.read(billingStateLabelProvider.notifier).state = '';
      ref.read(shippingStateLabelProvider.notifier).state = '';
    }

    return ScalingFactor(
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            clearFormAndControllers();
          }
        },
        child: Scaffold(
          appBar: reusableAppBar(
            title: 'Add Customer',
            context: context,
            showBackButton: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ReusableColumn(
              children: [
                // CustomerTypeWidget expects the expanded customerTypeController with extra keys
                CustomerTypeWidget(
                    customerTypeController, openingAmountController),
                const SizedBox(height: 15),
                ReusablePadding(
                  padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
                  child: CustomExpansionTile(
                    height: 346,
                    title: "Billing Address",
                    isExpanded: isBillingExpanded,
                    onToggle: () {
                      ref.read(billingTileExpandedProvider.notifier).state =
                          !isBillingExpanded;
                    },
                    child: _buildAddressFields(ref, true, true, billController,
                        customerState, countryData, stateData),
                  ),
                ),
                const SizedBox(height: 15),
                ReusablePadding(
                  padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
                  child: FormContainer(
                    height: 2,
                    child: ReusablePadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18),
                      child: CustomToggleTile(
                        title: 'Use Billing Address as Shipping Address',
                        value: ref.watch(customerSameAsBillingToggleProvider),
                        onChanged: (value) {
                          ref
                              .read(
                                  customerSameAsBillingToggleProvider.notifier)
                              .state = value;

                          final notifier =
                              ref.read(customerFormProvider.notifier);
                          final billing =
                              ref.read(customerFormProvider).billingAddress;

                          if (value) {
                            // Copy billing values to shipping
                            notifier.state = notifier.state.copyWith(
                              shippingAddress: ShippingAddress(
                                countryRegion: billing?.countryRegion ?? '',
                                buildingNumber: billing?.buildingNumber ?? '',
                                streetName: billing?.streetName,
                                streetAddress: billing?.streetAddress ?? '',
                                streetAddressArabic:
                                    billing?.streetAddressArabic ?? '',
                                city: billing?.city ?? '',
                                cityArabic: billing?.cityArabic ?? '',
                                state: billing?.state,
                                zipCode: billing?.zipCode ?? '',
                              ),
                            );

                            // Update text controllers
                            billController.forEach((key, controller) {
                              if (shippingController.containsKey(key)) {
                                shippingController[key]?.text = controller.text;
                              }
                            });

                            // Update label providers so UI shows labels immediately
                            ref
                                .read(shippingCountryLabelProvider.notifier)
                                .state = ref.read(billingCountryLabelProvider);
                            ref
                                .read(shippingStateLabelProvider.notifier)
                                .state = ref.read(billingStateLabelProvider);
                          } else {
                            // Clear shipping fields
                            notifier.state = notifier.state.copyWith(
                              shippingAddress: ShippingAddress(
                                countryRegion: '',
                                buildingNumber: '',
                                streetName: null,
                                streetAddress: '',
                                streetAddressArabic: '',
                                city: '',
                                cityArabic: '',
                                state: null,
                                zipCode: '',
                              ),
                            );

                            for (final controller
                                in shippingController.values) {
                              controller.clear();
                            }

                            // clear shipping labels
                            ref
                                .read(shippingCountryLabelProvider.notifier)
                                .state = '';
                            ref
                                .read(shippingStateLabelProvider.notifier)
                                .state = '';
                          }
                        },
                        divider: false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ReusablePadding(
                  padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
                  child: CustomExpansionTile(
                    height: 348,
                    title: "Shipping Address",
                    isExpanded: isShippingExpanded,
                    onToggle: () {
                      ref.read(shippingTileExpandedProvider.notifier).state =
                          !isShippingExpanded;
                    },
                    // shipping editing should be disabled when "same as billing" is ON
                    child: _buildAddressFields(
                        ref,
                        false,
                        !ref.watch(customerSameAsBillingToggleProvider),
                        shippingController,
                        customerState,
                        countryData,
                        stateData),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          bottomNavigationBar: PayzoFormSubmitTwoButtons(
            safeArea: true,
            cancelText: 'Clear',
            saveText: 'Save',
            cancelOnPressed: () {
              final notifier = ref.read(customerFormProvider.notifier);
              for (final controller in billController.values) {
                controller.clear();
              }
              for (final controller in shippingController.values) {
                controller.clear();
              }
              for (final controller in customerTypeController.values) {
                controller.clear();
              }
              ref.read(customerSameAsBillingToggleProvider.notifier).state =
                  false;
              notifier.clearForm();
              openingAmountController.text = '';
              ref.read(openingAmountProvider.notifier).state = 'Tap to Select';
              notifier.updateField('openingAmount', '');
              // clear label providers
              ref.read(billingCountryLabelProvider.notifier).state = '';
              ref.read(shippingCountryLabelProvider.notifier).state = '';
              ref.read(billingStateLabelProvider.notifier).state = '';
              ref.read(shippingStateLabelProvider.notifier).state = '';
            },
            saveOnPressed: () async {
              final notifier = ref.read(customerFormProvider.notifier);

              // call notifier validateFields which writes errors into customerErrorsProvider
              final isValid = notifier.validateFields();

              if (isValid) {
                showPayzoProgress(context: context);
                try {
                  final response = await ref
                      .read(registerCustomerRepoProvider)
                      .registerCustomer();

                  debugPrint("✅ API Response: ${response.toJson()}");

                  Navigator.pop(context);

                  if (response.error == false || response.error == null) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Success"),
                        content: Text("Customer registered successfully."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              notifier.clearForm();
                              Navigator.pop(context);
                              ref.invalidate(getCustomerDataWithPagination);
                              ref.read(bottomNavBarProvider.notifier).state =
                                  4; // set to Vendor/Product index
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RouteNames.homeScreen, (route) => false);
                              Navigator.pushNamed(
                                  context, RouteNames.customerScreen);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    debugPrint("❌ API returned error: ${response.errorMsg}");
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Error"),
                        content: Text(response.errorMsg?.toString() ??
                            "Something went wrong"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e, stacktrace) {
                  debugPrint("❌ Exception: $e");
                  debugPrint("📌 Stacktrace: $stacktrace");
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
              } else {
                // validation failed — UI will show errors from customerErrorsProvider
                final errors = ref.read(customerErrorsProvider);
                if (errors.keys.any((k) => k.startsWith('billing'))) {
                  ref.read(billingTileExpandedProvider.notifier).state = true;
                }
                if (errors.keys.any((k) => k.startsWith('shipping'))) {
                  ref.read(shippingTileExpandedProvider.notifier).state = true;
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddressFields(
    WidgetRef ref,
    bool isBilling,
    bool enabled,
    Map<String, TextEditingController> controller,
    AddCustomerModel modelState, // renamed from `state` to avoid shadowing
    AsyncValue countryData,
    AsyncValue stateData,
  ) {
    final notifier = ref.read(customerFormProvider.notifier);

    // Typed addresses
    final BillingAddress? billingAddr = modelState.billingAddress;
    final ShippingAddress? shippingAddr = modelState.shippingAddress;

    // UI labels come from the label providers first (they update immediately),
    // fallback to model values if provider label is empty.
    final String providerCountryLabel = isBilling
        ? ref.watch(billingCountryLabelProvider)
        : ref.watch(shippingCountryLabelProvider);

    final String providerStateLabel = isBilling
        ? ref.watch(billingStateLabelProvider)
        : ref.watch(shippingStateLabelProvider);

    final String fallbackCountry = (isBilling
            ? billingAddr?.countryRegion
            : shippingAddr?.countryRegion) ??
        '';
    final String fallbackState = (isBilling
            ? billingAddr?.state?.toString()
            : shippingAddr?.state?.toString()) ??
        '';

    final String countryLabel = providerCountryLabel.isNotEmpty
        ? providerCountryLabel
        : fallbackCountry;
    final String stateLabel =
        providerStateLabel.isNotEmpty ? providerStateLabel : fallbackState;

    final errors = ref.watch(customerErrorsProvider);

    return ReusableColumn(
      children: [
        // Country selector
        PayzoBottomsheetNavigator(
          enabled: enabled,
          errorText: errors['${isBilling ? 'billing' : 'shipping'}.country'],
          required: true,
          title: 'Country',
          trailing: countryLabel.isEmpty ? 'Tap to select' : countryLabel,
          isPayzoColor: true,
          onTap: () async {
            await ref.read(focusUtilsProvider).unfocusAndDelay();

            // fetch country list (use .future)
            final countryListResponse = await ref.read(getCountryList.future);

            final itemNames = (countryListResponse.response ?? [])
                .map((e) => e.countryName ?? '')
                .where((s) => s.isNotEmpty)
                .toSet()
                .toList()
                .cast<String>();

            if (!context.mounted) return;

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ReusableCountryBottomSheet(
                title: 'Countries',
                items: itemNames,
                onSelect: (selectedCountry) {
                  final List responseList = countryListResponse.response ?? [];

                  // safe search
                  dynamic selected;
                  for (final el in responseList) {
                    if ((el.countryName ?? '').toString() == selectedCountry) {
                      selected = el;
                      break;
                    }
                  }
                  selected ??=
                      responseList.isNotEmpty ? responseList.first : null;

                  if (selected == null) {
                    Navigator.pop(context);
                    return;
                  }

                  // readable name and possible id (repo Response has ccid as id)
                  final selectedName = (selected.countryName ?? '').toString();
                  final selectedId =
                      (selected.ccid != null) ? selected.ccid.toString() : null;

                  // update notifier with ID if exists else name
                  final storedValue =
                      (selectedId != null && selectedId.isNotEmpty)
                          ? selectedId
                          : selectedName;

                  if (isBilling) {
                    notifier.updateBillingAddress('country', storedValue);
                    ref.read(billingCountryLabelProvider.notifier).state =
                        selectedName;

                    // also update country code provider so state list can refresh
                    if (selectedId != null) {
                      ref.read(state_repo.countryCodeProvider.notifier).state =
                          selectedId;
                    } else {
                      // if no numeric id, clear countryCodeProvider to avoid accidental requests
                      ref.read(state_repo.countryCodeProvider.notifier).state =
                          '';
                    }

                    if (ref.read(customerSameAsBillingToggleProvider)) {
                      notifier.updateShippingAddress('country', storedValue);
                      ref.read(shippingCountryLabelProvider.notifier).state =
                          selectedName;
                      // mirror country code into shipping label provider as well
                      if (selectedId != null) {
                        ref
                            .read(state_repo.countryCodeProvider.notifier)
                            .state = selectedId;
                      }
                    }
                  } else {
                    notifier.updateShippingAddress('country', storedValue);
                    ref.read(shippingCountryLabelProvider.notifier).state =
                        selectedName;
                    if (selectedId != null) {
                      ref.read(state_repo.countryCodeProvider.notifier).state =
                          selectedId;
                    } else {
                      ref.read(state_repo.countryCodeProvider.notifier).state =
                          '';
                    }
                  }

                  // close sheet
                },
              ),
            );
          },
        ),

        // State selector
        PayzoBottomsheetNavigator(
          enabled: enabled,
          errorText: errors['${isBilling ? 'billing' : 'shipping'}.state'],
          required: true,
          title: 'State',
          trailing: stateLabel.isEmpty ? 'Tap to select' : stateLabel,
          isPayzoColor: true,
          onTap: () async {
            await ref.read(focusUtilsProvider).unfocusAndDelay();

            // fetch state list (use .future) — note: GetStateListRepository uses countryCodeProvider internally
            final stateListResponse = await ref.read(getStateList.future);

            final itemNames = (stateListResponse.response ?? [])
                .map((e) => e.rName ?? '')
                .where((s) => s.isNotEmpty)
                .toSet()
                .toList()
                .cast<String>();

            if (!context.mounted) return;

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ReusableCountryBottomSheet(
                title: 'State',
                items: itemNames,
                onSelect: (selectedState) {
                  final List responseList = stateListResponse.response ?? [];

                  // safe search
                  dynamic selected;
                  for (final el in responseList) {
                    if ((el.rName ?? '').toString() == selectedState) {
                      selected = el;
                      break;
                    }
                  }
                  selected ??=
                      responseList.isNotEmpty ? responseList.first : null;

                  if (selected == null) {
                    Navigator.pop(context);
                    return;
                  }

                  final selectedName = (selected.rName ?? '').toString();
                  // possible ids: rId or rCodeId
                  final selectedId = (selected.rId != null)
                      ? selected.rId.toString()
                      : (selected.rCodeId != null)
                          ? selected.rCodeId.toString()
                          : null;

                  final storedValue =
                      (selectedId != null && selectedId.isNotEmpty)
                          ? selectedId
                          : selectedName;

                  if (isBilling) {
                    notifier.updateBillingAddress('state', storedValue);
                    ref.read(billingStateLabelProvider.notifier).state =
                        selectedName;

                    if (ref.read(customerSameAsBillingToggleProvider)) {
                      notifier.updateShippingAddress('state', storedValue);
                      ref.read(shippingStateLabelProvider.notifier).state =
                          selectedName;
                    }
                  } else {
                    notifier.updateShippingAddress('state', storedValue);
                    ref.read(shippingStateLabelProvider.notifier).state =
                        selectedName;
                  }
                },
              ),
            );
          },
        ),

        // Remaining address fields
        ...['building', 'street', 'streetArabic', 'city', 'cityArabic', 'zip']
            .map((fieldKey) {
          return PayzoInputField(
            enabled: enabled,
            required:
                fieldKey == 'city' || fieldKey == 'cityArabic' ? true : false,
            inputFormatters: fieldKey == 'building'
                ? PayzoInputFormatters.onlyDigits
                : fieldKey == 'street'
                    ? PayzoInputFormatters.street
                    : fieldKey == 'streetArabic'
                        ? PayzoInputFormatters.street
                        : fieldKey == 'city'
                            ? PayzoInputFormatters.city
                            : fieldKey == 'cityArabic'
                                ? PayzoInputFormatters.city
                                : fieldKey == 'zip'
                                    ? PayzoInputFormatters.onlyFiveDigits
                                    : PayzoInputFormatters.alphanumeric,
            label: fieldKey == 'building'
                ? 'Building Number'
                : fieldKey == 'streetArabic'
                    ? 'Street (Arabic)'
                    : fieldKey == 'cityArabic'
                        ? 'City (Arabic)'
                        : fieldKey[0].toUpperCase() + fieldKey.substring(1),
            controller: controller[fieldKey],
            errorText:
                errors['${isBilling ? 'billing' : 'shipping'}.$fieldKey'],
            onChanged: (value) {
              if (isBilling) {
                notifier.updateBillingAddress(fieldKey, value);
                if (ref.read(customerSameAsBillingToggleProvider)) {
                  notifier.updateShippingAddress(fieldKey, value);
                  if (shippingController.containsKey(fieldKey)) {
                    shippingController[fieldKey]?.text = value;
                  }
                }
              } else {
                notifier.updateShippingAddress(fieldKey, value);
              }
            },
          );
        }).toList(),
      ],
    );
  }
}
