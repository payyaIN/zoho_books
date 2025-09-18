import 'package:payzo_books/import_data.dart';

import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_product_details.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

class BillDetailProductData extends ConsumerStatefulWidget {
  final int? billId;
  const BillDetailProductData({required this.billId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillDetailProductDataState();
}

class _BillDetailProductDataState extends ConsumerState<BillDetailProductData> {
  @override
  Widget build(BuildContext context) {
    final effectiveBillId = widget.billId ?? 1;
    final billDetailsAsync = ref.watch(getBillDetailsProvider(effectiveBillId));
    return billDetailsAsync.when(
        data: (billDetail) {
          final productWidgets = billDetail.productDetails.map((product) {
            return billProductDetails(
              productName: product.productName,
              billCustomerName: '${product.billCustomerName}' ?? 'N/A',
              productDisc: product.productDesc,
              quantity: product.quantity.toString(),
              productUnit: product.productUnit,
              unitPrice: product.unitPrice.toString(),
              discountAmnt: product.discountAmount.toString(),
              // formatCurrency(product.discountAmount, billDetail.billCurrency),
              discountPercentage: formatPercentage(product.discountPercentage),
              taxType: product.taxType ?? "N/A",
              productTotal:
                  formatCurrency(product.productTotal, billDetail.billCurrency),
              taxAmount: formatCurrency(
                  product.totalTaxAmount, billDetail.billCurrency),
              productData: product,
              taxDisc: product.taxDesc ?? "Standard Tax",
            );
          }).toList();
          return Column(children: productWidgets);
        },
        loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.appMainColor,
              ),
            ),
        error: (e, stackTrace) => billErrorWidget(
              error: e.toString(),
              onRetry: () =>
                  ref.refresh(getBillDetailsProvider(effectiveBillId)),
            ));
  }
}
