import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/add_bills/get_all_bills_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_item_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
import 'package:payzo_books/data/repository/add_bills/shipping_method_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/add_invoice_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_bank_account_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_customer_list_repo.dart';
import 'package:payzo_books/data/repository/invoice_api/invoice_detail_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/view/add_invoice/notifier/add_invoice_form_notifier.dart';
import 'package:payzo_books/view/add_invoice/widgets/invoice_details_add_invoice.dart';
import 'package:payzo_books/view/add_invoice/widgets/invoice_total_widget.dart';
import 'package:payzo_books/view/add_invoice/widgets/item_details.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';

class AddInvoice extends ConsumerStatefulWidget {
  const AddInvoice({super.key});

  @override
  ConsumerState<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends ConsumerState<AddInvoice> {
  bool _initialized = false;
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<TextEditingController> invoiceDetailsControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      Future.microtask(() {
        final itemDetails = ref.read(invoiceFormProvider).itemDetails;

        // ✅ Add a new line only if no items exist
        if (itemDetails.isEmpty) {
          final notifier = ref.read(invoiceFormProvider.notifier);
          notifier.addNewItem();
          notifier.updateField('orgId',
              1); // ✅ Set orgId here (replace 1 with actual orgId logic)
        }
        // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        //   statusBarColor: AppColors.appGreyColor,
        //   systemNavigationBarColor: AppColors.appGreyColor,
        //   systemNavigationBarIconBrightness: Brightness.light, // For white icons
        // ));
        // 🔄 Preload required APIs
        ref.read(fetchItemListProvider);
        ref.read(fetchAccountListProvider);
        ref.read(fetchUnitListProvider);
        ref.read(fetchCustomerListProvider.future);
        ref.read(fetchBranchListProvider.future);
        ref.read(fetchShippingMethodsProvider.future);
        ref.read(fetchBankAccountListProvider.future);
        ref.read(fetchPriceCurrencyProvider.future);
      });

      _initialized = true;
    }
  }

  void clearFormAndControllers() async {
    final notifier = ref.read(invoiceFormProvider.notifier);
    controllers[1].text = '';
    controllers[0].text = '';
    controllers[2].text = '';
    invoiceDetailsControllers[0].text = '';
    invoiceDetailsControllers[1].text = '';
    invoiceDetailsControllers[2].text = '';
    invoiceDetailsControllers[3].text = '';
    invoiceDetailsControllers[4].text = '';
    // Clear everything first
    notifier.clearForm();

    // Re-add at least one item line
    notifier.addNewItem();

    // Re-set default fields
    notifier.updateField('invoiceDate', DateTime.now());
    notifier.updateField('expiryDate', DateTime.now());
    notifier.updateField('supplyDate', DateTime.now());
    notifier.updateField('orgId', 1); // if orgId is fixed

    // Set default Shipping Method ("Land Freight")
    try {
      final shippingMethods =
          await ref.read(fetchShippingMethodsProvider.future);
      final landFreight = shippingMethods.firstWhere(
        (method) => method.shpmName == "Land Freight",
        orElse: () => shippingMethods.first,
      );
      notifier.updateField('shippingMethod', landFreight.shpmName ?? '');
      notifier.updateField('shippingMethodId', landFreight.shpmId);
    } catch (e) {
      debugPrint('❌ Failed to set default shipping method: $e');
    }

    // Set default Currency ("SAR")
    try {
      final currencies = await ref.read(fetchPriceCurrencyProvider.future);
      final sarCurrency = currencies.firstWhere(
        (c) => c.currencyValue == "SAR",
        orElse: () => currencies.first,
      );
      notifier.updateField('currency', sarCurrency.currencyValue ?? '');
      notifier.updateField('currencyId', sarCurrency.currencyId);
    } catch (e) {
      debugPrint('❌ Failed to set default currency: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(invoiceFormProvider.notifier);
    final state = ref.watch(invoiceFormProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ScalingFactor(
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              clearFormAndControllers();
            }
          },
          child: SizedBox(
            child: Scaffold(
              backgroundColor: AppColors.backgroundColorGrey,
              appBar: reusableAppBar(
                title: 'Add Invoice',
                context: context,
                showBackButton: true,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ReusableColumn(
                  children: <Widget>[
                    InvoiceDetailsAddInvoice(
                      controller: invoiceDetailsControllers,
                    ),
                    const ReusableSizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.itemDetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: ItemDetailsAddInvoice(
                              index: index,
                              controllers: controllers,
                            ));
                      },
                    ),
                    const ReusableSizedBox(height: 25),
                    FormContainer(
                      height: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: PayzoBottomsheetNavigator(
                          isPayzoColor: true,
                          addButton: true,
                          title: 'Item Details',
                          trailing: 'Add New Line',
                          divider: false,
                          onTap: () async {
                            await ref
                                .read(focusUtilsProvider)
                                .unfocusAndDelay();

                            final isValid = ref
                                .read(invoiceFormProvider.notifier)
                                .validateItemFieldsOnly();

                            if (isValid) {
                              ref
                                  .read(invoiceFormProvider.notifier)
                                  .addNewItem();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Finish filling out the current item to add a new one.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const ReusableSizedBox(height: 15),
                    ReusableRow(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SvgPictureWidget(
                            image: 'assets/pin.svg', height: 20, width: 20),
                        const ReusableSizedBox(width: 5),
                        SizedBox(
                          height: 32,
                          width: 321,
                          child: PayzoBottomsheetNavigator(
                            title: 'Attachments',
                            divider: false,
                            trailing: state.attachment?.path.split('/').last ??
                                'Tap to Select',
                            onTap: () async {
                              await ref
                                  .read(focusUtilsProvider)
                                  .unfocusAndDelay();
                              final result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'pdf',
                                  'jpg',
                                  'png',
                                  'jpeg'
                                ],
                              );

                              if (result != null &&
                                  result.files.single.path != null) {
                                final pickedFile =
                                    File(result.files.single.path!);
                                notifier.updateField('attachment', pickedFile);
                              } else {
                                debugPrint('❌ No file selected');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    InvoiceTotalWidget(),
                    const ReusableSizedBox(height: 15),
                  ],
                ),
              ),
              bottomNavigationBar: PayzoFormSubmitTwoButtons(
                safeArea: true,
                cancelText: 'Clear',
                saveText: 'Save',
                cancelOnPressed: () => clearFormAndControllers(),
                saveOnPressed: () async {
                  if (!_initialized) {
                    Future.microtask(() {
                      final notifier = ref.read(invoiceFormProvider.notifier);

                      // Set orgId explicitly (replace 1 with actual org logic if dynamic)
                      notifier.updateField('orgId', 1);
                    });

                    _initialized = true;
                  }

                  final isValid = notifier.validateForm();

                  if (!isValid) {
                    final state = ref.read(invoiceFormProvider);

                    debugPrint(
                        "❌ Validation failed with the following errors:");
                    state.errors.forEach((key, value) {
                      debugPrint("• $key: $value");
                    });

                    Scrollable.ensureVisible(
                      context,
                      duration: const Duration(milliseconds: 300),
                    );
                    return;
                  }

                  final invoiceState = ref.read(invoiceFormProvider);
                  final repo = ref.read(invoiceRepositoryProvider);

                  try {
                    debugPrint("🆔 Org ID: ${state.orgId}");
                    debugPrint("🆔 Branch ID: ${state.branchId}");
                    debugPrint("🆔 Bank Account ID: ${state.bankAccountId}");
                    debugPrint("🆔 Customer ID: ${state.customerId}");
                    final item = invoiceState.itemDetails.isNotEmpty
                        ? invoiceState.itemDetails.first
                        : null;
                    if (item != null) {
                      debugPrint(
                          "🆔 Product ID: ${item.prodId}"); // only if you later add `prodId`
                    }
                    showPayzoProgress(context: context);
                    final response = await repo.submitInvoiceWithAttachment(
                      invoiceDto: repo.buildInvoiceJson(invoiceState),
                      file: invoiceState.attachment,
                    );

                    // ✅ Check if response contains SUCCESS
                    if (response['code'] == 'SUCCESS') {
                      final details = response['details']?[0];
                      final invoiceNumber = details?['invoiceNumber'] ?? '';
                      final invoiceId = details?['invoiceId'] ?? '';
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("✅ Success"),
                          content: Text(
                            "Invoice Generated Successfully.",
                            // \n\nInvoice No: $invoiceNumber\nInvoice ID: $invoiceId
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                notifier.clearForm();
                                Navigator.pop(context);
                                ref.invalidate(getInvoiceDataWithPagination);
                                ref.read(bottomNavBarProvider.notifier).state =
                                    2; // 🔄 set to Vendor/Product index
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteNames.homeScreen,
                                  (route) => false,
                                );
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                      clearFormAndControllers();
                    } else {
                      final msg =
                          response['message'] ?? 'Unexpected error occurred.';
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("❌ Failed"),
                          content: Text(msg),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e, stackTrace) {
                    debugPrint('❌ Invoice submission exception: $e');
                    debugPrint('📄 StackTrace:\n$stackTrace');
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("🚨 Exception"),
                        content: Text("Failed to submit invoice:\n$e"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
