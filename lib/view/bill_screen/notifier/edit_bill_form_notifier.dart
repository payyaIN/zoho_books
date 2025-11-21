import 'package:payzo_books/data/models/bill_model/bill_edit_details_model.dart';
import 'package:payzo_books/data/repository/bills_api/bill_actions_repository.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_billls/model/add_bill_form_model.dart';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';

class EditBillFormNotifier extends AddBillFormNotifier {
  final BillActionsRepository _repository;

  EditBillFormNotifier(this._repository) : super();

  void populate(BillEditDetailsModel details) {
    state = state.copyWith(
      billRefNo: details.billInvoiceNumber,
      orderNo: details.billOrderNumber,
      billDate: details.billDate,
      dueDate: details.billDueDate,
      currency: 'SAR', // Default
      customerNotes: details.billCustomerNotes,
      terms: details.billTermsCondition,
      paymentTerms: details.billPaymentTerms,
      subTotal: details.billAmount ?? 0.0,
      total: details.billTotalAmount ?? 0.0,
      customerId: details.billCustomerId,
      vendorId: details.billVendorId,
      branch: details.billBranchId?.toString(),
      discountType: details.billDiscountType,
      discountAmount: details.billDiscountAmount,
      discountPercentage: details.billDiscountPercentage,
      billType: details.billType,
      billAdvance: details.billAdvance,
      billDelivery: details.billDelivery,
      billStatus: details.billStatus,
      billInfo: details.billInfo,
      discountMethod: details.billDiscountMethod,
      isTaxInclusive: details.isTaxInclusive,
      isModalShown: details.isModalShown,
      itemDetails: details.billProductDetails.map((p) {
        return ItemDetail(
          itemName: p.billProdName,
          prodId: p.billProdId,
          prodCatId: p.billProdCatId,
          description: p.billProdDesc,
          account: p.billProdAccount,
          unitId: p.billProdUnitId,
          quantity: p.billProdQuantity,
          amount: p.billProdTotalAmount,
          rateDate: p.billProdUnitPrice?.toString(),
          discountAmount: p.billProdDiscountAmount,
          discountPercentage: p.billProdDiscountPercentage,
          taxAmount: p.billProdTaxAmount,
          taxType: p.billProdTax?.taxType,
        );
      }).toList(),
    );
  }

  Future<void> updateBill(int billId) async {
    validateForm();
    if (state.errors.isNotEmpty) {
      throw Exception('Validation failed');
    }

    final Map<String, dynamic> billDto = {
      "billId": billId,
      "billVendorId": state.vendorId,
      "billBranchId": state.branch,
      "billInvoiceNumber": state.billRefNo,
      "billOrderNumber": state.orderNo,
      "billDate": state.billDate?.toIso8601String(),
      "billDueDate": state.dueDate?.toIso8601String(),
      "billCurrencyId": 7,
      "billPaymentTerms": state.paymentTerms,
      "billCustomerNotes": state.customerNotes,
      "billTermsCondition": state.terms,
      "billAmount": state.subTotal,
      "billTotalAmount": state.total,
      "billDiscountAmount": state.discountAmount,
      "billDiscountMethod": state.discountMethod,
      "billDiscountPercentage": state.discountPercentage,
      "billDiscountType": state.discountType,
      "billStatus": state.billStatus,
      "billType": state.billType,
      "billAdvance": state.billAdvance,
      "billDelivery": state.billDelivery,
      "billInfo": state.billInfo,
      "isTaxInclusive": state.isTaxInclusive,
      "billProductDetails": state.itemDetails.map((item) {
        return {
          "billProdName": item.itemName,
          "billProdId": item.prodId,
          "billProdCatId": item.prodCatId,
          "billProdDesc": item.description,
          "billProdAccount": item.account,
          "billProdUnitPrice": double.tryParse(item.rateDate ?? '0'),
          "billProdQuantity": item.quantity,
          "billProdUnitId": item.unitId,
          "billProdTotalAmount": item.amount,
          "billProdDiscountAmount": item.discountAmount,
          "billProdDiscountPercentage": item.discountPercentage,
          "billProdTaxAmount": item.taxAmount,
        };
      }).toList(),
    };

    await _repository.updateBill(billDto, file: state.attachment);
  }
}

final editBillFormProvider =
    StateNotifierProvider<EditBillFormNotifier, AddBillFormModel>((ref) {
  final repo = ref.read(billActionsRepositoryProvider);
  return EditBillFormNotifier(repo);
});
