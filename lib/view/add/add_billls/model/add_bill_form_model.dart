// lib/view/add/add_billls/model/add_bill_form_model.dart

import 'dart:io';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';

/// Model for Add Bill form state.
/// Extended with fields required by the new backend payload.
class AddBillFormModel {
  // Basic selectors
  final String? vendor;
  final int? vendorId;
  final String? branch;

  // Identifiers / numbers
  final String? billRefNo; // maps to billInvoiceNumber
  final String? orderNo; // maps to billOrderNumber

  // Dates
  final DateTime? billDate;
  final DateTime? dueDate;

  // Other selectors
  final String? shippingMethod;
  final String? currency;

  // Notes / terms
  final String? customerNotes; // billCustomerNotes
  final String? terms; // billTermsCondition
  final String? paymentTerms; // billPaymentTerms

  // Line items
  final List<ItemDetail> itemDetails;

  // Calculations
  final double subTotal;
  final double tax;
  final double total;

  // Attachment
  final File? attachment;

  // Validation errors (fieldName -> message)
  final Map<String, String?> errors;

  // New / backend related fields
  final int? customerId; // billCustomerId
  final int? orgId; // billOrgId
  final int? cmpCr; // billCmpCr
  final int? paidThroughAccount; // billPaidThroughAcc

  // Discount / billing flags
  final String? discountType; // e.g. 'FIXED' / 'PERCENTAGE'
  final double? discountAmount;
  final double? discountPercentage;

  // Additional meta flags present in new payload
  final int? billType; // e.g. 1
  final bool? billAdvance;
  final bool? billDelivery;

  // Meta / info
  final int? isIncoming; // 0/1
  final int? billStatus;
  final String? billInfo;

  // Discount method & tax method
  final String? discountMethod; // 'LINE_ITEM_DISCOUNT' or 'GLOBAL'
  final String? taxMethod; // 'TAX_EXCLUSIVE' / 'TAX_INCLUSIVE'
  final bool? isTaxInclusive;

  const AddBillFormModel({
    this.vendor,
    this.vendorId,
    this.branch,
    this.billRefNo,
    this.orderNo,
    this.billDate,
    this.dueDate,
    this.shippingMethod,
    this.currency,
    this.customerNotes,
    this.terms,
    this.paymentTerms,
    this.itemDetails = const [],
    this.subTotal = 0.0,
    this.tax = 0.0,
    this.total = 0.0,
    this.attachment,
    this.errors = const {},
    this.customerId,
    this.orgId,
    this.cmpCr,
    this.paidThroughAccount,
    this.discountType,
    this.discountAmount,
    this.discountPercentage,
    this.billType,
    this.billAdvance,
    this.billDelivery,
    this.isIncoming,
    this.billStatus,
    this.billInfo,
    this.discountMethod,
    this.taxMethod,
    this.isTaxInclusive,
  });

  AddBillFormModel copyWith({
    String? vendor,
    int? vendorId,
    String? branch,
    String? billRefNo,
    String? orderNo,
    DateTime? billDate,
    DateTime? dueDate,
    String? shippingMethod,
    String? currency,
    String? customerNotes,
    String? terms,
    String? paymentTerms,
    List<ItemDetail>? itemDetails,
    double? subTotal,
    double? tax,
    double? total,
    File? attachment,
    Map<String, String?>? errors,
    int? customerId,
    int? orgId,
    int? cmpCr,
    int? paidThroughAccount,
    String? discountType,
    double? discountAmount,
    double? discountPercentage,
    int? billType,
    bool? billAdvance,
    bool? billDelivery,
    int? isIncoming,
    int? billStatus,
    String? billInfo,
    String? discountMethod,
    String? taxMethod,
    bool? isTaxInclusive,
  }) {
    return AddBillFormModel(
      vendor: vendor ?? this.vendor,
      vendorId: vendorId ?? this.vendorId,
      branch: branch ?? this.branch,
      billRefNo: billRefNo ?? this.billRefNo,
      orderNo: orderNo ?? this.orderNo,
      billDate: billDate ?? this.billDate,
      dueDate: dueDate ?? this.dueDate,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      currency: currency ?? this.currency,
      customerNotes: customerNotes ?? this.customerNotes,
      terms: terms ?? this.terms,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      itemDetails: itemDetails ?? this.itemDetails,
      subTotal: subTotal ?? this.subTotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      attachment: attachment ?? this.attachment,
      errors: errors ?? this.errors,
      customerId: customerId ?? this.customerId,
      orgId: orgId ?? this.orgId,
      cmpCr: cmpCr ?? this.cmpCr,
      paidThroughAccount: paidThroughAccount ?? this.paidThroughAccount,
      discountType: discountType ?? this.discountType,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      billType: billType ?? this.billType,
      billAdvance: billAdvance ?? this.billAdvance,
      billDelivery: billDelivery ?? this.billDelivery,
      isIncoming: isIncoming ?? this.isIncoming,
      billStatus: billStatus ?? this.billStatus,
      billInfo: billInfo ?? this.billInfo,
      discountMethod: discountMethod ?? this.discountMethod,
      taxMethod: taxMethod ?? this.taxMethod,
      isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
    );
  }
}
