import 'dart:io';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';

class AddBillFormModel {
  final String? vendor;
  final int? vendorId;
  final String? branch;
  final String? billRefNo;
  final String? orderNo;
  final DateTime? billDate;
  final DateTime? dueDate;
  final String? shippingMethod;
  final String? currency;
  final String? customerNotes;
  final String? terms;
  final String? paymentTerms;
  final List<ItemDetail> itemDetails;
  final double subTotal;
  final double tax;
  final double total;
  final File? attachment;
  final Map<String, String?> errors;

  // 🔽 Newly added fields
  final int? customerId;
  final int? orgId;
  final int? cmpCr;

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
    );
  }
}