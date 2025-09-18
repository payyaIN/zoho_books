import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

Widget productDetailWidget(
    {required bool hasProducts,
    required List productDetails,
    required List billDetails,
    required String invoiceCustomerName,
    String? invoiceCurrency,
    String? billCurrency,
    required bool isBill}) {
  if (hasProducts) {
    return Column(
      children: [
        for (var product in isBill == true ? billDetails : productDetails) ...[
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.productName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.appMainColor,
                        ),
                      ),
                    ),
                    Text(
                      "For: ${invoiceCustomerName ?? 'N/A'}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                product.productDescription == null
                    ? SizedBox()
                    : GapSpace.height8,
                Text(
                  product.productDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                product.productDescription == null
                    ? SizedBox()
                    : GapSpace.height15,
                Divider(height: 1, thickness: 0.5),
                GapSpace.height15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Quantity: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              product.quantity.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.loginTextColor,
                              ),
                            ),
                          ],
                        ),
                        GapSpace.height8,
                        Row(
                          children: [
                            Text(
                              "Unit: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              isBill == true
                                  ? product.productUnit
                                  : product.unit,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.loginTextColor,
                              ),
                            ),
                          ],
                        ),
                        GapSpace.height8,
                        Row(
                          children: [
                            Text(
                              "Unit Price: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              // formatCurrency(product.unitPrice,
                              //     '${isBill == true ? billCurrency : invoiceCurrency}'),
                              product.unitPrice.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.loginTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Discount: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              // formatCurrency(product.discountAmount,
                              //     '${isBill == true ? billCurrency : invoiceCurrency}'),
                              product.discountAmount.toString(),

                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.loginTextColor,
                              ),
                            ),
                          ],
                        ),
                        GapSpace.height8,
                        Row(
                          children: [
                            Text(
                              "Disc %: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              formatPercentage(product.discountPercentage !=
                                      null
                                  ? parseDoubleFn(product.discountPercentage)
                                  : null),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.loginTextColor,
                              ),
                            ),
                          ],
                        ),
                        GapSpace.height8,
                        Row(
                          children: [
                            Text(
                              "Tax Type: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              product.taxType,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.loginTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                GapSpace.height15,
                Divider(height: 1, thickness: 0.5),
                GapSpace.height15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product Total:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GapSpace.height8,
                        Text(
                          "Tax Amount:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatCurrency(product.productTotal,
                              '${isBill == true ? billCurrency : invoiceCurrency}'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.loginTextColor,
                          ),
                        ),
                        GapSpace.height8,
                        Text(
                          product.totalTaxAmount.toString(),

                          // formatCurrency(product.totalTaxAmount,
                          //     '${isBill == true ? billCurrency : invoiceCurrency}'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.loginTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (product.taxDesc != null) ...[
                  GapSpace.height15,
                  Text(
                    "Tax Description:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  GapSpace.height4,
                  Text(
                    product.taxDesc ?? "Standard Tax",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.loginTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  } else {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "No product details available",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
