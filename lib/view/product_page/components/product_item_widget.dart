import 'package:payzo_books/data/models/product_model/product_list_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/components/product_uil.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';

Widget productItemWidget(
    {required ProductData product,
    required int index,
    required ProductSelectionState selectionState,
    required ProductSelectionNotifier selectionNotifier,
    required WidgetRef ref}) {
  String quantityDisplay = product.stockable ? "${product.costRate} pcs" : "";
  String rateDisplay = ProductUtil.formatCurrency(product.salesRate);

  return GestureDetector(
    onTap: () {
      if (selectionState.isSelectionMode) {
        selectionNotifier.toggleItemSelection(index);
      } else {
        ref.read(selectedProductIdProvider.notifier).state = product.itemId;
        Navigator.push(
          ref.context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(),
          ),
        );
      }
    },
    onLongPress: () {
      selectionNotifier.toggleSelectionMode();
      selectionNotifier.toggleItemSelection(index);
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        // color: AppColors.appMainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          if (selectionState.isSelectionMode)
            Checkbox(
              value: index < selectionState.selectedItems.length
                  ? selectionState.selectedItems[index]
                  : false,
              onChanged: (_) => selectionNotifier.toggleItemSelection(index),
              checkColor: AppColors.appWhiteColor,
              activeColor: AppColors.appMainColor,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: product.itemName,
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 3),
                          ReusableText(
                            text: product.costDescription,
                            color: Color(0xFF666666),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          product.hsnOrSac == null
                              ? ReusableText(
                                  text: "HS Code: ${product.hsnOrSac}",
                                  color: Color(0xFF333333),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                )
                              : ReusableText(
                                  text: "HS Code: -",
                                  color: Color(0xFF333333),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                          SizedBox(height: 3),
                          if (product.taxable == 1)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ReusableText(
                                text: "Taxable",
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: product.salesAccountName,
                            color: Color(0xFF333333),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              // ReusableText(
                              //   text:
                              //       "Type: ${ProductUtil.getUsageType(product.itemUsageType)}",
                              //   color: Color(0xFF555555),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              // ),
                              // SizedBox(width: 8),
                              if (quantityDisplay.isNotEmpty)
                                ReusableText(
                                  text: "Stock: $quantityDisplay",
                                  color: Color(0xFF555555),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ReusableText(
                          text: product.costAccountName,
                          color: Color(0xFF333333),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 5),
                        product.preferedVendor == 1
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ReusableText(
                                  text: "Preferred",
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Divider(height: 1, thickness: 0.5),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          text:
                              "Cost: ${ProductUtil.formatCurrency(product.costRate)}",
                          color: Color(0xFF555555),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 3),
                        ReusableText(
                          text: "Tax: ${product.taxable == 1 ? 'Yes' : 'No'}",
                          color: Color(0xFF555555),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    ReusableText(
                      text: rateDisplay,
                      color: Color(0xFF212121),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
