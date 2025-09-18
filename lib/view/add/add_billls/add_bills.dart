import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:payzo_books/data/repository/add_bills/generate_bill_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_all_bills_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_item_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/shipping_method_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import 'package:payzo_books/view/add/add_billls/widgets/bill_total_widget.dart';
import 'package:payzo_books/view/add/add_billls/widgets/item_details_add_bills.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';

import '../../../utils/focus_utility/focus_utility.dart';

class AddBills extends ConsumerStatefulWidget {
  const AddBills({super.key});

  @override
  ConsumerState<AddBills> createState() => _AddBillsState();
}

class _AddBillsState extends ConsumerState<AddBills> {
  bool _initialized = false;
  List <TextEditingController>controllers=[
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List <TextEditingController>billDetailsControllers=[
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    if (!_initialized) {
      Future.microtask(() {
        final itemDetails = ref.read(addBillFormProvider).itemDetails;

        // ✅ Only add item if list is empty
        if (itemDetails.isEmpty) {
          ref.read(addBillFormProvider.notifier).addNewItem();
        }
        // 🔄 Fetch all required data
        ref.read(fetchItemListProvider);
        ref.read(fetchAccountListProvider);
        ref.read(fetchUnitListProvider);
        ref.read(fetchBranchListProvider);
        ref.read(fetchShippingMethodsProvider);
        ref.read(fetchPriceCurrencyProvider);
        ref.read(fetchAllTaxesProvider);
        ref.read(getVendorList);
      });
      _initialized = true;
    }
  }

  Future<void> clearFormAndControllers() async {
    final notifier = ref.read(addBillFormProvider.notifier);
    controllers[1].text='';
    controllers[0].text='';
    controllers[2].text='';
    billDetailsControllers[0].text='';
    billDetailsControllers[1].text='';
    billDetailsControllers[2].text='';
    billDetailsControllers[3].text='';
    billDetailsControllers[4].text='';
    // 🧹 Clear all form data
    notifier.clearForm();

    // 🔁 Reset to just one line item
    notifier.addNewItem();

    // 🧮 Reset any state counter if you're using it elsewhere
    ref.read(addNewLineProvider.notifier).state = 1;
    final shippingMethods = await ref.read(fetchShippingMethodsProvider.future);
    final landFreight = shippingMethods.firstWhere(
          (method) => method.shpmName == "Land Freight",
      orElse: () => shippingMethods.first,
    );
    notifier.updateField('shippingMethod', landFreight.shpmName ?? '');
    notifier.updateField('shippingMethodId', landFreight.shpmId);

    // 💵 Set default price currency "SAR"
    final currencyList = await ref.read(fetchPriceCurrencyProvider.future);
    final sarCurrency = currencyList.firstWhere(
          (currency) => currency.currencyValue == "SAR",
      orElse: () => currencyList.first,
    );
    notifier.updateField('currency', sarCurrency.currencyValue ?? '');
    notifier.updateField('currencyId', sarCurrency.currencyId); // ✅ Important for backend payload
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addBillFormProvider);
    final notifier = ref.read(addBillFormProvider.notifier);

    return ScalingFactor(
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            clearFormAndControllers();
          }
        },
        child: Scaffold(
          appBar: reusableAppBar(
            title: 'Add Bills',
            context: context,
            showBackButton: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: ReusableColumn(
              children: <Widget>[
                BillDetailsAddBills(controller: billDetailsControllers,),
                const ReusableSizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.itemDetails.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ItemDetailsAddBills(index: index,controllers: controllers,),
                    );
                  },
                ),
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
                        await ref.read(focusUtilsProvider).unfocusAndDelay();

                        final isValid = ref
                            .read(addBillFormProvider.notifier)
                            .validateLastItemFields();

                        if (isValid) {
                          ref.read(addBillFormProvider.notifier).addNewItem();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Finish filling out the current item to add a new one.'),
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
                          await ref.read(focusUtilsProvider).unfocusAndDelay();
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
                          );

                          if (result != null &&
                              result.files.single.path != null) {
                            final pickedFile = File(result.files.single.path!);
                            notifier.updateField('attachment', pickedFile);
                          } else {
                            debugPrint('❌ No file selected');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                BillTotalWidget(),
              ],
            ),
          ),
          bottomNavigationBar: PayzoFormSubmitTwoButtons(
              safeArea: true,
              cancelText: 'Clear',
              saveText: 'Save',
              cancelOnPressed: () {
                notifier.clearForm();
                clearFormAndControllers();
                ref.read(addNewLineProvider.notifier).state = 1;
              },
              saveOnPressed: () async {
                notifier.validateForm();

                // Allow state rebuild
                await Future.delayed(Duration.zero);

                final currentState = ref.read(addBillFormProvider);
                final file = currentState.attachment;

                if (currentState.errors.isEmpty) {
                  showPayzoProgress(context: context);
                  try {
                    final response = await ref.read(generateBillProvider(file).future);

                    Navigator.pop(context); // ✅ pop progress indicator after API call

                    String invoiceNumber = 'N/A';
                    String billId = 'N/A';

                    if (response.details != null && response.details!.isNotEmpty) {
                      invoiceNumber = response.details!.first.billInvoiceNumber ?? 'N/A';
                      billId = response.details!.first.billId.toString();
                    }

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("✅ Success"),
                        content: Text("Bill Generated\n\nInvoice: $invoiceNumber\nID: $billId"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              notifier.clearForm();
                              clearFormAndControllers();
                              ref.read(addNewLineProvider.notifier).state = 1;
                              ref.read(bottomNavBarProvider.notifier).state = 3;
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
                  } catch (e) {
                    Navigator.pop(context); // ✅ pop progress on error
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("❌ Error"),
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
                  // ❌ DO NOT pop context here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all required fields')),
                  );
                }
              }
          ),
        ),
      ),
    );
  }
}
