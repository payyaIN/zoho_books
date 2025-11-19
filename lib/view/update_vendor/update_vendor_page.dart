import 'package:payzo_books/data/models/vendor_model_list/vendor_model.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_model.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_provider.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_customer/add_customer_repository.dart';
import 'package:payzo_books/data/repository/add_vendor/add_vendor_repository.dart';
import 'package:payzo_books/data/repository/add_vendor/get_state_list_repository.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_repo.dart';
import 'package:payzo_books/data/repository/vendor_api/vendor_listing/vendor_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/input_formatters.dart';
import 'package:payzo_books/utils/common_widgets/reusable_scaffold_messenger.dart';
import 'package:payzo_books/utils/common_widgets/reusable_snackbar.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_notifier.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/utils/common_widgets/sar_textfield.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_provider.dart';
import 'package:payzo_books/data/models/view_party/view_party_model.dart';
import '../../../data/repository/add_vendor/get_country_list_repository.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/data/models/view_party/view_party_model.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_notifier.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_provider.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_repo.dart';
import 'package:payzo_books/data/repository/add_vendor/get_country_list_repository.dart';
import 'package:payzo_books/data/repository/document_type/get_doc_type_api.dart';
import 'package:payzo_books/data/repository/event_api/get_event_api.dart';
import 'package:payzo_books/data/repository/price_currency/price_currency_api.dart';

final vendorBillingTileExpandedProvider = StateProvider<bool>((ref) => false);
final vendorShippingTileExpandedProvider = StateProvider<bool>((ref) => false);
final sameAsBillingToggleProvider = StateProvider<bool>((ref) => false);

class UpdateVendorScreen extends ConsumerStatefulWidget {
  final int? partyId;
  const UpdateVendorScreen({super.key, this.partyId});

  @override
  ConsumerState<UpdateVendorScreen> createState() => _UpdateVendorScreenState();
}

class _UpdateVendorScreenState extends ConsumerState<UpdateVendorScreen> {
  var vendorControllers = <String, TextEditingController>{};
  TextEditingController openingAmount = TextEditingController();

  var topSectionLabels = <String, String>{
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

  var billingAddressLabels = <String, String>{
    'building': 'Building Number',
    'streetAddress': 'Street Address',
    'city': 'City',
    'streetAddressArabic': 'Street Address (Arabic)',
    'cityArabic': 'City (Arabic)',
    'zip': 'Zip',
  };

  var shippingAddressLabels = <String, String>{
    'building': 'Building Number',
    'streetAddress': 'Street Address',
    'city': 'City',
    'streetAddressArabic': 'Street Address (Arabic)',
    'cityArabic': 'City (Arabic)',
    'zip': 'Zip',
  };

  var billingControllers = <String, TextEditingController>{};
  var shippingControllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    vendorControllers = {
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

    billingControllers = {
      'building': TextEditingController(),
      'streetAddress': TextEditingController(),
      'streetAddressArabic': TextEditingController(),
      'city': TextEditingController(),
      'cityArabic': TextEditingController(),
      'zip': TextEditingController(),
    };

    shippingControllers = {
      'building': TextEditingController(),
      'streetAddress': TextEditingController(),
      'streetAddressArabic': TextEditingController(),
      'city': TextEditingController(),
      'cityArabic': TextEditingController(),
      'zip': TextEditingController(),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isEditMode = ref.read(updateVendorEditModeProvider);
      if (isEditMode) {
        _populateVendorData();
      }
    });
  }

  /// ✅ NEW: Populate from complete ViewParty data
  void _populateFromViewParty(ViewPartyResponseData data) {
    print('✅ Populating all fields from ViewParty data');

    final notifier = ref.read(updateVendorFormProvider.notifier);

    // ========== TEXT CONTROLLERS ==========

    // Primary contact
    vendorControllers['firstName']?.text = data.primaryContact.firstName;
    vendorControllers['secondName']?.text = data.primaryContact.lastName;

    // ✅ Arabic names
    vendorControllers['firstNameArabic']?.text =
        data.primaryContactArabic?.firstNameArabic ?? '';
    vendorControllers['secondNameArabic']?.text =
        data.primaryContactArabic?.lastNameArabic ?? '';

    // Company
    vendorControllers['companyName']?.text = data.companyName;
    vendorControllers['companyNameArabic']?.text = data.companyNameArabic ?? '';

    // Contact
    vendorControllers['email']?.text = data.emailAddress;
    vendorControllers['workPhone']?.text = data.phone.toString();
    vendorControllers['mobile']?.text = data.mobile.toString();

    // ✅ VAT and CR
    vendorControllers['vatNumber']?.text = data.vatNumber ?? '';
    vendorControllers['crNumber']?.text = data.crNum ?? '';

    // ========== BILLING ADDRESS ==========

    billingControllers['building']?.text = data.billingAddress.buildingNumber;
    billingControllers['streetAddress']?.text =
        data.billingAddress.streetAddress ?? '';
    billingControllers['streetAddressArabic']?.text =
        data.billingAddress.streetAddressArabic ?? '';
    billingControllers['city']?.text = data.billingAddress.city;
    billingControllers['cityArabic']?.text =
        data.billingAddress.cityArabic ?? '';
    billingControllers['zip']?.text = data.billingAddress.zipCode;

    // Update state
    notifier.updateBillingAddress('addressId', data.billingAddress.addressId);
    notifier.updateBillingAddress(
        'building', data.billingAddress.buildingNumber);
    notifier.updateBillingAddress(
        'streetAddress', data.billingAddress.streetAddress ?? '');
    notifier.updateBillingAddress(
        'streetAddressArabic', data.billingAddress.streetAddressArabic ?? '');
    notifier.updateBillingAddress('city', data.billingAddress.city);
    notifier.updateBillingAddress(
        'cityArabic', data.billingAddress.cityArabic ?? '');
    notifier.updateBillingAddress(
        'countryRegion', data.billingAddress.countryRegion);
    notifier.updateBillingAddress('state', data.billingAddress.state);
    notifier.updateBillingAddress('zip', data.billingAddress.zipCode);

    // ========== SHIPPING ADDRESS ==========

    shippingControllers['building']?.text = data.shippingAddress.buildingNumber;
    shippingControllers['streetAddress']?.text =
        data.shippingAddress.streetAddress ?? '';
    shippingControllers['streetAddressArabic']?.text =
        data.shippingAddress.streetAddressArabic ?? '';
    shippingControllers['city']?.text = data.shippingAddress.city;
    shippingControllers['cityArabic']?.text =
        data.shippingAddress.cityArabic ?? '';
    shippingControllers['zip']?.text = data.shippingAddress.zipCode;

    // Update state
    notifier.updateShippingAddress('addressId', data.shippingAddress.addressId);
    notifier.updateShippingAddress(
        'building', data.shippingAddress.buildingNumber);
    notifier.updateShippingAddress(
        'streetAddress', data.shippingAddress.streetAddress ?? '');
    notifier.updateShippingAddress(
        'streetAddressArabic', data.shippingAddress.streetAddressArabic ?? '');
    notifier.updateShippingAddress('city', data.shippingAddress.city);
    notifier.updateShippingAddress(
        'cityArabic', data.shippingAddress.cityArabic ?? '');
    notifier.updateShippingAddress(
        'countryRegion', data.shippingAddress.countryRegion);
    notifier.updateShippingAddress('state', data.shippingAddress.state);
    notifier.updateShippingAddress('zip', data.shippingAddress.zipCode);

    // ========== VENDOR STATE FIELDS ==========

    notifier.updateField('firstName', data.primaryContact.firstName);
    notifier.updateField('secondName', data.primaryContact.lastName);
    notifier.updateField(
        'firstNameArabic', data.primaryContactArabic?.firstNameArabic ?? '');
    notifier.updateField(
        'secondNameArabic', data.primaryContactArabic?.lastNameArabic ?? '');
    notifier.updateField('companyName', data.companyName);
    notifier.updateField('companyNameArabic', data.companyNameArabic ?? '');
    notifier.updateField('email', data.emailAddress);
    notifier.updateField('mobile', data.mobile.toString());
    notifier.updateField('workPhone', data.phone.toString());
    notifier.updateField('displayName', data.displayName);
    notifier.updateField('partyType', data.partyType);
    notifier.updateField('mobileCode', data.mobileCode);
    notifier.updateField('phoneCode', data.phoneCode);
    notifier.updateField('vatNumber', data.vatNumber ?? '');
    notifier.updateField('crNum', data.crNum ?? '');

    // Same address flag
    ref.read(sameAsBillingToggleProvider.notifier).state = data.sameAddressFlag;

    print('✅ All fields populated successfully!');
  }

  void _populateVendorData() {
    // ✅ FIRST: Try ViewParty data (complete)
    final viewPartyData = ref.read(viewPartyEditDataProvider);
    if (viewPartyData != null) {
      print('✅ Found ViewParty data, using complete population');
      _populateFromViewParty(viewPartyData);
      return;
    }

    // ⚠️ FALLBACK: Basic Vendor model (incomplete)
    final vendorData = ref.read(vendorEditDataProvider);
    if (vendorData != null) {
      print('⚠️ Using fallback Vendor model (incomplete data)');
      _populateFromVendor(vendorData);
      return;
    }

    print('❌ No vendor data available for population');
  }

  void _populateFromVendor(Vendor data) {
    print('✅ Populating from Vendor model with all fields');

    final notifier = ref.read(updateVendorFormProvider.notifier);

    // ========== TEXT CONTROLLERS ==========

    // Primary contact
    vendorControllers['firstName']?.text = data.primaryContact.firstName ?? '';
    vendorControllers['secondName']?.text = data.primaryContact.lastName ?? '';

    // ✅ Arabic names - NOW AVAILABLE!
    vendorControllers['firstNameArabic']?.text =
        data.primaryContactArabic?.firstNameArabic ?? '';
    vendorControllers['secondNameArabic']?.text =
        data.primaryContactArabic?.lastNameArabic ?? '';

    // Company
    vendorControllers['companyName']?.text = data.companyName ?? '';
    vendorControllers['companyNameArabic']?.text = data.companyNameArabic ?? '';

    // Contact
    vendorControllers['email']?.text = data.emailAddress ?? '';
    vendorControllers['workPhone']?.text = data.phone?.toString() ?? '';
    vendorControllers['mobile']?.text = data.mobile?.toString() ?? '';

    // ✅ VAT and CR - NOW AVAILABLE!
    vendorControllers['vatNumber']?.text = data.vatNumber ?? '';
    vendorControllers['crNumber']?.text = data.crNum ?? '';

    // ========== BILLING ADDRESS ==========

    billingControllers['building']?.text =
        data.billingAddress.buildingNumber ?? '';
    billingControllers['streetAddress']?.text =
        data.billingAddress.streetAddress ?? '';
    billingControllers['streetAddressArabic']?.text =
        data.billingAddress.streetAddressArabic ?? ''; // ✅ NOW AVAILABLE!
    billingControllers['city']?.text = data.billingAddress.city ?? '';
    billingControllers['cityArabic']?.text =
        data.billingAddress.cityArabic ?? ''; // ✅ NOW AVAILABLE!
    billingControllers['zip']?.text = data.billingAddress.zipCode ?? '';

    // Update form state
    notifier.updateBillingAddress(
        'building', data.billingAddress.buildingNumber ?? '');
    notifier.updateBillingAddress(
        'streetAddress', data.billingAddress.streetAddress ?? '');
    notifier.updateBillingAddress(
        'streetAddressArabic', data.billingAddress.streetAddressArabic ?? '');
    notifier.updateBillingAddress('city', data.billingAddress.city ?? '');
    notifier.updateBillingAddress(
        'cityArabic', data.billingAddress.cityArabic ?? '');
    notifier.updateBillingAddress(
        'countryRegion', data.billingAddress.countryRegion ?? '');
    notifier.updateBillingAddress('state', data.billingAddress.state ?? '');
    notifier.updateBillingAddress('zip', data.billingAddress.zipCode ?? '');

    // ========== SHIPPING ADDRESS ==========

    shippingControllers['building']?.text =
        data.shippingAddress.buildingNumber ?? '';
    shippingControllers['streetAddress']?.text =
        data.shippingAddress.streetAddress ?? '';
    shippingControllers['streetAddressArabic']?.text =
        data.shippingAddress.streetAddressArabic ?? ''; // ✅ NOW AVAILABLE!
    shippingControllers['city']?.text = data.shippingAddress.city ?? '';
    shippingControllers['cityArabic']?.text =
        data.shippingAddress.cityArabic ?? ''; // ✅ NOW AVAILABLE!
    shippingControllers['zip']?.text = data.shippingAddress.zipCode ?? '';

    // Update form state
    notifier.updateShippingAddress(
        'building', data.shippingAddress.buildingNumber ?? '');
    notifier.updateShippingAddress(
        'streetAddress', data.shippingAddress.streetAddress ?? '');
    notifier.updateShippingAddress(
        'streetAddressArabic', data.shippingAddress.streetAddressArabic ?? '');
    notifier.updateShippingAddress('city', data.shippingAddress.city ?? '');
    notifier.updateShippingAddress(
        'cityArabic', data.shippingAddress.cityArabic ?? '');
    notifier.updateShippingAddress(
        'countryRegion', data.shippingAddress.countryRegion ?? '');
    notifier.updateShippingAddress('state', data.shippingAddress.state ?? '');
    notifier.updateShippingAddress('zip', data.shippingAddress.zipCode ?? '');

    // ========== VENDOR STATE FIELDS ==========

    notifier.updateField('firstName', data.primaryContact.firstName ?? '');
    notifier.updateField('secondName', data.primaryContact.lastName ?? '');
    notifier.updateField(
        'firstNameArabic', data.primaryContactArabic?.firstNameArabic ?? '');
    notifier.updateField(
        'secondNameArabic', data.primaryContactArabic?.lastNameArabic ?? '');
    notifier.updateField('companyName', data.companyName ?? '');
    notifier.updateField('companyNameArabic', data.companyNameArabic ?? '');
    notifier.updateField('email', data.emailAddress ?? '');
    notifier.updateField('mobile', data.mobile?.toString() ?? '');
    notifier.updateField('workPhone', data.phone?.toString() ?? '');
    notifier.updateField('displayName', data.displayName ?? '');
    notifier.updateField('partyType', data.partyType ?? '');
    notifier.updateField('mobileCode', data.mobileCode ?? '');
    notifier.updateField('phoneCode', data.phoneCode ?? '');
    notifier.updateField('vatNumber', data.vatNumber ?? '');
    notifier.updateField('crNum', data.crNum ?? '');

    print('✅ All fields populated successfully from Vendor model!');
  }

  @override
  void dispose() {
    // Clear edit mode when leaving
    ref.read(updateVendorEditModeProvider.notifier).state = false;
    ref.read(updateVendorEditPartyIdProvider.notifier).state = null;
    ref.read(viewPartyEditDataProvider.notifier).state = null;
    ref.read(vendorEditDataProvider.notifier).state = null;

    // Dispose controllers
    for (final controller in vendorControllers.values) {
      controller.dispose();
    }
    for (final controller in billingControllers.values) {
      controller.dispose();
    }
    for (final controller in shippingControllers.values) {
      controller.dispose();
    }
    openingAmount.dispose();

    super.dispose();
  }

  Future<void> _updateVendor() async {
    final partyId = widget.partyId ?? ref.read(updateVendorEditPartyIdProvider);

    print(
        '🔵 Using partyId: $partyId (widget: ${widget.partyId}, provider: ${ref.read(updateVendorEditPartyIdProvider)})');

    if (partyId == null || partyId == 0) {
      showSnackBar(context, 'Error: Vendor ID not found');
      return;
    }
    // final partyId = ref.read(updateVendorEditPartyIdProvider);
    // if (partyId == null) {
    //   showSnackBar(context, 'Error: Vendor ID not found');
    //   return;
    // }

    try {
      showPayzoProgress(context: context);

      final result =
          await ref.read(updateVendorRepoProvider).updateVendor(partyId);

      Navigator.of(context).pop(); // Close progress

      if (result.status == true) {
        showSnackBar(
            context, result.successMsg ?? 'Vendor updated successfully');

        // Clear edit mode
        ref.read(updateVendorEditModeProvider.notifier).state = false;
        ref.read(updateVendorEditPartyIdProvider.notifier).state = null;
        ref.read(vendorEditDataProvider.notifier).state = null;
        // Refresh vendor list
        ref.invalidate(getVendorData);
        ref.invalidate(getAllVendorsData);

        // Navigate back
        Navigator.of(context).pop();
      } else {
        showSnackBar(context, result.errorMsg ?? 'Failed to update vendor');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close progress
      showSnackBar(context, 'Error updating vendor: $e');
    }
  }

  Future<void> _saveVendor() async {
    try {
      showPayzoProgress(context: context);

      final result =
          await ref.read(registerVendorRepoProvider).registerVendor();

      Navigator.of(context).pop(); // Close progress

      if (result.status == true) {
        showSnackBar(context, result.successMsg ?? 'Vendor added successfully');

        // Refresh vendor list
        ref.invalidate(getVendorData);
        ref.invalidate(getAllVendorsData);

        // Navigate back
        Navigator.of(context).pop();
      } else {
        showSnackBar(context, result.errorMsg ?? 'Failed to add vendor');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close progress
      showSnackBar(context, 'Error adding vendor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorState = ref.watch(updateVendorFormProvider);
    final notifier = ref.read(updateVendorFormProvider.notifier);
    final isBillingExpanded = ref.watch(vendorBillingTileExpandedProvider);
    final isShippingExpanded = ref.watch(vendorShippingTileExpandedProvider);
    final state = ref.read(updateVendorFormProvider);

    // ✅ Core data providers (already present)
    final data = ref.watch(getCountryList);
    final stateData = ref.watch(getStateList);
    final countryList = ref.watch(getCountryList);

    // ✅ NEW: Pre-load dropdown data providers (matching web behavior)
    final documentTypes = ref.watch(documentTypesProvider);
    final branchList = ref.watch(fetchBranchListProvider);
    final priceCurrencies = ref.watch(priceCurrenciesProvider);
    final events = ref.watch(eventsProvider);

    // Other providers
    final sameAsBilling = ref.watch(sameAsBillingToggleProvider);
    final customer = ref.watch(customerFormProvider);
    final currencyName = ref.watch(openingBalanceProvider);
    final branchName = ref.watch(openingAmountProvider);
    final sameAddress = ref.read(sameAsBillingToggleProvider.notifier).state;

    // ✅ Check if any critical data is still loading
    final isLoadingCriticalData = data.isLoading ||
        stateData.isLoading ||
        documentTypes.isLoading ||
        branchList.isLoading ||
        priceCurrencies.isLoading ||
        events.isLoading;
    return ScalingFactor(
        child: PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                final notifier = ref.read(updateVendorFormProvider.notifier);
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
                  title: 'Update Vendor',
                  // title: ref.watch(vendorEditModeProvider)
                  //     ? 'Update Vendor'
                  //     : 'Add Vendor',
                  context: context,
                  showBackButton: true),
              body: isLoadingCriticalData
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.appMainColor,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading vendor details...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
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
                                              label:
                                                  topSectionLabels[entry.key] ??
                                                      entry.key,
                                              inputFormatters: entry
                                                          .key ==
                                                      'workPhone'
                                                  ? PayzoInputFormatters
                                                      .mobileNumber
                                                  : entry.key == 'vatNumber'
                                                      ? PayzoInputFormatters
                                                          .saudiVatNumber
                                                      : entry.key == 'crNumber'
                                                          ? PayzoInputFormatters
                                                              .saudiCrNumber
                                                          : entry
                                                                      .key ==
                                                                  'mobile'
                                                              ? PayzoInputFormatters
                                                                  .mobileNumber
                                                              : entry.key ==
                                                                      'email'
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
                                              keyboardType: entry.key ==
                                                          'workPhone' ||
                                                      entry.key == 'mobile' ||
                                                      entry.key ==
                                                          'vatNumber' ||
                                                      entry.key == 'crNumber'
                                                  ? TextInputType.phone
                                                  : entry.key == 'email'
                                                      ? TextInputType
                                                          .emailAddress
                                                      : TextInputType.text,
                                              required: entry.key ==
                                                          'companyName' ||
                                                      entry.key ==
                                                          'companyNameArabic'
                                                  ? true
                                                  : false,
                                              countryTap: entry.key ==
                                                      'workPhone'
                                                  ? () async {
                                                      await ref
                                                          .read(
                                                              focusUtilsProvider)
                                                          .unfocusAndDelay();
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        builder: (_) =>
                                                            data.when(
                                                          data: (data) =>
                                                              ReusableCountryBottomSheet(
                                                            title: 'Countries',
                                                            items: data.response
                                                                    ?.map((e) =>
                                                                        e.countryName!)
                                                                    .toList() ??
                                                                [],
                                                            onSelect:
                                                                (selectedCountry) {
                                                              final selected = data
                                                                  .response
                                                                  ?.firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .countryName ==
                                                                    selectedCountry,
                                                              );
                                                              if (selected !=
                                                                  null) {
                                                                ref
                                                                    .read(countryPhoneProvider
                                                                        .notifier)
                                                                    .state = selected
                                                                        .ccphnCode
                                                                        ?.toString() ??
                                                                    '';
                                                                ref
                                                                    .read(countryFlagProvider
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
                                                            print(
                                                                'error is $err');
                                                            return SizedBox();
                                                          },
                                                          loading: () =>
                                                              ReusableSizedBox(
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
                                                          .read(
                                                              focusUtilsProvider)
                                                          .unfocusAndDelay();
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        builder: (_) =>
                                                            data.when(
                                                          data: (data) =>
                                                              ReusableCountryBottomSheet(
                                                            title: 'Countries',
                                                            items: data.response
                                                                    ?.map((e) =>
                                                                        e.countryName!)
                                                                    .toList() ??
                                                                [],
                                                            onSelect:
                                                                (selectedCountry) {
                                                              final selected = data
                                                                  .response
                                                                  ?.firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .countryName ==
                                                                    selectedCountry,
                                                              );
                                                              if (selected !=
                                                                  null) {
                                                                ref
                                                                    .read(countryPhoneMobileProvider
                                                                        .notifier)
                                                                    .state = selected
                                                                        .ccphnCode
                                                                        ?.toString() ??
                                                                    '';
                                                                ref
                                                                    .read(countryFlagMobileProvider
                                                                        .notifier)
                                                                    .state = selected
                                                                        .countryFlag
                                                                        ?.toString() ??
                                                                    '';
                                                                notifier.updateField(
                                                                    'mobileCode',
                                                                    selected.ccphnCode
                                                                            ?.toString() ??
                                                                        '');
                                                              }
                                                            },
                                                          ),
                                                          error: (err, _) {
                                                            print(_);
                                                            print(
                                                                'error is $err');
                                                            return SizedBox();
                                                          },
                                                          loading: () =>
                                                              ReusableSizedBox(
                                                            width: 10,
                                                            height: 10,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                              controller: entry.value,
                                              errorText:
                                                  vendorState.errors[entry.key],
                                              countryFlagCode: entry.key ==
                                                      'workPhone'
                                                  ? ref.watch(
                                                      countryFlagProvider)
                                                  : entry.key == 'mobile'
                                                      ? ref.watch(
                                                          countryFlagMobileProvider)
                                                      : null,
                                              onChanged: (value) =>
                                                  notifier.updateField(
                                                      entry.key, value),
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
                                .read(
                                    vendorBillingTileExpandedProvider.notifier)
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
                                  errorText:
                                      vendorState.errors['billing_country'],
                                  trailing: state.billingAddress['country']!
                                              .isEmpty ||
                                          state.billingAddress['country'] == ''
                                      ? 'Tap to Select'
                                      : '${state.billingAddress['country']}',
                                  isPayzoColor: true,
                                  onTap: () async {
                                    await ref
                                        .read(focusUtilsProvider)
                                        .unfocusAndDelay();

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => data.when(
                                          data: (data) =>
                                              ReusableCountryBottomSheet(
                                                title: 'Countries',
                                                items: data.response
                                                        ?.map((e) =>
                                                            e.countryName ?? '')
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
                                                        selected.countryName ??
                                                            '');
                                                    ref
                                                        .read(
                                                            countryCodeProvider
                                                                .notifier)
                                                        .state = selected.ccid
                                                            ?.toString() ??
                                                        '';
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
                                                  CircularProgressIndicator())),
                                    );
                                  },
                                ),
                                PayzoBottomsheetNavigator(
                                  required: true,
                                  title: 'State',
                                  errorText:
                                      vendorState.errors['billing_state'],
                                  trailing: state.billingAddress['state']!
                                              .isEmpty ||
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
                                    await ref
                                        .read(focusUtilsProvider)
                                        .unfocusAndDelay();

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => stateData.when(
                                          data: (data) =>
                                              ReusableCountryBottomSheet(
                                                title: 'State',
                                                items: data.response
                                                        ?.map((e) =>
                                                            e.rName ?? '')
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
                                              child:
                                                  CircularProgressIndicator())),
                                    );
                                  },
                                ),
                                ReusableColumn(
                                  children: billingControllers.entries
                                      .map((entry) => PayzoInputField(
                                          label:
                                              billingAddressLabels[entry.key] ??
                                                  entry.key,
                                          keyboardType:
                                              entry.key == 'building' ||
                                                      entry.key == 'zip'
                                                  ? TextInputType
                                                      .numberWithOptions()
                                                  : TextInputType.text,
                                          inputFormatters: entry.key ==
                                                      'building' ||
                                                  entry.key == 'zip'
                                              ? PayzoInputFormatters
                                                  .onlyFiveDigits
                                              : entry.key == 'street'
                                                  ? PayzoInputFormatters.street
                                                  : PayzoInputFormatters.city,
                                          controller: entry.value,
                                          required: entry.key == 'city' ||
                                              entry.key == 'cityArabic',
                                          errorText: vendorState
                                              .errors['billing_${entry.key}'],
                                          onChanged: (value) {
                                            notifier.updateBillingAddress(
                                                entry.key, value);

                                            // ✅ Also update shipping if sameAsBilling toggle is ON
                                            if (ref.read(
                                                sameAsBillingToggleProvider)) {
                                              if (shippingControllers
                                                  .containsKey(entry.key)) {
                                                shippingControllers[entry.key]
                                                    ?.text = value;
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
                                title:
                                    'Use Billing Address as Shipping Address',
                                value: sameAsBilling,
                                onChanged: (value) {
                                  ref
                                      .read(
                                          sameAsBillingToggleProvider.notifier)
                                      .state = value;

                                  final notifier = ref
                                      .read(updateVendorFormProvider.notifier);
                                  notifier.updateSameAddressFlag(value);

                                  if (value) {
                                    // ✅ Copy billing text controllers to shipping
                                    billingControllers
                                        .forEach((key, billingController) {
                                      if (shippingControllers
                                          .containsKey(key)) {
                                        shippingControllers[key]!.text =
                                            billingController.text;
                                      }
                                    });

                                    // ✅ Also copy country and state to shipping address state
                                    final billing = ref
                                        .read(updateVendorFormProvider)
                                        .billingAddress;
                                    notifier.state = notifier.state.copyWith(
                                      shippingAddress: Map.from(billing),
                                    );
                                  } else {
                                    // 🧹 Clear all shipping fields (including country/state)
                                    shippingControllers
                                        .forEach((key, controller) {
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
                                .read(
                                    vendorShippingTileExpandedProvider.notifier)
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
                                        message: 'Shipping country cleared',
                                        type: PayzoSnackType.success);
                                  },
                                  enabled: sameAddress == true ? false : true,
                                  errorText:
                                      vendorState.errors['shipping_country'],
                                  required: true,
                                  title: 'Country',
                                  trailing: state.shippingAddress['country']!
                                              .isEmpty ||
                                          state.shippingAddress['country'] == ''
                                      ? 'Tap to Select'
                                      : '${state.shippingAddress['country']}',
                                  isPayzoColor: true,
                                  onTap: () async {
                                    await ref
                                        .read(focusUtilsProvider)
                                        .unfocusAndDelay();

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => data.when(
                                          data: (data) =>
                                              ReusableCountryBottomSheet(
                                                title: 'Countries',
                                                items: data.response
                                                        ?.map((e) =>
                                                            e.countryName ?? '')
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
                                                        selected.countryName ??
                                                            '');
                                                    ref
                                                        .read(
                                                            countryCodeProvider
                                                                .notifier)
                                                        .state = selected.ccid
                                                            ?.toString() ??
                                                        '';
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
                                                  CircularProgressIndicator())),
                                    );
                                  },
                                ),
                                PayzoBottomsheetNavigator(
                                  onUnselect: () {
                                    notifier.clearShippingState();
                                    showPayzoSnackBar(
                                        context: context,
                                        ref: ref,
                                        message: 'Shipping state cleared',
                                        type: PayzoSnackType.success);
                                  },
                                  enabled: sameAddress == true ? false : true,
                                  required: true,
                                  title: 'State',
                                  errorText:
                                      vendorState.errors['shipping_state'],
                                  trailing: state.shippingAddress['state']!
                                              .isEmpty ||
                                          state.shippingAddress['state'] == ''
                                      ? 'Tap to Select'
                                      : '${state.shippingAddress['state']}',
                                  isPayzoColor: true,
                                  onTap: () async {
                                    await ref
                                        .read(focusUtilsProvider)
                                        .unfocusAndDelay();

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => stateData.when(
                                          data: (data) =>
                                              ReusableCountryBottomSheet(
                                                title: 'State',
                                                items: data.response
                                                        ?.map((e) =>
                                                            e.rName ?? '')
                                                        .toList() ??
                                                    [],
                                                onSelect: (selectedCountry) {
                                                  notifier
                                                      .updateShippingAddress(
                                                          'state',
                                                          selectedCountry);
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
                                                  CircularProgressIndicator())),
                                    );
                                  },
                                ),
                                Column(
                                  children: shippingControllers.entries
                                      .map((entry) => PayzoInputField(
                                            enabled: sameAddress == true
                                                ? false
                                                : true,
                                            keyboardType:
                                                entry.key == 'building' ||
                                                        entry.key == 'zip'
                                                    ? TextInputType
                                                        .numberWithOptions()
                                                    : TextInputType.text,
                                            inputFormatters: entry.key ==
                                                        'streetAddressArabic' ||
                                                    entry.key == 'cityArabic'
                                                ? PayzoInputFormatters
                                                    .onlyArabic
                                                : entry.key == 'building' ||
                                                        entry.key == 'zip'
                                                    ? PayzoInputFormatters
                                                        .onlyFiveDigits
                                                    : entry.key == 'street'
                                                        ? PayzoInputFormatters
                                                            .street
                                                        : PayzoInputFormatters
                                                            .city,
                                            label: shippingAddressLabels[
                                                    entry.key] ??
                                                entry.key,
                                            controller: entry.value,
                                            required: entry.key == 'city' ||
                                                entry.key == 'cityArabic',
                                            errorText: vendorState.errors[
                                                'shipping_${entry.key}'],
                                            // ✅ Match key pattern
                                            onChanged: (value) =>
                                                notifier.updateShippingAddress(
                                                    entry.key, value),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              bottomNavigationBar: Consumer(builder: (context, ref, child) {
                final isEditMode = ref.watch(updateVendorEditModeProvider);

                return PayzoFormSubmitTwoButtons(
                  safeArea: true,
                  cancelText: 'Clear',
                  saveText: 'Update',
                  // saveText: isEditMode ? 'Update' : 'Save',
                  cancelOnPressed: () {
                    ref.read(openingAmountProvider.notifier).state =
                        'Tap to Select';
                    openingAmount.text = '';
                    vendorControllers.values.forEach((c) => c.clear());
                    billingControllers.values.forEach((c) => c.clear());
                    shippingControllers.values.forEach((c) => c.clear());
                    ref.read(sameAsBillingToggleProvider.notifier).state =
                        false;
                    notifier.clearForm();
                  },
                  saveOnPressed: () async {
                    await _updateVendor();
                  },

                  // saveOnPressed: () async {
                  //   if (isEditMode) {
                  //     await _updateVendor();
                  //   } else {
                  //     await _saveVendor();
                  //   }
                  // }
                );
              }),
            )));
  }
}
