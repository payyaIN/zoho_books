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
import '../../../utils/common_widgets/reusable_snackbar.dart';
import '../../../data/repository/update_customer/update_customer_repository.dart';
import '../../../data/models/view_party/view_party_model.dart' as view_model;

// label providers so selected names appear in UI immediately
final billingCountryLabelProvider = StateProvider<String>((ref) => '');
final shippingCountryLabelProvider = StateProvider<String>((ref) => '');
final billingStateLabelProvider = StateProvider<String>((ref) => '');
final shippingStateLabelProvider = StateProvider<String>((ref) => '');

final customerSameAsBillingToggleProvider = StateProvider<bool>((ref) => false);

class UpdateCustomerScreen extends ConsumerStatefulWidget {
  final int? partyId;
  final view_model.ViewPartyModel? existingCustomerData;

  const UpdateCustomerScreen({super.key, this.partyId, this.existingCustomerData});

  @override
  ConsumerState<UpdateCustomerScreen> createState() =>
      _UpdateCustomerScreenState();
}

class _UpdateCustomerScreenState extends ConsumerState<UpdateCustomerScreen> {
  late final Map<String, TextEditingController> customerTypeController;
  late final Map<String, TextEditingController> billController;
  late final Map<String, TextEditingController> shippingController;
  // late final TextEditingController openingAmountController;

  @override
  void initState() {
    super.initState();
    
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

    Future.microtask(() {
      ref.read(getCountryList);
      ref.read(getStateList);
      ref.read(fetchBranchListProvider);
      ref.read(fetchPriceCurrencyProvider);
      
      if (widget.existingCustomerData != null) {
        _populateExistingData();
      } else {
        // Default values for new customer (if reused)
         ref.read(customerFormProvider.notifier).state =
          ref.read(customerFormProvider.notifier).state.copyWith(
                governmentEntity: false,
                taxedOrganization: false,
              );
      }
    });
  }

  void _populateExistingData() {
    final data = widget.existingCustomerData!.response;
    final notifier = ref.read(customerFormProvider.notifier);

    // Populate Text Controllers
    customerTypeController['companyName']?.text = data.companyName ?? '';
    customerTypeController['companyNameArabic']?.text = data.companyNameArabic ?? '';
    customerTypeController['email']?.text = data.emailAddress ?? '';
    customerTypeController['mobile']?.text = data.mobile?.toString() ?? '';
    customerTypeController['workPhone']?.text = data.phone?.toString() ?? '';
    customerTypeController['vatNumber']?.text = data.vatNumber ?? '';
    customerTypeController['crNum']?.text = data.crNum ?? '';
    customerTypeController['remark']?.text = data.remark?.remark ?? '';

    // Primary Contact
    customerTypeController['firstName']?.text = data.primaryContact?.firstName ?? '';
    customerTypeController['secondName']?.text = data.primaryContact?.lastName ?? '';
    customerTypeController['firstNameArabic']?.text = data.primaryContactArabic?.firstNameArabic ?? '';
    customerTypeController['secondNameArabic']?.text = data.primaryContactArabic?.lastNameArabic ?? '';

    // Contact Persons (taking first one if available for display in simple fields, logic might vary)
    if (data.contactPersons != null && data.contactPersons!.isNotEmpty) {
      final cp = data.contactPersons!.first;
      customerTypeController['contact_firstName']?.text = cp.firstName ?? '';
      customerTypeController['contact_lastName']?.text = cp.lastName ?? '';
      customerTypeController['contact_mobile']?.text = cp.mobileNo ?? '';
    }

    // Billing Address
    if (data.billingAddress != null) {
      billController['building']?.text = data.billingAddress!.buildingNumber ?? '';
      billController['street']?.text = data.billingAddress!.streetAddress ?? ''; // Mapping streetAddress to street
      billController['streetArabic']?.text = data.billingAddress!.streetAddressArabic ?? '';
      billController['city']?.text = data.billingAddress!.city ?? '';
      billController['cityArabic']?.text = data.billingAddress!.cityArabic ?? '';
      billController['zip']?.text = data.billingAddress!.zipCode ?? '';
      
      if (data.billingAddress!.countryRegion != null) {
         notifier.updateBillingAddress('country', data.billingAddress!.countryRegion);
      }
       if (data.billingAddress!.state != null) {
         notifier.updateBillingAddress('state', data.billingAddress!.state);
      }
    }

    // Shipping Address
    if (data.shippingAddress != null) {
      shippingController['building']?.text = data.shippingAddress!.buildingNumber ?? '';
      shippingController['street']?.text = data.shippingAddress!.streetAddress ?? '';
      shippingController['streetArabic']?.text = data.shippingAddress!.streetAddressArabic ?? '';
      shippingController['city']?.text = data.shippingAddress!.city ?? '';
      shippingController['cityArabic']?.text = data.shippingAddress!.cityArabic ?? '';
      shippingController['zip']?.text = data.shippingAddress!.zipCode ?? '';
      
       if (data.shippingAddress!.countryRegion != null) {
         notifier.updateShippingAddress('country', data.shippingAddress!.countryRegion);
      }
       if (data.shippingAddress!.state != null) {
         notifier.updateShippingAddress('state', data.shippingAddress!.state);
      }
    }

    // Update Form State
    notifier.state = notifier.state.copyWith(
      companyName: data.companyName,
      companyNameArabic: data.companyNameArabic,
      emailAddress: data.emailAddress,
      mobile: data.mobile?.toString(),
      phone: data.phone?.toString(),
      vatNumber: data.vatNumber,
      crNum: data.crNum,
      remark: Remark(remark: data.remark?.remark),
      primaryContact: PrimaryContact(firstName: data.primaryContact?.firstName, lastName: data.primaryContact?.lastName),
      primaryContactArabic: PrimaryContactArabic(firstNameArabic: data.primaryContactArabic?.firstNameArabic, lastNameArabic: data.primaryContactArabic?.lastNameArabic),
      customerType: data.customerType, // Ensure case matches (e.g. BUSINESS)
      partyType: data.partyType,
      governmentEntity: data.governmentEntity ?? false,
      taxedOrganization: data.taxedOrganization ?? false,
      sameAddressFlag: data.sameAddressFlag ?? false,
      
      billingAddress: BillingAddress(
        addressId: data.billingAddress?.addressId,
        buildingNumber: data.billingAddress?.buildingNumber,
        streetAddress: data.billingAddress?.streetAddress,
        streetAddressArabic: data.billingAddress?.streetAddressArabic,
        city: data.billingAddress?.city,
        cityArabic: data.billingAddress?.cityArabic,
        zipCode: data.billingAddress?.zipCode,
        countryRegion: data.billingAddress?.countryRegion,
        state: data.billingAddress?.state,
      ),
      shippingAddress: ShippingAddress(
        addressId: data.shippingAddress?.addressId,
        buildingNumber: data.shippingAddress?.buildingNumber,
        streetAddress: data.shippingAddress?.streetAddress,
        streetAddressArabic: data.shippingAddress?.streetAddressArabic,
        city: data.shippingAddress?.city,
        cityArabic: data.shippingAddress?.cityArabic,
        zipCode: data.shippingAddress?.zipCode,
        countryRegion: data.shippingAddress?.countryRegion,
        state: data.shippingAddress?.state,
      ),
    );

    // Handle Same Address Flag
    if (data.sameAddressFlag == true) {
      ref.read(customerSameAsBillingToggleProvider.notifier).state = true;
    }
    
    // Opening Balance
    if (data.openingBalance != null) {
        notifier.updateField('openingAmount', data.openingBalance!.amount.toString());
        ref.read(openingAmountProvider.notifier).state = data.openingBalance!.amount.toString();
    }
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
    // openingAmountController.dispose();
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
      notifier.clearShippingCountry();
      notifier.clearShippingState();
      notifier.clearBillingState();
      notifier.clearBillingCountry();

      // Collapse expansion tiles if needed
      ref.read(billingTileExpandedProvider.notifier).state = false;
      ref.read(shippingTileExpandedProvider.notifier).state = false;
      ref.read(openingAmountProvider.notifier).state = '';
      notifier.updateField('openingAmount', '');
      // openingAmountController.text = '';
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
            title: widget.partyId != null ? 'Edit Customer' : 'Add Customer',
            context: context,
            showBackButton: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ReusableColumn(
              children: [
                // CustomerTypeWidget expects the expanded customerTypeController with extra keys
                CustomerTypeWidget(customerTypeController),
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
            saveText: widget.partyId != null ? 'Update' : 'Save',
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
              // openingAmountController.text = '';
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
                  dynamic response;
                  if (widget.partyId != null) {
                     response = await ref
                        .read(updateCustomerRepoProvider)
                        .updateCustomer(partyId: widget.partyId!);
                  } else {
                     response = await ref
                        .read(registerCustomerRepoProvider)
                        .registerCustomer();
                  }

                  debugPrint("✅ API Response: ${response.toJson()}");

                  Navigator.pop(context);

                  if (response.error == false || response.error == null) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Success"),
                        content: Text(widget.partyId != null ? "Customer updated successfully." : "Customer registered successfully."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              notifier.clearForm();
                              Navigator.pop(context);
                              ref.invalidate(getCustomerDataWithPagination);
                              // await Future.delayed(Duration(milliseconds: 50));
                              if (widget.partyId != null) {
                                 // If update, just pop back
                                 Navigator.pop(context, true); // return true to indicate update
                              } else {
                                ref.read(bottomNavBarProvider.notifier).state =
                                    4; // set to Vendor/Product index
                                Navigator.pushNamedAndRemoveUntil(context,
                                    RouteNames.homeScreen, (route) => false);
                                Navigator.pushNamed(
                                    context, RouteNames.customerScreen);
                              }
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
          onUnselect: () {
            final notifier = ref.read(customerFormProvider.notifier);
            if (isBilling) {
              notifier.clearBillingCountry();
              ref.read(billingCountryLabelProvider.notifier).state = '';
              // if same-as-billing, clear shipping labels too
              if (ref.read(customerSameAsBillingToggleProvider)) {
                ref.read(shippingCountryLabelProvider.notifier).state = '';
              }
              // clear text controller for billing country if you used one (optional)
              if (isBilling && controller.containsKey('country')) {
                controller['country']?.clear();
              }
            } else {
              notifier.clearShippingCountry();
              ref.read(shippingCountryLabelProvider.notifier).state = '';
              if (ref.read(customerSameAsBillingToggleProvider)) {
                ref.read(billingCountryLabelProvider.notifier).state = '';
              }
              if (!isBilling && controller.containsKey('country')) {
                controller['country']?.clear();
              }
            }

            showPayzoSnackBar(
              context: context,
              ref: ref,
              message: '${isBilling ? 'Billing' : 'Shipping'} country cleared',
              type: PayzoSnackType.success,
            );
          },
          enabled: enabled,
          errorText: errors['${isBilling ? 'billing' : 'shipping'}.country'],
          required: true,
          title: 'Country',
          trailing: countryLabel.isEmpty ? 'Tap to Select' : countryLabel,
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
          onUnselect: () {
            final notifier = ref.read(customerFormProvider.notifier);
            if (isBilling) {
              notifier.clearBillingState();
              ref.read(billingStateLabelProvider.notifier).state = '';
              if (ref.read(customerSameAsBillingToggleProvider)) {
                ref.read(shippingStateLabelProvider.notifier).state = '';
              }
              if (controller.containsKey('state')) controller['state']?.clear();
            } else {
              notifier.clearShippingState();
              ref.read(shippingStateLabelProvider.notifier).state = '';
              if (ref.read(customerSameAsBillingToggleProvider)) {
                ref.read(billingStateLabelProvider.notifier).state = '';
              }
              if (controller.containsKey('state')) controller['state']?.clear();
            }

            showPayzoSnackBar(
              context: context,
              ref: ref,
              message: '${isBilling ? 'Billing' : 'Shipping'} state cleared',
              type: PayzoSnackType.success,
            );
          },
          enabled: enabled,
          errorText: errors['${isBilling ? 'billing' : 'shipping'}.state'],
          required: true,
          title: 'State',
          trailing: stateLabel.isEmpty ? 'Tap to Select' : stateLabel,
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
                ? PayzoInputFormatters.saudiBuildingNumber
                : fieldKey == 'street'
                    ? PayzoInputFormatters.street
                    : fieldKey == 'streetArabic'
                        ? PayzoInputFormatters.onlyArabic
                        : fieldKey == 'city'
                            ? PayzoInputFormatters.city
                            : fieldKey == 'cityArabic'
                                ? PayzoInputFormatters.onlyArabic
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
