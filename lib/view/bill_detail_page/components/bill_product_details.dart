import 'package:payzo_books/import_data.dart';

Container billProductDetails(
    {required String productName,
    required String billCustomerName,
    required String productDisc,
    required String quantity,
    required String productUnit,
    required String unitPrice,
    required String discountAmnt,
    required String discountPercentage,
    required String taxType,
    required String productTotal,
    required String taxAmount,
    dynamic productData,
    required String taxDisc}) {
  return Container(
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
                productName ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.appMainColor,
                ),
              ),
            ),
            Text(
              "For: $billCustomerName",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        // GapSpace.height8,
        // Text(
        //   productDisc ?? '',
        //   style: TextStyle(
        //     fontSize: 14,
        //     color: Colors.grey.shade700,
        //   ),
        // ),
        // productDisc != null
        //             ? SizedBox()
        //             : GapSpace.height8,
        Text(
          productDisc ?? '',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        productDisc != null ? SizedBox() : GapSpace.height15,

        Divider(height: 1, thickness: 0.5),
        GapSpace.height15,
        Row(
          children: [
            Expanded(
              child: Column(
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
                        quantity,
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
                        productUnit,
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
                        unitPrice,
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
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        discountAmnt,
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
                        discountPercentage,
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
                      Expanded(
                        child: Text(
                          taxType,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.loginTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                  productTotal,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.loginTextColor,
                  ),
                ),
                GapSpace.height8,
                Text(
                  taxAmount,
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
        if (productData.taxDesc != null) ...[
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
            taxDisc,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.loginTextColor,
            ),
          ),
        ],
      ],
    ),
  );
}
