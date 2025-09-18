import 'dart:io';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';

class InvoiceFormModel {
  final String? customerName;
  final int? customerId; // ✅ Needed in DTO
  final String? branch;
  final int? branchId; // ✅ Needed in DTO
  final String? invoiceRefNo;
  final String? orderNo;
  final DateTime? invoiceDate;
  final DateTime? expiryDate;
  final DateTime? supplyDate;
  final String? shippingMethod;
  final int? shippingMethodId; // ✅ Needed in DTO
  final String? bankAccount;
  final int? bankAccountId; // ✅ Needed in DTO
  final String? currency;
  final int? currencyId; // ✅ Needed in DTO
  final String? paymentTerms;
  final String? companyCR;
  final String? customerNotes;
  final String? terms;
  final String? account;
  final int? quantity;
  final double? amount;
  final String? unitType;
  final int? unitId; // ✅ Needed in DTO
  final DateTime? rateDate;
  final DateTime? taxDate;
  final DateTime? customerDate;
  final int? orgId; // ✅ Needed in DTO
  final bool? advance; // ✅ Needed in DTO
  final bool? delivery; // ✅ Needed in DTO
  final String? invoiceNumber; // ✅ For display if needed
  final File? attachment;
  final double? subTotal;
  final double? total;
  final double? tax;
  final List<ItemDetail> itemDetails;
  final Map<String, String?> errors;

  const InvoiceFormModel({
    this.customerName,
    this.customerId,
    this.branch,
    this.branchId,
    this.invoiceRefNo,
    this.orderNo,
    this.invoiceDate,
    this.expiryDate,
    this.supplyDate,
    this.shippingMethod,
    this.shippingMethodId,
    this.bankAccount,
    this.bankAccountId,
    this.currency,
    this.currencyId,
    this.paymentTerms,
    this.companyCR,
    this.customerNotes,
    this.terms,
    this.account,
    this.quantity,
    this.amount,
    this.unitType,
    this.unitId,
    this.rateDate,
    this.taxDate,
    this.customerDate,
    this.orgId,
    this.advance = false,
    this.delivery = false,
    this.invoiceNumber,
    this.attachment,
    this.subTotal,
    this.total,
    this.tax,
    this.itemDetails = const [],
    this.errors = const {},
  });

  InvoiceFormModel copyWith({
    String? customerName,
    int? customerId,
    String? branch,
    int? branchId,
    String? invoiceRefNo,
    String? orderNo,
    DateTime? invoiceDate,
    DateTime? expiryDate,
    DateTime? supplyDate,
    String? shippingMethod,
    int? shippingMethodId,
    String? bankAccount,
    int? bankAccountId,
    String? currency,
    int? currencyId,
    String? paymentTerms,
    String? companyCR,
    String? customerNotes,
    String? terms,
    String? account,
    int? quantity,
    double? amount,
    String? unitType,
    int? unitId,
    DateTime? rateDate,
    DateTime? taxDate,
    DateTime? customerDate,
    int? orgId,
    bool? advance,
    bool? delivery,
    String? invoiceNumber,
    File? attachment,
    double? subTotal,
    double? total,
    double? tax,
    List<ItemDetail>? itemDetails,
    Map<String, String?>? errors,
  }) {
    return InvoiceFormModel(
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      branch: branch ?? this.branch,
      branchId: branchId ?? this.branchId,
      invoiceRefNo: invoiceRefNo ?? this.invoiceRefNo,
      orderNo: orderNo ?? this.orderNo,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      expiryDate: expiryDate ?? this.expiryDate,
      supplyDate: supplyDate ?? this.supplyDate,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      shippingMethodId: shippingMethodId ?? this.shippingMethodId,
      bankAccount: bankAccount ?? this.bankAccount,
      bankAccountId: bankAccountId ?? this.bankAccountId,
      currency: currency ?? this.currency,
      currencyId: currencyId ?? this.currencyId,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      companyCR: companyCR ?? this.companyCR,
      customerNotes: customerNotes ?? this.customerNotes,
      terms: terms ?? this.terms,
      account: account ?? this.account,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      unitType: unitType ?? this.unitType,
      unitId: unitId ?? this.unitId,
      rateDate: rateDate ?? this.rateDate,
      taxDate: taxDate ?? this.taxDate,
      customerDate: customerDate ?? this.customerDate,
      orgId: orgId ?? this.orgId,
      advance: advance ?? this.advance,
      delivery: delivery ?? this.delivery,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      attachment: attachment ?? this.attachment,
      subTotal: subTotal ?? this.subTotal,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      itemDetails: itemDetails ?? this.itemDetails,
      errors: errors ?? this.errors,
    );
  }
}
