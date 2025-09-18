// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/view/bill_detail_page/components/bill_product_details.dart';
// import 'package:payzo_books/view/expense_detail_page/components/expense_detail_error_widget.dart';
// import 'package:payzo_books/view/expense_detail_page/provider/expense_detail_provider.dart';
// import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
// import 'package:payzo_books/view/expenses/widgets/details/expense_detail_error_widget.dart';
// import 'package:payzo_books/view/notification_details/components/other_widgts.dart';
// import 'package:payzo_books/view/expense_detail_page/components/expense_product_details.dart';
//
// class ExpenseDetailProductData extends ConsumerStatefulWidget {
//   final int? expenseId;
//   const ExpenseDetailProductData({required this.expenseId, super.key});
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ExpenseDetailProductDataState();
// }
//
// class _ExpenseDetailProductDataState
//     extends ConsumerState<ExpenseDetailProductData> {
//   @override
//   Widget build(BuildContext context) {
//     final effectiveExpenseId = widget.expenseId ?? 1;
//     final expenseDetailsAsync =
//     ref.watch(getExpenseDetailsProvider(effectiveExpenseId));
//
//     return expenseDetailsAsync.when(
//       data: (expenseDetail) {
//         final details = expenseDetail.response!;
//         final productWidgets = details.productDetails.map((product) {
//           return billProductDetails(
//             productName: product.productName ?? "N/A",
//             billCustomerName: product.customerName ?? 'N/A',
//             productDisc: product.productDesc ?? "N/A",
//             quantity: product.quantity?.toString() ?? "0",
//             productUnit: product.productUnit ?? "Unit",
//             unitPrice: product.unitPrice?.toString() ?? "0.0",
//             discountAmnt: product.discountAmount?.toString() ?? "0.0",
//             discountPercentage:
//             formatPercentage(product.discountPercentage ?? 0),
//             taxType: product.taxType ?? "N/A",
//             productTotal: formatCurrency(
//                 product.productTotal ?? 0, details.currency ?? ''),
//             taxAmount: formatCurrency(
//                 product.totalTaxAmount ?? 0, details.currency ?? ''),
//             productData: product,
//             taxDisc: product.taxDesc ?? "Standard Tax",
//           );
//         }).toList();
//
//         return Column(children: productWidgets);
//       },
//       loading: () => const Center(
//         child: CircularProgressIndicator(color: AppColors.appMainColor),
//       ),
//       error: (e, stackTrace) => expenseErrorWidget(
//         error: e.toString(),
//         onRetry: () =>
//             ref.refresh(getExpenseDetailsProvider(effectiveExpenseId)),
//       ),
//     );
//   }
// }
