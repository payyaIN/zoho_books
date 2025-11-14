import 'package:payzo_books/data/repository/add_bills/get_item_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_product/add_product_repository.dart';
import 'package:payzo_books/data/repository/add_product/get_all_account_list_repository.dart';
import 'package:payzo_books/data/repository/add_product/get_product_account_list_repo.dart';
import 'package:payzo_books/data/repository/products_api/product_list_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/data/repository/quotes_api/all_quotes_api.dart';
import 'package:payzo_books/view/add/add_product/notifier/add_item_notifier.dart';
import 'package:payzo_books/view/add/add_product/widgets/purchase_section_add_product.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final Map<String, TextEditingController> controllers = {
    'itemName': TextEditingController(),
    'itemNameArabic': TextEditingController(),
    'hsnCode': TextEditingController(),
    'sellingPrice': TextEditingController(),
    'salesDescription': TextEditingController(),
    'salesDescriptionArabic': TextEditingController(),
    'costPrice': TextEditingController(),
    'purchaseDescription': TextEditingController(),
    'purchaseDescriptionArabic': TextEditingController(),
    'openingStock': TextEditingController(),
    'openingStockRate': TextEditingController(),
    'exemptionReason': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getChartOfAccountsProvider);
      ref.read(fetchItemListProvider);
      ref.read(fetchUnitListProvider);
      ref.read(getVendorList);
      ref.read(getProductAccountsProvider);
      ref.read(fetchPriceCurrencyProvider);
      final notifier = ref.read(productFormProvider.notifier);
      notifier.updateRadio('purchaseType', 'Trade'); // 'Trade' for UI
      notifier.updatePurchaseInfo(purchaseType: 1); // 1 for API
      controllers['openingStock']?.text = '0';
    });
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void clearFormAndControllers() {
    final notifier = ref.read(productFormProvider.notifier);
    notifier.clearForm();
    notifier.updatePurchaseInfo(purchaseType: 1);
    for (final controller in controllers.values) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(productFormProvider.notifier);
    final product = ref.watch(productFormProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          clearFormAndControllers();
        }
      },
      canPop: true,
      child: ScalingFactor(
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              clearFormAndControllers();
            }
          },
          child: Scaffold(
            appBar: reusableAppBar(
              title: 'Add Product',
              context: context,
              showBackButton: true,
              onBackPressed: () {
                clearFormAndControllers();
                Navigator.of(context).pop();
              },
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ReusablePadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                child: ReusableColumn(
                  children: <Widget>[
                    AddProductTopSection(controllers: controllers),
                    const ReusableSizedBox(height: 15),
                    PurchaseSectionAddProduct(controllers: controllers),
                    const ReusableSizedBox(height: 15),
                    if (product.purchaseType != 'Expense')
                      SalesInformationAddProducts(controllers: controllers),
                    const ReusableSizedBox(height: 15),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: PayzoFormSubmitTwoButtons(
                safeArea: true,
                cancelText: 'Clear',
                saveText: 'Save',
                cancelOnPressed: clearFormAndControllers,
                saveOnPressed: () async {
                  // Validate
                  notifier.validateFields();
                  // Give time for state to update
                  await Future.delayed(const Duration(milliseconds: 50));

                  final state = ref.read(productFormProvider);

                  print('🟡 Final State: ${state.toJson()}');

                  if (state.errors?.isEmpty ?? true) {
                    showPayzoProgress(context: context);
                    try {
                      final response =
                          await ref.read(addProductRepoProvider).addProduct();

                      if (response.error == false) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Success"),
                            content: Text(
                                "Product added successfully.\nTransaction ID: ${response.transactionId}"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  notifier.clearForm();
                                  Navigator.pop(context);
                                  ref.invalidate(getProductDataWithPagination);
                                  // await Future.delayed(
                                  //     Duration(milliseconds: 50));
                                  ref
                                          .read(bottomNavBarProvider.notifier)
                                          .state =
                                      1; // 🔄 set to Vendor/Product index
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
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Error"),
                            content: Text(response.errorMsg?.toString() ??
                                "Unknown error"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e, stack) {
                      debugPrint("❌ Exception during product submission: $e");
                      debugPrint("📦 Stacktrace: $stack");
                      Navigator.pop(context);
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
                    debugPrint("🛑 Errors present: ${state.errors}");
                  }
                }),
          ),
        ),
      ),
    );
  }
}
