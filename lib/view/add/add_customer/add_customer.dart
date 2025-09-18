import 'package:payzo_books/data/models/add_customer/add_customer_model.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_customer/add_customer_repository.dart';
import 'package:payzo_books/data/repository/add_vendor/get_state_list_repository.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/view/add/add_vendor/notifier/add_vendor_notifier.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';

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
      "firstNameArabic": TextEditingController(),
      "secondName": TextEditingController(),
      "lastNameArabic": TextEditingController(),
      "companyName": TextEditingController(),
      "companyNameArabic": TextEditingController(),
      "displayName": TextEditingController(),
      "email": TextEditingController(),
      "mobile": TextEditingController(),
      "workPhone": TextEditingController(),
      "vatNumber": TextEditingController(),
      "crNum": TextEditingController(),
      "remark": TextEditingController(),
    };
    openingAmountController = TextEditingController();
    billController = {
      "building": TextEditingController(),
      "street": TextEditingController(),
      "city": TextEditingController(),
      "zip": TextEditingController(),
      "streetAddressArabic": TextEditingController(),
      "cityArabic": TextEditingController(),
    };

    shippingController = {
      "building": TextEditingController(),
      "street": TextEditingController(),
      "city": TextEditingController(),
      "zip": TextEditingController(),
      "streetAddressArabic": TextEditingController(),
      "cityArabic": TextEditingController(),
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
    final sameAddress =
        ref.read(customerSameAsBillingToggleProvider.notifier).state;
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
                            // ✅ Copy billing values to shipping
                            notifier.state = notifier.state.copyWith(
                              shippingAddress: Map.from(billing),
                            );

                            // ✅ Update text controllers
                            billController.forEach((key, controller) {
                              if (shippingController.containsKey(key)) {
                                shippingController[key]?.text = controller.text;
                              }
                            });
                          } else {
                            // ❌ Clear shipping fields (including country and state)
                            notifier.state = notifier.state.copyWith(
                              shippingAddress: {
                                'country': '',
                                'state': '',
                                'building': '',
                                'street': '',
                                'city': '',
                                'zip': ''
                              },
                            );

                            for (final controller
                                in shippingController.values) {
                              controller.clear();
                            }
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
                    child: _buildAddressFields(
                        ref,
                        false,
                        sameAddress == true ? false : true,
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
                ref.read(openingAmountProvider.notifier).state =
                    'Tap to Select';
                notifier.updateField('openingAmount', '');
              },
              saveOnPressed: () async {
                final notifier = ref.read(customerFormProvider.notifier);
                notifier.validateFields();

                if (notifier.state.errors.isEmpty) {
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
                          // content: Text(
                          //     "Customer registered successfully.\nTransaction ID: ${response.transactionId}"),
                          content: Text("Customer registered successfully."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                notifier.clearForm();
                                Navigator.pop(context);
                                ref.read(bottomNavBarProvider.notifier).state =
                                    4; // 🔄 set to Vendor/Product index
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteNames.homeScreen,
                                  (route) => false,
                                );
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
                }
              }),
        ),
      ),
    );
  }

  Widget _buildAddressFields(
    WidgetRef ref,
    bool isBilling,
    bool enabled,
    Map<String, TextEditingController> controller,
    AddCustomerModel state,
    AsyncValue countryData,
    AsyncValue stateData,
  ) {
    final notifier = ref.read(customerFormProvider.notifier);
    final sameAddress =
        ref.read(customerSameAsBillingToggleProvider.notifier).state;
    final address = isBilling ? state.billingAddress : state.shippingAddress;
    return ReusableColumn(
      children: [
        PayzoBottomsheetNavigator(
          enabled: enabled,
          errorText:
              state.errors['${isBilling ? 'billing' : 'shipping'}.country'],
          required: true,
          title: 'Country',
          trailing: address['country']!.isEmpty
              ? 'Tap to select'
              : address['country']!,
          isPayzoColor: true,
          onTap: () async {
            await ref.read(focusUtilsProvider).unfocusAndDelay();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => countryData.when(
                data: (data) => ReusableCountryBottomSheet(
                    title: 'Countries',
                    items: data.response
                            ?.map((e) => e.countryName ?? '')
                            .toList()
                            .cast<String>() ??
                        [],
                    onSelect: (selectedCountry) {
                      final selected = data.response?.firstWhere(
                        (element) => element.countryName == selectedCountry,
                      );

                      if (selected != null) {
                        if (isBilling) {
                          notifier.updateBillingAddress(
                              'country', selected.countryName ?? '');

                          // 🔁 Sync to shipping if toggle is ON
                          if (ref.read(customerSameAsBillingToggleProvider)) {
                            notifier.updateShippingAddress(
                                'country', selected.countryName ?? '');
                          }
                        } else {
                          notifier.updateShippingAddress(
                              'country', selected.countryName ?? '');
                        }
                      }
                    }),
                error: (err, _) => const SizedBox(),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ),
        PayzoBottomsheetNavigator(
          enabled: enabled,
          errorText:
              state.errors['${isBilling ? 'billing' : 'shipping'}.state'],
          required: true,
          title: 'State',
          trailing:
              address['state']!.isEmpty ? 'Tap to select' : address['state']!,
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
                            .toList()
                            .cast<String>() ??
                        [],
                    onSelect: (selectedState) {
                      if (isBilling) {
                        notifier.updateBillingAddress('state', selectedState);

                        // 🔁 Sync to shipping if toggle is ON
                        if (ref.read(customerSameAsBillingToggleProvider)) {
                          notifier.updateShippingAddress(
                              'state', selectedState);
                        }
                      } else {
                        notifier.updateShippingAddress('state', selectedState);
                      }
                    }),
                error: (err, _) => const SizedBox(),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ),
        ...['building', 'street', 'city', 'zip'].map((fieldKey) {
          return PayzoInputField(
              enabled: enabled,
              required: true,
              inputFormatters: fieldKey == 'building'
                  ? PayzoInputFormatters.onlyDigits
                  : fieldKey == 'street'
                      ? PayzoInputFormatters.street
                      : fieldKey == 'city'
                          ? PayzoInputFormatters.city
                          : fieldKey == 'zip'
                              ? PayzoInputFormatters.onlyFiveDigits
                              : PayzoInputFormatters.alphanumeric,
              label: fieldKey == 'building'
                  ? 'Building Number'
                  : fieldKey[0].toUpperCase() + fieldKey.substring(1),
              controller: controller[fieldKey],
              errorText: state
                  .errors['${isBilling ? 'billing' : 'shipping'}.$fieldKey'],
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
              });
        }).toList(),
      ],
    );
  }
}
