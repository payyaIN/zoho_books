class BillDetailModel {
  final String billCreatedBy;
  final String billPaymentTerm;
  final int billCurrencyId;
  final int billCompanyId;
  final int? billTrnxId;
  final List<ProductDetail> productDetails;
  final String billTermsCondition;
  final double billAmount;
  final double billTotalAmount;
  final String billVenderName;
  final String billShippingType;
  final int billStatus;
  final String billCustomerNotes;
  final int billShippingTypeId;
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
  final String billOrderNumber;
  final DateTime billDueDate;
  final int billVenderId;
  final BillAction billAction;

  BillDetailModel({
    required this.billCreatedBy,
    required this.billPaymentTerm,
    required this.billCurrencyId,
    required this.billCompanyId,
    this.billTrnxId,
    required this.productDetails,
    required this.billTermsCondition,
    required this.billAmount,
    required this.billTotalAmount,
    required this.billVenderName,
    required this.billShippingType,
    required this.billStatus,
    required this.billCustomerNotes,
    required this.billShippingTypeId,
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
    required this.billOrderNumber,
    required this.billDueDate,
    required this.billVenderId,
    required this.billAction,
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
        billShippingType: "",
        billStatus: 0,
        billCustomerNotes: "",
        billShippingTypeId: 0,
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
      );

  factory BillDetailModel.fromMap(Map<String, dynamic> json) {
    print(
        'BillDetailModel.fromMap - Processing bill with ID: ${json["billId"]}');

    List<dynamic> productDetailsList = [];

    if (json.containsKey("productDetails")) {
      if (json["productDetails"] is List) {
        productDetailsList = json["productDetails"] as List;
        print(
            'Found ${productDetailsList.length} product details for bill ID: ${json["billId"]}');
      } else {
        print('Warning: "productDetails" is not a List');
      }
    } else {
      print('Warning: No "productDetails" key found');
    }

    return BillDetailModel(
      billCreatedBy: json["billCreatedBy"] ?? "",
      billPaymentTerm: json["billPaymentTerm"] ?? "",
      billCurrencyId: json["billCurrencyId"] ?? 0,
      billCompanyId: json["billCompanyId"] ?? 0,
      billTrnxId: json["billTrnxId"],
      productDetails: List<ProductDetail>.from(productDetailsList.map((x) {
        if (x is Map) {
          return ProductDetail.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Product detail item is not a Map');
          return ProductDetail.empty();
        }
      })),
      billTermsCondition: json["billTermsCondition"] ?? "",
      billAmount: _parseDouble(json["billAmount"]),
      billTotalAmount: _parseDouble(json["billTotalAmount"]),
      billVenderName: json["billVenderName"] ?? "",
      billShippingType: json["billShippingType"] ?? "",
      billStatus: json["billStatus"] ?? 0,
      billCustomerNotes: json["billCustomerNotes"] ?? "",
      billShippingTypeId: json["billShippingTypeId"] ?? 0,
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
      billOrderNumber: json["billOrderNumber"] ?? "",
      billDueDate: json["billDueDate"] != null
          ? DateTime.parse(json["billDueDate"])
          : DateTime.now(),
      billVenderId: json["billVenderId"] ?? 0,
      billAction: json["billAction"] != null && json["billAction"] is Map
          ? BillAction.fromMap(Map<String, dynamic>.from(json["billAction"]))
          : BillAction.empty(),
    );
  }
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
      accountId: json["accountId"],
      prodTax: json["prodTax"],
      totalTaxAmount: _parseDouble(json["totalTaxAmount"]),
      taxType: json["taxType"],
      prodTaxExmpReason: json["prodTaxExmpReason"],
    );
  }
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
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (_) {
      return 0.0;
    }
  }
  return 0.0;
}
