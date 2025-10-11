// class BillDetailModel {
//   final String billCreatedBy;
//   final String billPaymentTerm;
//   final int billCurrencyId;
//   final int billCompanyId;
//   final int? billTrnxId;
//   final List<ProductDetail> productDetails;
//   final String billTermsCondition;
//   final double billAmount;
//   final double billTotalAmount;
//   final String billVenderName;
//   final String billShippingType;
//   final int billStatus;
//   final String billCustomerNotes;
//   final int billShippingTypeId;
//   final String? billRejectReason;
//   final String billCreatedByName;
//   final String billInvoiceNumber;
//   final double billDiscountPercentage;
//   final DateTime billDate;
//   final DateTime billCreatedDate;
//   final bool isBillRejected;
//   final double billDiscountAmount;
//   final int billId;
//   final String billCurrency;
//   final bool isBillGenWithWf;
//   final int billBranchId;
//   final int isBillVerified;
//   final String billOrderNumber;
//   final DateTime billDueDate;
//   final int billVenderId;
//   final BillAction billAction;

//   BillDetailModel({
//     required this.billCreatedBy,
//     required this.billPaymentTerm,
//     required this.billCurrencyId,
//     required this.billCompanyId,
//     this.billTrnxId,
//     required this.productDetails,
//     required this.billTermsCondition,
//     required this.billAmount,
//     required this.billTotalAmount,
//     required this.billVenderName,
//     required this.billShippingType,
//     required this.billStatus,
//     required this.billCustomerNotes,
//     required this.billShippingTypeId,
//     this.billRejectReason,
//     required this.billCreatedByName,
//     required this.billInvoiceNumber,
//     required this.billDiscountPercentage,
//     required this.billDate,
//     required this.billCreatedDate,
//     required this.isBillRejected,
//     required this.billDiscountAmount,
//     required this.billId,
//     required this.billCurrency,
//     required this.isBillGenWithWf,
//     required this.billBranchId,
//     required this.isBillVerified,
//     required this.billOrderNumber,
//     required this.billDueDate,
//     required this.billVenderId,
//     required this.billAction,
//   });

//   factory BillDetailModel.empty() => BillDetailModel(
//         billCreatedBy: "",
//         billPaymentTerm: "",
//         billCurrencyId: 0,
//         billCompanyId: 0,
//         productDetails: [],
//         billTermsCondition: "",
//         billAmount: 0.0,
//         billTotalAmount: 0.0,
//         billVenderName: "",
//         billShippingType: "",
//         billStatus: 0,
//         billCustomerNotes: "",
//         billShippingTypeId: 0,
//         billCreatedByName: "",
//         billInvoiceNumber: "",
//         billDiscountPercentage: 0.0,
//         billDate: DateTime.now(),
//         billCreatedDate: DateTime.now(),
//         isBillRejected: false,
//         billDiscountAmount: 0.0,
//         billId: 0,
//         billCurrency: "",
//         isBillGenWithWf: false,
//         billBranchId: 0,
//         isBillVerified: 0,
//         billOrderNumber: "",
//         billDueDate: DateTime.now(),
//         billVenderId: 0,
//         billAction: BillAction.empty(),
//       );

//   factory BillDetailModel.fromMap(Map<String, dynamic> json) {
//     print(
//         'BillDetailModel.fromMap - Processing bill with ID: ${json["billId"]}');

//     List<dynamic> productDetailsList = [];

//     if (json.containsKey("productDetails")) {
//       if (json["productDetails"] is List) {
//         productDetailsList = json["productDetails"] as List;
//         print(
//             'Found ${productDetailsList.length} product details for bill ID: ${json["billId"]}');
//       } else {
//         print('Warning: "productDetails" is not a List');
//       }
//     } else {
//       print('Warning: No "productDetails" key found');
//     }

//     return BillDetailModel(
//       billCreatedBy: json["billCreatedBy"] ?? "",
//       billPaymentTerm: json["billPaymentTerm"] ?? "",
//       billCurrencyId: json["billCurrencyId"] ?? 0,
//       billCompanyId: json["billCompanyId"] ?? 0,
//       billTrnxId: json["billTrnxId"],
//       productDetails: List<ProductDetail>.from(productDetailsList.map((x) {
//         if (x is Map) {
//           return ProductDetail.fromMap(Map<String, dynamic>.from(x));
//         } else {
//           print('Warning: Product detail item is not a Map');
//           return ProductDetail.empty();
//         }
//       })),
//       billTermsCondition: json["billTermsCondition"] ?? "",
//       billAmount: _parseDouble(json["billAmount"]),
//       billTotalAmount: _parseDouble(json["billTotalAmount"]),
//       billVenderName: json["billVenderName"] ?? "",
//       billShippingType: json["billShippingType"] ?? "",
//       billStatus: json["billStatus"] ?? 0,
//       billCustomerNotes: json["billCustomerNotes"] ?? "",
//       billShippingTypeId: json["billShippingTypeId"] ?? 0,
//       billRejectReason: json["billRejectReason"],
//       billCreatedByName: json["billCreatedByName"] ?? "",
//       billInvoiceNumber: json["billInvoiceNumber"] ?? "",
//       billDiscountPercentage: _parseDouble(json["billDiscountPercentage"]),
//       billDate: json["billDate"] != null
//           ? DateTime.parse(json["billDate"])
//           : DateTime.now(),
//       billCreatedDate: json["billCreatedDate"] != null
//           ? DateTime.parse(json["billCreatedDate"])
//           : DateTime.now(),
//       isBillRejected: json["isBillRejected"] ?? false,
//       billDiscountAmount: _parseDouble(json["billDiscountAmount"]),
//       billId: json["billId"] ?? 0,
//       billCurrency: json["billCurrency"] ?? "",
//       isBillGenWithWf: json["isBillGenWithWf"] ?? false,
//       billBranchId: json["billBranchId"] ?? 0,
//       isBillVerified: json["isBillVerified"] ?? 0,
//       billOrderNumber: json["billOrderNumber"] ?? "",
//       billDueDate: json["billDueDate"] != null
//           ? DateTime.parse(json["billDueDate"])
//           : DateTime.now(),
//       billVenderId: json["billVenderId"] ?? 0,
//       billAction: json["billAction"] != null && json["billAction"] is Map
//           ? BillAction.fromMap(Map<String, dynamic>.from(json["billAction"]))
//           : BillAction.empty(),
//     );
//   }
// }

// class ProductDetail {
//   final double unitPrice;
//   final int billDetBillId;
//   final int quantity;
//   final int productId;
//   final int? billCustomerId;
//   final String? taxDesc;
//   final double discountAmount;
//   final String productUnit;
//   final String productName;
//   final double productTotal;
//   final int billDetId;
//   final String? billCustomerName;
//   final int productUnitId;
//   final String productDesc;
//   final double? discountPercentage;
//   final String? accountId;
//   final String? prodTax;
//   final double totalTaxAmount;
//   final String? taxType;
//   final String? prodTaxExmpReason;

//   ProductDetail({
//     required this.unitPrice,
//     required this.billDetBillId,
//     required this.quantity,
//     required this.productId,
//     this.billCustomerId,
//     this.taxDesc,
//     required this.discountAmount,
//     required this.productUnit,
//     required this.productName,
//     required this.productTotal,
//     required this.billDetId,
//     this.billCustomerName,
//     required this.productUnitId,
//     required this.productDesc,
//     this.discountPercentage,
//     this.accountId,
//     this.prodTax,
//     required this.totalTaxAmount,
//     this.taxType,
//     this.prodTaxExmpReason,
//   });

//   factory ProductDetail.empty() => ProductDetail(
//         unitPrice: 0.0,
//         billDetBillId: 0,
//         quantity: 0,
//         productId: 0,
//         discountAmount: 0.0,
//         productUnit: "",
//         productName: "",
//         productTotal: 0.0,
//         billDetId: 0,
//         productUnitId: 0,
//         productDesc: "",
//         totalTaxAmount: 0.0,
//       );

//   factory ProductDetail.fromMap(Map<String, dynamic> json) {
//     return ProductDetail(
//       unitPrice: _parseDouble(json["unitPrice"]),
//       billDetBillId: json["billDetBillId"] ?? 0,
//       quantity: json["quantity"] ?? 0,
//       productId: json["productId"] ?? 0,
//       billCustomerId: json["billCustomerId"],
//       taxDesc: json["taxDesc"],
//       discountAmount: _parseDouble(json["discountAmount"]),
//       productUnit: json["productUnit"] ?? "",
//       productName: json["productName"] ?? "",
//       productTotal: _parseDouble(json["productTotal"]),
//       billDetId: json["billDetId"] ?? 0,
//       billCustomerName: json["billCustomerName"],
//       productUnitId: json["productUnitId"] ?? 0,
//       productDesc: json["productDesc"] ?? "",
//       discountPercentage: json["discountPercentage"] != null
//           ? _parseDouble(json["discountPercentage"])
//           : null,
//       accountId: json["accountId"],
//       prodTax: json["prodTax"],
//       totalTaxAmount: _parseDouble(json["totalTaxAmount"]),
//       taxType: json["taxType"],
//       prodTaxExmpReason: json["prodTaxExmpReason"],
//     );
//   }
// }

// class BillAction {
//   final int? billId;
//   final bool isCurrentUserReadyToApproveBill;
//   final bool isBillVerified;
//   final bool currentUserHasPermissionToBill;
//   final bool currentUserHasPermissionToApproveBill;
//   final bool isWorkFlowExistsBill;
//   final int billStatus;
//   final bool isBillRejectedInApprovalPhase;
//   final String? billRejectedReason;

//   BillAction({
//     this.billId,
//     required this.isCurrentUserReadyToApproveBill,
//     required this.isBillVerified,
//     required this.currentUserHasPermissionToBill,
//     required this.currentUserHasPermissionToApproveBill,
//     required this.isWorkFlowExistsBill,
//     required this.billStatus,
//     required this.isBillRejectedInApprovalPhase,
//     this.billRejectedReason,
//   });

//   factory BillAction.empty() => BillAction(
//         isCurrentUserReadyToApproveBill: false,
//         isBillVerified: false,
//         currentUserHasPermissionToBill: false,
//         currentUserHasPermissionToApproveBill: false,
//         isWorkFlowExistsBill: false,
//         billStatus: 0,
//         isBillRejectedInApprovalPhase: false,
//       );

//   factory BillAction.fromMap(Map<String, dynamic> json) => BillAction(
//         billId: json["billId"],
//         isCurrentUserReadyToApproveBill:
//             json["isCurrentUserReadyToApproveBill"] ?? false,
//         isBillVerified: json["isBillVerified"] ?? false,
//         currentUserHasPermissionToBill:
//             json["currentUserHasPermissionToBill"] ?? false,
//         currentUserHasPermissionToApproveBill:
//             json["currentUserHasPermissionToApproveBill"] ?? false,
//         isWorkFlowExistsBill: json["isWorkFlowExistsBill"] ?? false,
//         billStatus: json["billStatus"] ?? 0,
//         isBillRejectedInApprovalPhase:
//             json["isBillRejectedInApprovalPhase"] ?? false,
//         billRejectedReason: json["billRejectedReason"],
//       );
// }

// double _parseDouble(dynamic value) {
//   if (value == null) return 0.0;
//   if (value is double) return value;
//   if (value is int) return value.toDouble();
//   if (value is String) {
//     try {
//       return double.parse(value);
//     } catch (_) {
//       return 0.0;
//     }
//   }
//   return 0.0;
// }

import 'package:flutter/foundation.dart';

// Helper function to parse double values
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? 0.0;
  }
  return 0.0;
}

class BillDetailModel {
  final String billCreatedBy;
  final String? billPaymentTerm;
  final int billCurrencyId;
  final int billCompanyId;
  final int? billTrnxId;
  final List<ProductDetail> productDetails;
  final String? billTermsCondition;
  final double billAmount;
  final double billTotalAmount;
  final String billVenderName;
  final int billStatus;
  final String? billCustomerNotes;
  final String? billRejectReason;
  final String billCreatedByName;
  final String billInvoiceNumber;
  final double billDiscountPercentage;
  final DateTime billDate;
  final DateTime billCreatedDate;
  final bool isBillRejected;
  final double billDiscountAmount;
  final int billId;
  final String billCurrency;
  final bool isBillGenWithWf;
  final int billBranchId;
  final int isBillVerified;
  final String? billOrderNumber;
  final DateTime billDueDate;
  final int billVenderId;
  final BillAction billAction;

  // New fields from API response
  final String billDiscountMethod;
  final String? billInfo;
  final String billDiscountType;
  final double billAmountDue;
  final double totalAmountToPay;
  final double totalPaidAmount;
  final double totalAdvanceApplied;
  final TaxData? taxData;
  final List<RecordPayment> recordPayments;
  final List<AdvancePayment> advancePaymentsApplied;
  final List<BillAttachment> billAttachments;

  // Formatted fields (optional - for display purposes)
  final String? billDiscountAmountFormatted;
  final String? billDiscountAmountFormattedCur;
  final String? totalPaidAmountFormatted;
  final String? totalPaidAmountFormattedCur;
  final String? totalAmountToPayFormatted;
  final String? totalAmountToPayFormattedCur;
  final String? totalAdvanceAppliedFormatted;
  final String? totalAdvanceAppliedFormattedCur;
  final String? totalAmountWithoutTaxFormatted;
  final String? totalAmountWithoutTaxFormattedCur;
  final String? billTotalAmountFormatted;
  final String? billTotalAmountFormattedCur;
  final String? billDiscountPercentageFormatted;
  final String? billDiscountPercentageFormattedCur;

  BillDetailModel({
    required this.billCreatedBy,
    this.billPaymentTerm,
    required this.billCurrencyId,
    required this.billCompanyId,
    this.billTrnxId,
    required this.productDetails,
    this.billTermsCondition,
    required this.billAmount,
    required this.billTotalAmount,
    required this.billVenderName,
    required this.billStatus,
    this.billCustomerNotes,
    this.billRejectReason,
    required this.billCreatedByName,
    required this.billInvoiceNumber,
    required this.billDiscountPercentage,
    required this.billDate,
    required this.billCreatedDate,
    required this.isBillRejected,
    required this.billDiscountAmount,
    required this.billId,
    required this.billCurrency,
    required this.isBillGenWithWf,
    required this.billBranchId,
    required this.isBillVerified,
    this.billOrderNumber,
    required this.billDueDate,
    required this.billVenderId,
    required this.billAction,
    required this.billDiscountMethod,
    this.billInfo,
    required this.billDiscountType,
    required this.billAmountDue,
    required this.totalAmountToPay,
    required this.totalPaidAmount,
    required this.totalAdvanceApplied,
    this.taxData,
    this.recordPayments = const [],
    this.advancePaymentsApplied = const [],
    this.billAttachments = const [],
    this.billDiscountAmountFormatted,
    this.billDiscountAmountFormattedCur,
    this.totalPaidAmountFormatted,
    this.totalPaidAmountFormattedCur,
    this.totalAmountToPayFormatted,
    this.totalAmountToPayFormattedCur,
    this.totalAdvanceAppliedFormatted,
    this.totalAdvanceAppliedFormattedCur,
    this.totalAmountWithoutTaxFormatted,
    this.totalAmountWithoutTaxFormattedCur,
    this.billTotalAmountFormatted,
    this.billTotalAmountFormattedCur,
    this.billDiscountPercentageFormatted,
    this.billDiscountPercentageFormattedCur,
  });

  factory BillDetailModel.empty() => BillDetailModel(
        billCreatedBy: "",
        billPaymentTerm: "",
        billCurrencyId: 0,
        billCompanyId: 0,
        productDetails: [],
        billTermsCondition: "",
        billAmount: 0.0,
        billTotalAmount: 0.0,
        billVenderName: "",
        billStatus: 0,
        billCustomerNotes: "",
        billCreatedByName: "",
        billInvoiceNumber: "",
        billDiscountPercentage: 0.0,
        billDate: DateTime.now(),
        billCreatedDate: DateTime.now(),
        isBillRejected: false,
        billDiscountAmount: 0.0,
        billId: 0,
        billCurrency: "",
        isBillGenWithWf: false,
        billBranchId: 0,
        isBillVerified: 0,
        billOrderNumber: "",
        billDueDate: DateTime.now(),
        billVenderId: 0,
        billAction: BillAction.empty(),
        billDiscountMethod: "NO_DISCOUNT",
        billDiscountType: "FIXED",
        billAmountDue: 0.0,
        totalAmountToPay: 0.0,
        totalPaidAmount: 0.0,
        totalAdvanceApplied: 0.0,
      );

  factory BillDetailModel.fromMap(Map<String, dynamic> json) {
    if (kDebugMode) {
      print(
          'BillDetailModel.fromMap - Processing bill with ID: ${json["billId"]}');
    }

    List<dynamic> productDetailsList = [];
    if (json.containsKey("productDetails")) {
      if (json["productDetails"] is List) {
        productDetailsList = json["productDetails"] as List;
        if (kDebugMode) {
          print(
              'Found ${productDetailsList.length} product details for bill ID: ${json["billId"]}');
        }
      } else {
        if (kDebugMode) {
          print('Warning: "productDetails" is not a List');
        }
      }
    } else {
      if (kDebugMode) {
        print('Warning: No "productDetails" key found');
      }
    }

    // Parse recordPayments
    List<RecordPayment> recordPayments = [];
    if (json["recordPayments"] != null && json["recordPayments"] is List) {
      recordPayments = (json["recordPayments"] as List)
          .map((x) => RecordPayment.fromMap(x))
          .toList();
    }

    // Parse advancePaymentsApplied
    List<AdvancePayment> advancePayments = [];
    if (json["advancePaymentsApplied"] != null &&
        json["advancePaymentsApplied"] is List) {
      advancePayments = (json["advancePaymentsApplied"] as List)
          .map((x) => AdvancePayment.fromMap(x))
          .toList();
    }

    // Parse billAttachments
    List<BillAttachment> attachments = [];
    if (json["billAttachments"] != null && json["billAttachments"] is List) {
      attachments = (json["billAttachments"] as List)
          .map((x) => BillAttachment.fromMap(x))
          .toList();
    }

    return BillDetailModel(
      billCreatedBy: json["billCreatedBy"] ?? "",
      billPaymentTerm: json["billPaymentTerm"],
      billCurrencyId: json["billCurrencyId"] ?? 0,
      billCompanyId: json["billCompanyId"] ?? 0,
      billTrnxId: json["billTrnxId"],
      productDetails: List<ProductDetail>.from(productDetailsList.map((x) {
        if (x is Map) {
          return ProductDetail.fromMap(Map<String, dynamic>.from(x));
        } else {
          if (kDebugMode) {
            print('Warning: Product detail item is not a Map');
          }
          return ProductDetail.empty();
        }
      })),
      billTermsCondition: json["billTermsCondition"],
      billAmount: _parseDouble(json["billAmount"]),
      billTotalAmount: _parseDouble(json["billTotalAmount"]),
      billVenderName: json["billVenderName"] ?? "",
      billStatus: json["billStatus"] ?? 0,
      billCustomerNotes: json["billCustomerNotes"],
      billRejectReason: json["billRejectReason"],
      billCreatedByName: json["billCreatedByName"] ?? "",
      billInvoiceNumber: json["billInvoiceNumber"] ?? "",
      billDiscountPercentage: _parseDouble(json["billDiscountPercentage"]),
      billDate: json["billDate"] != null
          ? DateTime.parse(json["billDate"])
          : DateTime.now(),
      billCreatedDate: json["billCreatedDate"] != null
          ? DateTime.parse(json["billCreatedDate"])
          : DateTime.now(),
      isBillRejected: json["isBillRejected"] ?? false,
      billDiscountAmount: _parseDouble(json["billDiscountAmount"]),
      billId: json["billId"] ?? 0,
      billCurrency: json["billCurrency"] ?? "",
      isBillGenWithWf: json["isBillGenWithWf"] ?? false,
      billBranchId: json["billBranchId"] ?? 0,
      isBillVerified: json["isBillVerified"] ?? 0,
      billOrderNumber: json["billOrderNumber"],
      billDueDate: json["billDueDate"] != null
          ? DateTime.parse(json["billDueDate"])
          : DateTime.now(),
      billVenderId: json["billVenderId"] ?? 0,
      billAction: json["billAction"] != null && json["billAction"] is Map
          ? BillAction.fromMap(Map<String, dynamic>.from(json["billAction"]))
          : BillAction.empty(),
      billDiscountMethod: json["billDiscountMethod"] ?? "NO_DISCOUNT",
      billInfo: json["billInfo"],
      billDiscountType: json["billDiscountType"] ?? "FIXED",
      billAmountDue: _parseDouble(json["billAmountDue"]),
      totalAmountToPay: _parseDouble(json["totalAmountToPay"]),
      totalPaidAmount: _parseDouble(json["totalPaidAmount"]),
      totalAdvanceApplied: _parseDouble(json["totalAdvanceApplied"]),
      taxData: json["taxData"] != null && json["taxData"] is Map
          ? TaxData.fromMap(Map<String, dynamic>.from(json["taxData"]))
          : null,
      recordPayments: recordPayments,
      advancePaymentsApplied: advancePayments,
      billAttachments: attachments,
      billDiscountAmountFormatted: json["billDiscountAmountFormatted"],
      billDiscountAmountFormattedCur: json["billDiscountAmountFormatted_cur"],
      totalPaidAmountFormatted: json["totalPaidAmountFormatted"],
      totalPaidAmountFormattedCur: json["totalPaidAmountFormatted_cur"],
      totalAmountToPayFormatted: json["totalAmountToPayFormatted"],
      totalAmountToPayFormattedCur: json["totalAmountToPayFormatted_cur"],
      totalAdvanceAppliedFormatted: json["totalAdvanceAppliedFormatted"],
      totalAdvanceAppliedFormattedCur: json["totalAdvanceAppliedFormatted_cur"],
      totalAmountWithoutTaxFormatted: json["totalAmountWithoutTaxFormatted"],
      totalAmountWithoutTaxFormattedCur:
          json["totalAmountWithoutTaxFormatted_cur"],
      billTotalAmountFormatted: json["billTotalAmountFormatted"],
      billTotalAmountFormattedCur: json["billTotalAmountFormatted_cur"],
      billDiscountPercentageFormatted: json["billDiscountPercentageFormatted"],
      billDiscountPercentageFormattedCur:
          json["billDiscountPercentageFormatted_cur"],
    );
  }

  Map<String, dynamic> toMap() => {
        "billCreatedBy": billCreatedBy,
        "billPaymentTerm": billPaymentTerm,
        "billCurrencyId": billCurrencyId,
        "billCompanyId": billCompanyId,
        "billTrnxId": billTrnxId,
        "productDetails":
            List<dynamic>.from(productDetails.map((x) => x.toMap())),
        "billTermsCondition": billTermsCondition,
        "billAmount": billAmount,
        "billTotalAmount": billTotalAmount,
        "billVenderName": billVenderName,
        "billStatus": billStatus,
        "billCustomerNotes": billCustomerNotes,
        "billRejectReason": billRejectReason,
        "billCreatedByName": billCreatedByName,
        "billInvoiceNumber": billInvoiceNumber,
        "billDiscountPercentage": billDiscountPercentage,
        "billDate": billDate.toIso8601String(),
        "billCreatedDate": billCreatedDate.toIso8601String(),
        "isBillRejected": isBillRejected,
        "billDiscountAmount": billDiscountAmount,
        "billId": billId,
        "billCurrency": billCurrency,
        "isBillGenWithWf": isBillGenWithWf,
        "billBranchId": billBranchId,
        "isBillVerified": isBillVerified,
        "billOrderNumber": billOrderNumber,
        "billDueDate": billDueDate.toIso8601String(),
        "billVenderId": billVenderId,
        "billAction": billAction.toMap(),
        "billDiscountMethod": billDiscountMethod,
        "billInfo": billInfo,
        "billDiscountType": billDiscountType,
        "billAmountDue": billAmountDue,
        "totalAmountToPay": totalAmountToPay,
        "totalPaidAmount": totalPaidAmount,
        "totalAdvanceApplied": totalAdvanceApplied,
        "taxData": taxData?.toMap(),
        "recordPayments":
            List<dynamic>.from(recordPayments.map((x) => x.toMap())),
        "advancePaymentsApplied":
            List<dynamic>.from(advancePaymentsApplied.map((x) => x.toMap())),
        "billAttachments":
            List<dynamic>.from(billAttachments.map((x) => x.toMap())),
      };
}

class ProductDetail {
  final double unitPrice;
  final int billDetBillId;
  final int quantity;
  final int productId;
  final int? billCustomerId;
  final String? taxDesc;
  final double discountAmount;
  final String productUnit;
  final String productName;
  final double productTotal;
  final int billDetId;
  final String? billCustomerName;
  final int productUnitId;
  final String productDesc;
  final double? discountPercentage;
  final String? accountId;
  final String? prodTax;
  final double totalTaxAmount;
  final String? taxType;
  final String? prodTaxExmpReason;

  // New formatted fields
  final String? discountAmountFormatted;
  final String? totalTaxAmountFormatted;
  final String? unitPriceFormatted;
  final String? discountPercentageFormatted;
  final String? billDetDiscountType;

  ProductDetail({
    required this.unitPrice,
    required this.billDetBillId,
    required this.quantity,
    required this.productId,
    this.billCustomerId,
    this.taxDesc,
    required this.discountAmount,
    required this.productUnit,
    required this.productName,
    required this.productTotal,
    required this.billDetId,
    this.billCustomerName,
    required this.productUnitId,
    required this.productDesc,
    this.discountPercentage,
    this.accountId,
    this.prodTax,
    required this.totalTaxAmount,
    this.taxType,
    this.prodTaxExmpReason,
    this.discountAmountFormatted,
    this.totalTaxAmountFormatted,
    this.unitPriceFormatted,
    this.discountPercentageFormatted,
    this.billDetDiscountType,
  });

  factory ProductDetail.empty() => ProductDetail(
        unitPrice: 0.0,
        billDetBillId: 0,
        quantity: 0,
        productId: 0,
        discountAmount: 0.0,
        productUnit: "",
        productName: "",
        productTotal: 0.0,
        billDetId: 0,
        productUnitId: 0,
        productDesc: "",
        totalTaxAmount: 0.0,
      );

  factory ProductDetail.fromMap(Map<String, dynamic> json) {
    return ProductDetail(
      unitPrice: _parseDouble(json["unitPrice"]),
      billDetBillId: json["billDetBillId"] ?? 0,
      quantity: json["quantity"] ?? 0,
      productId: json["productId"] ?? 0,
      billCustomerId: json["billCustomerId"],
      taxDesc: json["taxDesc"],
      discountAmount: _parseDouble(json["discountAmount"]),
      productUnit: json["productUnit"] ?? "",
      productName: json["productName"] ?? "",
      productTotal: _parseDouble(json["productTotal"]),
      billDetId: json["billDetId"] ?? 0,
      billCustomerName: json["billCustomerName"],
      productUnitId: json["productUnitId"] ?? 0,
      productDesc: json["productDesc"] ?? "",
      discountPercentage: json["discountPercentage"] != null
          ? _parseDouble(json["discountPercentage"])
          : null,
      accountId: json["accountId"]?.toString(),
      prodTax: json["prodTax"],
      totalTaxAmount: _parseDouble(json["totalTaxAmount"]),
      taxType: json["taxType"],
      prodTaxExmpReason: json["prodTaxExmpReason"],
      discountAmountFormatted: json["discountAmountFormatted"],
      totalTaxAmountFormatted: json["totalTaxAmountFormatted"],
      unitPriceFormatted: json["unitPriceFormatted"],
      discountPercentageFormatted: json["discountPercentageFormatted"],
      billDetDiscountType: json["billDetDiscountType"],
    );
  }

  Map<String, dynamic> toMap() => {
        "unitPrice": unitPrice,
        "billDetBillId": billDetBillId,
        "quantity": quantity,
        "productId": productId,
        "billCustomerId": billCustomerId,
        "taxDesc": taxDesc,
        "discountAmount": discountAmount,
        "productUnit": productUnit,
        "productName": productName,
        "productTotal": productTotal,
        "billDetId": billDetId,
        "billCustomerName": billCustomerName,
        "productUnitId": productUnitId,
        "productDesc": productDesc,
        "discountPercentage": discountPercentage,
        "accountId": accountId,
        "prodTax": prodTax,
        "totalTaxAmount": totalTaxAmount,
        "taxType": taxType,
        "prodTaxExmpReason": prodTaxExmpReason,
      };
}

class BillAction {
  final int? billId;
  final bool isCurrentUserReadyToApproveBill;
  final bool isBillVerified;
  final bool currentUserHasPermissionToBill;
  final bool currentUserHasPermissionToApproveBill;
  final bool isWorkFlowExistsBill;
  final int billStatus;
  final bool isBillRejectedInApprovalPhase;
  final String? billRejectedReason;

  BillAction({
    this.billId,
    required this.isCurrentUserReadyToApproveBill,
    required this.isBillVerified,
    required this.currentUserHasPermissionToBill,
    required this.currentUserHasPermissionToApproveBill,
    required this.isWorkFlowExistsBill,
    required this.billStatus,
    required this.isBillRejectedInApprovalPhase,
    this.billRejectedReason,
  });

  factory BillAction.empty() => BillAction(
        isCurrentUserReadyToApproveBill: false,
        isBillVerified: false,
        currentUserHasPermissionToBill: false,
        currentUserHasPermissionToApproveBill: false,
        isWorkFlowExistsBill: false,
        billStatus: 0,
        isBillRejectedInApprovalPhase: false,
      );

  factory BillAction.fromMap(Map<String, dynamic> json) => BillAction(
        billId: json["billId"],
        isCurrentUserReadyToApproveBill:
            json["isCurrentUserReadyToApproveBill"] ?? false,
        isBillVerified: json["isBillVerified"] ?? false,
        currentUserHasPermissionToBill:
            json["currentUserHasPermissionToBill"] ?? false,
        currentUserHasPermissionToApproveBill:
            json["currentUserHasPermissionToApproveBill"] ?? false,
        isWorkFlowExistsBill: json["isWorkFlowExistsBill"] ?? false,
        billStatus: json["billStatus"] ?? 0,
        isBillRejectedInApprovalPhase:
            json["isBillRejectedInApprovalPhase"] ?? false,
        billRejectedReason: json["billRejectedReason"],
      );

  Map<String, dynamic> toMap() => {
        "billId": billId,
        "isCurrentUserReadyToApproveBill": isCurrentUserReadyToApproveBill,
        "isBillVerified": isBillVerified,
        "currentUserHasPermissionToBill": currentUserHasPermissionToBill,
        "currentUserHasPermissionToApproveBill":
            currentUserHasPermissionToApproveBill,
        "isWorkFlowExistsBill": isWorkFlowExistsBill,
        "billStatus": billStatus,
        "isBillRejectedInApprovalPhase": isBillRejectedInApprovalPhase,
        "billRejectedReason": billRejectedReason,
      };
}

// New classes for additional data structures

class TaxData {
  final List<TaxDetail> taxDetailsData;
  final double totalTaxAmount;
  final String? totalTaxAmountFormatted;
  final String? totalTaxAmountFormattedCur;

  TaxData({
    required this.taxDetailsData,
    required this.totalTaxAmount,
    this.totalTaxAmountFormatted,
    this.totalTaxAmountFormattedCur,
  });

  factory TaxData.fromMap(Map<String, dynamic> json) => TaxData(
        taxDetailsData: json["taxDetailsData"] != null
            ? List<TaxDetail>.from(
                json["taxDetailsData"].map((x) => TaxDetail.fromMap(x)))
            : [],
        totalTaxAmount: _parseDouble(json["totalTaxAmount"]),
        totalTaxAmountFormatted: json["totalTaxAmountFormatted"],
        totalTaxAmountFormattedCur: json["totalTaxAmountFormatted_cur"],
      );

  Map<String, dynamic> toMap() => {
        "taxDetailsData":
            List<dynamic>.from(taxDetailsData.map((x) => x.toMap())),
        "totalTaxAmount": totalTaxAmount,
        "totalTaxAmountFormatted": totalTaxAmountFormatted,
        "totalTaxAmountFormatted_cur": totalTaxAmountFormattedCur,
      };
}

class TaxDetail {
  final double taxAmount;
  final String? taxGroupName;
  final String taxName;
  final double taxRate;
  final String? taxAmountToShowFormatted;
  final String? taxAmountToShowFormattedCur;
  final int taxId;
  final String taxCat;

  TaxDetail({
    required this.taxAmount,
    this.taxGroupName,
    required this.taxName,
    required this.taxRate,
    this.taxAmountToShowFormatted,
    this.taxAmountToShowFormattedCur,
    required this.taxId,
    required this.taxCat,
  });

  factory TaxDetail.fromMap(Map<String, dynamic> json) => TaxDetail(
        taxAmount: _parseDouble(json["TaxAmount"]),
        taxGroupName: json["TaxGroupName"],
        taxName: json["TaxName"] ?? "",
        taxRate: _parseDouble(json["TaxRate"]),
        taxAmountToShowFormatted: json["TaxAmountToShowFormatted"],
        taxAmountToShowFormattedCur: json["TaxAmountToShowFormatted_cur"],
        taxId: json["TaxId"] ?? 0,
        taxCat: json["TaxCat"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "TaxAmount": taxAmount,
        "TaxGroupName": taxGroupName,
        "TaxName": taxName,
        "TaxRate": taxRate,
        "TaxAmountToShowFormatted": taxAmountToShowFormatted,
        "TaxAmountToShowFormatted_cur": taxAmountToShowFormattedCur,
        "TaxId": taxId,
        "TaxCat": taxCat,
      };
}

class RecordPayment {
  final int? paymentId;
  final double? amount;
  final DateTime? paymentDate;
  final String? paymentMethod;
  final String? referenceNumber;

  RecordPayment({
    this.paymentId,
    this.amount,
    this.paymentDate,
    this.paymentMethod,
    this.referenceNumber,
  });

  factory RecordPayment.fromMap(Map<String, dynamic> json) => RecordPayment(
        paymentId: json["paymentId"],
        amount: _parseDouble(json["amount"]),
        paymentDate: json["paymentDate"] != null
            ? DateTime.parse(json["paymentDate"])
            : null,
        paymentMethod: json["paymentMethod"],
        referenceNumber: json["referenceNumber"],
      );

  Map<String, dynamic> toMap() => {
        "paymentId": paymentId,
        "amount": amount,
        "paymentDate": paymentDate?.toIso8601String(),
        "paymentMethod": paymentMethod,
        "referenceNumber": referenceNumber,
      };
}

class AdvancePayment {
  final int? advancePaymentId;
  final double? amount;
  final DateTime? appliedDate;

  AdvancePayment({
    this.advancePaymentId,
    this.amount,
    this.appliedDate,
  });

  factory AdvancePayment.fromMap(Map<String, dynamic> json) => AdvancePayment(
        advancePaymentId: json["advancePaymentId"],
        amount: _parseDouble(json["amount"]),
        appliedDate: json["appliedDate"] != null
            ? DateTime.parse(json["appliedDate"])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "advancePaymentId": advancePaymentId,
        "amount": amount,
        "appliedDate": appliedDate?.toIso8601String(),
      };
}

class BillAttachment {
  final int? attachmentId;
  final String? fileName;
  final String? fileUrl;
  final String? fileType;

  BillAttachment({
    this.attachmentId,
    this.fileName,
    this.fileUrl,
    this.fileType,
  });

  factory BillAttachment.fromMap(Map<String, dynamic> json) => BillAttachment(
        attachmentId: json["attachmentId"],
        fileName: json["fileName"],
        fileUrl: json["fileUrl"],
        fileType: json["fileType"],
      );

  Map<String, dynamic> toMap() => {
        "attachmentId": attachmentId,
        "fileName": fileName,
        "fileUrl": fileUrl,
        "fileType": fileType,
      };
}
