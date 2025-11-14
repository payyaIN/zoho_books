// import 'package:payzo_books/data/models/product_model/product_list_model.dart';
// import 'package:payzo_books/data/repository/add_bills/get_unit_list_model.dart';
// import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
// import 'package:payzo_books/data/repository/products_api/product_list_api.dart';
// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/view/product_page/provider/product_selection.dart';

// import '../../data/repository/add_bills/get_price_currency_repository.dart';

// class ProductDetailPage extends ConsumerWidget {
//   const ProductDetailPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedProductId = ref.watch(selectedProductIdProvider);
//     final priceCurrency = ref.watch(fetchPriceCurrencyProvider);
//     final productDataAsync =
//         ref.watch(getProductByIdProvider(selectedProductId ?? 0));
//     final unitData = ref.watch(fetchUnitListProvider);

//     final TextEditingController itemNameController = TextEditingController();
//     final TextEditingController hsnCodeController = TextEditingController();
//     final TextEditingController sellingPriceController =
//         TextEditingController();
//     final TextEditingController salesDescriptionController =
//         TextEditingController();
//     final TextEditingController costPriceController = TextEditingController();
//     final TextEditingController purchaseDescriptionController =
//         TextEditingController();
//     final TextEditingController skuController = TextEditingController();
//     final TextEditingController exceptionReasonController =
//         TextEditingController();

//     return productDataAsync.when(
//       loading: () => ScalingFactor(
//         child: Scaffold(
//           appBar: reusableAppBar(
//               title: 'Product Detail', context: context, showBackButton: true),
//           body: Center(
//             child: CircularProgressIndicator(
//               color: AppColors.appMainColor,
//             ),
//           ),
//         ),
//       ),
//       error: (error, stackTrace) => ScalingFactor(
//         child: Scaffold(
//           appBar: reusableAppBar(
//               title: 'Product Detail', context: context, showBackButton: true),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, size: 48, color: Colors.red),
//                 SizedBox(height: 16),
//                 Text("Error loading product details",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () => ref
//                       .refresh(getProductByIdProvider(selectedProductId ?? 0)),
//                   child: Text("Retry"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       data: (selectedProduct) {
//         if (selectedProduct.itemId == 0) {
//           return ScalingFactor(
//             child: Scaffold(
//               appBar: reusableAppBar(
//                   title: 'Product Detail',
//                   context: context,
//                   showBackButton: true),
//               body: Center(
//                 child: Text("Product not found"),
//               ),
//             ),
//           );
//         }

//         itemNameController.text = selectedProduct.itemName;
//         hsnCodeController.text = selectedProduct.hsnOrSac;
//         sellingPriceController.text = selectedProduct.salesRate;
//         salesDescriptionController.text = selectedProduct.salesDescription;
//         costPriceController.text = selectedProduct.costRate;
//         purchaseDescriptionController.text = selectedProduct.costDescription;
//         skuController.text = selectedProduct.sku ?? '';
//         exceptionReasonController.text =
//             selectedProduct.taxExceptionReason ?? '';

//         return ScalingFactor(
//           child: Scaffold(
//             appBar: reusableAppBar(
//                 title: 'Product Detail',
//                 context: context,
//                 showBackButton: true),
//             body: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               padding:
//                   EdgeInsets.only(left: 22, right: 22, top: 22, bottom: 22),
//               child: ReusableColumn(children: [
//                 FormContainer(
//                   height: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         top: 0, left: 15, right: 15, bottom: 18),
//                     child: ReusableColumn(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ReusableSizedBox(height: 18),
//                         PayzoInputField(
//                             enabled: false,
//                             label: 'Item Name',
//                             controller: itemNameController),
//                         ReusableSizedBox(height: 8),
//                         Consumer(
//                           builder: (context, ref, _) {
//                             final unitData = ref.watch(fetchUnitListProvider);

//                             return unitData.when(
//                               data: (units) {
//                                 final matchedUnit = units.firstWhere(
//                                   (u) => u.unitId == selectedProduct.unitId,
//                                   orElse: () => Unit(
//                                       unitId: selectedProduct.unitId,
//                                       displayUnit: 'Unknown'),
//                                 );
//                                 return PayzoBottomsheetNavigator(
//                                   navigationButton: false,
//                                   title: matchedUnit.displayUnit,
//                                   onTap: () {},
//                                   trailing: '',
//                                 );
//                               },
//                               loading: () => PayzoBottomsheetNavigator(
//                                 navigationButton: false,
//                                 title: 'Loading...',
//                                 onTap: () {},
//                                 trailing: '',
//                               ),
//                               error: (_, __) => PayzoBottomsheetNavigator(
//                                 navigationButton: false,
//                                 title: 'Unit Error',
//                                 onTap: () {},
//                                 trailing: '',
//                               ),
//                             );
//                           },
//                         ),

//                         ExpansionToggleButtons(
//                           'Type',
//                           true,
//                           [
//                             FormRadioButton(
//                               value: 'goods',
//                               groupValue: selectedProduct.fixedAsset
//                                   ? 'Service'
//                                   : 'goods',
//                               title: 'Goods',
//                               onChanged: (_) {},
//                             ),
//                             SizedBox(height: 16),
//                             FormRadioButton(
//                               value: 'Service',
//                               groupValue: selectedProduct.fixedAsset
//                                   ? 'Service'
//                                   : 'goods',
//                               title: 'Service',
//                               onChanged: (_) {},
//                             ),
//                           ],
//                           (_) {},
//                         ),
//                         SizedBox(height: 8),
//                         PayzoDivider(),
//                         PayzoInputField(
//                             enabled: false,
//                             label: 'HS Code',
//                             controller: hsnCodeController),
//                         ReusableSizedBox(height: 8),
//                         // PayzoInputField(enabled: false, label: 'SKU', controller: skuController),
//                         // ReusableSizedBox(height: 8),
//                         // PayzoInputField(enabled: false, label: 'Tax Exception Reason', controller: exceptionReasonController),
//                         SizedBox(height: 8),
//                         CustomToggleTile(
//                             disableSwitch: true,
//                             title: 'Taxable',
//                             value: selectedProduct.taxable == 1,
//                             onChanged: (value) => false,
//                             divider: false)
//                       ],
//                     ),
//                   ),
//                 ),
//                 ReusableSizedBox(height: 15),
//                 FormContainer(
//                   height: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         top: 18, bottom: 18, left: 15, right: 15),
//                     child: ReusableColumn(children: [
//                       CustomToggleTile(
//                           disableSwitch: true,
//                           title: 'Sales Information',
//                           value: true,
//                           onChanged: (value) {},
//                           divider: true),
//                       PayzoInputField(
//                           prefixText: 'SAR ',
//                           isPrefixText: true,
//                           enabled: false,
//                           label: 'Sales Price',
//                           controller: sellingPriceController),
//                       ReusableSizedBox(height: 15),
//                       PayzoBottomsheetNavigator(
//                           navigationButton: false,
//                           isPayzoColor: true,
//                           title: 'Account',
//                           trailing: selectedProduct.salesAccountName,
//                           onTap: () {}),
//                       ReusableSizedBox(height: 15),
//                       CustomDescriptionField(
//                           enabled: false,
//                           title: 'Description',
//                           controller: salesDescriptionController)
//                     ]),
//                   ),
//                 ),
//                 ReusableSizedBox(height: 15),
//                 FormContainer(
//                   height: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         top: 18, bottom: 18, left: 15, right: 15),
//                     child: ReusableColumn(children: [
//                       CustomToggleTile(
//                           disableSwitch: true,
//                           title: 'Purchase Information',
//                           value: true,
//                           onChanged: (value) {},
//                           divider: true),
//                       PayzoInputField(
//                           prefixText: 'SAR ',
//                           isPrefixText: true,
//                           enabled: false,
//                           label: 'Purchase Rate',
//                           controller: costPriceController),
//                       ReusableSizedBox(height: 15),
//                       PayzoBottomsheetNavigator(
//                           navigationButton: false,
//                           isPayzoColor: true,
//                           title: 'Account',
//                           trailing: selectedProduct.costAccountName,
//                           onTap: () {}),
//                       ReusableSizedBox(height: 15),
//                       CustomDescriptionField(
//                           enabled: false,
//                           title: 'Description',
//                           controller: purchaseDescriptionController)
//                     ]),
//                   ),
//                 ),
//               ]),
//             ),
//             bottomNavigationBar: ReusableSizedBox(
//               height: 50,
//               width: double.infinity,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String getUnitName(int unitId) {
//     switch (unitId) {
//       case 1:
//         return 'Each';
//       case 2:
//         return 'Count';
//       case 4:
//         return 'Number';
//       case 8:
//         return 'Piece';
//       default:
//         return 'Unit';
//     }
//   }

//   String getTaxRate(int taxable) {
//     switch (taxable) {
//       case 1:
//         return 'GST18 [18%]';
//       case 2:
//         return 'GST12 [12%]';
//       case 3:
//         return 'GST5 [5%]';
//       default:
//         return 'No Tax';
//     }
//   }
// }

import 'package:payzo_books/data/models/product_model/product_list_model.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_model.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
import 'package:payzo_books/data/repository/products_api/product_list_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';
import '../../data/repository/add_bills/get_price_currency_repository.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProductId = ref.watch(selectedProductIdProvider);
    final priceCurrency = ref.watch(fetchPriceCurrencyProvider);
    final productDataAsync =
        ref.watch(getProductByIdProvider(selectedProductId ?? 0));
    final unitData = ref.watch(fetchUnitListProvider);

    final TextEditingController itemNameController = TextEditingController();
    final TextEditingController hsnCodeController = TextEditingController();
    final TextEditingController sellingPriceController =
        TextEditingController();
    final TextEditingController salesDescriptionController =
        TextEditingController();
    final TextEditingController costPriceController = TextEditingController();
    final TextEditingController purchaseDescriptionController =
        TextEditingController();
    final TextEditingController skuController = TextEditingController();
    final TextEditingController exceptionReasonController =
        TextEditingController();

    return productDataAsync.when(
      loading: () => ScalingFactor(
        child: Scaffold(
          appBar: reusableAppBar(
              title: 'Product Detail', context: context, showBackButton: true),
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.appMainColor,
            ),
          ),
        ),
      ),
      error: (error, stackTrace) => ScalingFactor(
        child: Scaffold(
          appBar: reusableAppBar(
              title: 'Product Detail', context: context, showBackButton: true),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text("Error loading product details",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref
                      .refresh(getProductByIdProvider(selectedProductId ?? 0)),
                  child: Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (selectedProduct) {
        if (selectedProduct.itemId == 0) {
          return ScalingFactor(
            child: Scaffold(
              appBar: reusableAppBar(
                  title: 'Product Detail',
                  context: context,
                  showBackButton: true),
              body: Center(
                child: Text("Product not found"),
              ),
            ),
          );
        }

        // ✅ FIXED: Convert double values to String for controllers
        itemNameController.text = selectedProduct.itemName;
        hsnCodeController.text = selectedProduct.hsnOrSac;

        // ✅ Option 1 (RECOMMENDED): Use formatted values from API if available
        sellingPriceController.text = selectedProduct.salesRateFormatted ??
            selectedProduct.salesRate.toStringAsFixed(2);

        salesDescriptionController.text = selectedProduct.salesDescription;

        // ✅ Option 1 (RECOMMENDED): Use formatted values from API if available
        costPriceController.text = selectedProduct.costRateFormatted ??
            selectedProduct.costRate.toStringAsFixed(2);

        purchaseDescriptionController.text = selectedProduct.costDescription;
        skuController.text = selectedProduct.sku?.toString() ?? '';
        exceptionReasonController.text =
            selectedProduct.taxExceptionReason?.toString() ?? '';

        return ScalingFactor(
          child: Scaffold(
            appBar: reusableAppBar(
                title: 'Product Detail',
                context: context,
                showBackButton: true),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding:
                  EdgeInsets.only(left: 22, right: 22, top: 22, bottom: 22),
              child: ReusableColumn(children: [
                FormContainer(
                  height: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 15, right: 15, bottom: 18),
                    child: ReusableColumn(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableSizedBox(height: 18),
                        PayzoInputField(
                            enabled: false,
                            label: 'Item Name',
                            controller: itemNameController),
                        ReusableSizedBox(height: 15),
                        PayzoInputField(
                            enabled: false,
                            label: 'HSN/SAC',
                            controller: hsnCodeController),
                        ReusableSizedBox(height: 15),
                        PayzoInputField(
                            enabled: false,
                            label: 'SKU',
                            controller: skuController),
                        ReusableSizedBox(height: 15),
                        PayzoBottomsheetNavigator(
                          showClearButton: false,
                            navigationButton: false,
                            isPayzoColor: true,
                            title: 'Unit',
                            trailing: getUnitName(selectedProduct.unitId),
                            onTap: () {}),
                      ],
                    ),
                  ),
                ),
                ReusableSizedBox(height: 15),
                FormContainer(
                  height: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 18, bottom: 18, left: 15, right: 15),
                    child: ReusableColumn(children: [
                      CustomToggleTile(
                          disableSwitch: true,
                          title: 'Sales Information',
                          value: true,
                          onChanged: (value) {},
                          divider: true),
                      PayzoInputField(
                          prefixText: 'SAR ',
                          isPrefixText: true,
                          enabled: false,
                          label: 'Sales Price',
                          controller: sellingPriceController),
                      ReusableSizedBox(height: 15),
                      PayzoBottomsheetNavigator(
                        showClearButton: false,
                          navigationButton: false,
                          isPayzoColor: true,
                          title: 'Account',
                          trailing: selectedProduct.salesAccountName,
                          onTap: () {}),
                      ReusableSizedBox(height: 15),
                      CustomDescriptionField(
                          enabled: false,
                          title: 'Description',
                          controller: salesDescriptionController)
                    ]),
                  ),
                ),
                ReusableSizedBox(height: 15),
                FormContainer(
                  height: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 18, bottom: 18, left: 15, right: 15),
                    child: ReusableColumn(children: [
                      CustomToggleTile(
                          disableSwitch: true,
                          title: 'Purchase Information',
                          value: true,
                          onChanged: (value) {},
                          divider: true),
                      PayzoInputField(
                          prefixText: 'SAR ',
                          isPrefixText: true,
                          enabled: false,
                          label: 'Purchase Rate',
                          controller: costPriceController),
                      ReusableSizedBox(height: 15),
                      PayzoBottomsheetNavigator(
                        showClearButton: false,
                          navigationButton: false,
                          isPayzoColor: true,
                          title: 'Account',
                          trailing: selectedProduct.costAccountName,
                          onTap: () {}),
                      ReusableSizedBox(height: 15),
                      CustomDescriptionField(
                          enabled: false,
                          title: 'Description',
                          controller: purchaseDescriptionController)
                    ]),
                  ),
                ),
              ]),
            ),
            bottomNavigationBar: ReusableSizedBox(
              height: 50,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }

  String getUnitName(int unitId) {
    switch (unitId) {
      case 1:
        return 'Each';
      case 2:
        return 'Count';
      case 4:
        return 'Number';
      case 8:
        return 'Piece';
      default:
        return 'Unit';
    }
  }

  String getTaxRate(int taxable) {
    switch (taxable) {
      case 1:
        return 'GST18 [18%]';
      case 2:
        return 'GST12 [12%]';
      case 3:
        return 'GST5 [5%]';
      default:
        return 'No Tax';
    }
  }
}
