class ProductDetailModel {
  final String invoiceOrganizationId;
  final int invoiceCustomerId;
  final String invoiceOrderNumber;
  final dynamic invoiceTransType;
  final dynamic invoiceSalesPerson;
  final bool isInvoiceRejected;
  final String invoiceCustomerNotes;
  final String invoiceCreatedByName;
  final String invoiceShippingType;
  final double invoiceAmount;
  final List<ProductDetailItem> productDetails;
  final String invoiceCurrency;
  final String invoiceCustomerName;
  final DateTime invoiceCreatedDate;
  final String invoiceNumber;
  final int invoiceBankAccId;
  final dynamic invoiceVendorId;
  final int invoiceShippingTypeId;
  final dynamic invoiceSubject;
  final String invoiceCompanyId;
  final String invoiceBankAcc;
  final InvoiceAction invoiceAction;
  final int invoiceBranchId;
  final String invoiceDate;
  final double invoiceTotalAmount;
  final int invoiceCurrencyId;
  final String invoiceDueDate;
  final String invoiceSupplyDate;
  final int invoiceTrnxId;
  final String invoicePaymentTerms;
  final bool isInvGenWithWf;
  final String invoiceCreatedBy;
  final int invoiceId;
  final int isInvoiceverified;
  final int invoiceStatus;
  final String invoiceTermsAndConditions;
  final dynamic invoiceRejectReason;

  ProductDetailModel({
    required this.invoiceOrganizationId,
    required this.invoiceCustomerId,
    required this.invoiceOrderNumber,
    this.invoiceTransType,
    this.invoiceSalesPerson,
    required this.isInvoiceRejected,
    required this.invoiceCustomerNotes,
    required this.invoiceCreatedByName,
    required this.invoiceShippingType,
    required this.invoiceAmount,
    required this.productDetails,
    required this.invoiceCurrency,
    required this.invoiceCustomerName,
    required this.invoiceCreatedDate,
    required this.invoiceNumber,
    required this.invoiceBankAccId,
    this.invoiceVendorId,
    required this.invoiceShippingTypeId,
    this.invoiceSubject,
    required this.invoiceCompanyId,
    required this.invoiceBankAcc,
    required this.invoiceAction,
    required this.invoiceBranchId,
    required this.invoiceDate,
    required this.invoiceTotalAmount,
    required this.invoiceCurrencyId,
    required this.invoiceDueDate,
    required this.invoiceSupplyDate,
    required this.invoiceTrnxId,
    required this.invoicePaymentTerms,
    required this.isInvGenWithWf,
    required this.invoiceCreatedBy,
    required this.invoiceId,
    required this.isInvoiceverified,
    required this.invoiceStatus,
    required this.invoiceTermsAndConditions,
    this.invoiceRejectReason,
  });

  factory ProductDetailModel.empty() => ProductDetailModel(
        invoiceOrganizationId: "",
        invoiceCustomerId: 0,
        invoiceOrderNumber: "",
        isInvoiceRejected: false,
        invoiceCustomerNotes: "",
        invoiceCreatedByName: "",
        invoiceShippingType: "",
        invoiceAmount: 0.0,
        productDetails: [],
        invoiceCurrency: "",
        invoiceCustomerName: "",
        invoiceCreatedDate: DateTime.now(),
        invoiceNumber: "",
        invoiceBankAccId: 0,
        invoiceShippingTypeId: 0,
        invoiceCompanyId: "",
        invoiceBankAcc: "",
        invoiceAction: InvoiceAction.empty(),
        invoiceBranchId: 0,
        invoiceDate: "",
        invoiceTotalAmount: 0.0,
        invoiceCurrencyId: 0,
        invoiceDueDate: "",
        invoiceSupplyDate: "",
        invoiceTrnxId: 0,
        invoicePaymentTerms: "",
        isInvGenWithWf: false,
        invoiceCreatedBy: "",
        invoiceId: 0,
        isInvoiceverified: 0,
        invoiceStatus: 0,
        invoiceTermsAndConditions: "",
      );

  factory ProductDetailModel.fromMap(Map<String, dynamic> json) {
    return ProductDetailModel(
      invoiceOrganizationId: json["invoiceOrganizationId"] ?? "",
      invoiceCustomerId: json["invoiceCustomerId"] ?? 0,
      invoiceOrderNumber: json["invoiceOrderNumber"] ?? "",
      invoiceTransType: json["invoiceTransType"],
      invoiceSalesPerson: json["invoiceSalesPerson"],
      isInvoiceRejected: json["isInvoiceRejected"] ?? false,
      invoiceCustomerNotes: json["invoiceCustomerNotes"] ?? "",
      invoiceCreatedByName: json["invoiceCreatedByName"] ?? "",
      invoiceShippingType: json["invoiceShippingType"] ?? "",
      invoiceAmount: _parseDouble(json["invoiceAmount"]),
      productDetails: json["productDetails"] != null
          ? List<ProductDetailItem>.from(
              json["productDetails"].map((x) => ProductDetailItem.fromMap(x)))
          : [],
      invoiceCurrency: json["invoiceCurrency"] ?? "",
      invoiceCustomerName: json["invoiceCustomerName"] ?? "",
      invoiceCreatedDate: json["invoiceCreatedDate"] != null
          ? DateTime.parse(json["invoiceCreatedDate"])
          : DateTime.now(),
      invoiceNumber: json["invoiceNumber"] ?? "",
      invoiceBankAccId: json["invoiceBankAccId"] ?? 0,
      invoiceVendorId: json["invoiceVendorId"],
      invoiceShippingTypeId: json["invoiceShippingTypeId"] ?? 0,
      invoiceSubject: json["invoiceSubject"],
      invoiceCompanyId: json["invoiceCompanyId"] ?? "",
      invoiceBankAcc: json["invoiceBankAcc"] ?? "",
      invoiceAction: json["invoiceAction"] != null
          ? InvoiceAction.fromMap(json["invoiceAction"])
          : InvoiceAction.empty(),
      invoiceBranchId: json["invoiceBranchId"] ?? 0,
      invoiceDate: json["invoiceDate"] ?? "",
      invoiceTotalAmount: _parseDouble(json["invoiceTotalAmount"]),
      invoiceCurrencyId: json["invoiceCurrencyId"] ?? 0,
      invoiceDueDate: json["invoiceDueDate"] ?? "",
      invoiceSupplyDate: json["invoiceSupplyDate"] ?? "",
      invoiceTrnxId: json["invoiceTrnxId"] ?? 0,
      invoicePaymentTerms: json["invoicePaymentTerms"] ?? "",
      isInvGenWithWf: json["isInvGenWithWf"] ?? false,
      invoiceCreatedBy: json["invoiceCreatedBy"] ?? "",
      invoiceId: json["invoiceId"] ?? 0,
      isInvoiceverified: json["isInvoiceverified"] ?? 0,
      invoiceStatus: json["invoiceStatus"] ?? 0,
      invoiceTermsAndConditions: json["invoiceTermsAndConditions"] ?? "",
      invoiceRejectReason: json["invoiceRejectReason"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "invoiceOrganizationId": invoiceOrganizationId,
      "invoiceCustomerId": invoiceCustomerId,
      "invoiceOrderNumber": invoiceOrderNumber,
      "invoiceTransType": invoiceTransType,
      "invoiceSalesPerson": invoiceSalesPerson,
      "isInvoiceRejected": isInvoiceRejected,
      "invoiceCustomerNotes": invoiceCustomerNotes,
      "invoiceCreatedByName": invoiceCreatedByName,
      "invoiceShippingType": invoiceShippingType,
      "invoiceAmount": invoiceAmount,
      "productDetails":
          List<dynamic>.from(productDetails.map((x) => x.toMap())),
      "invoiceCurrency": invoiceCurrency,
      "invoiceCustomerName": invoiceCustomerName,
      "invoiceCreatedDate": invoiceCreatedDate.toIso8601String(),
      "invoiceNumber": invoiceNumber,
      "invoiceBankAccId": invoiceBankAccId,
      "invoiceVendorId": invoiceVendorId,
      "invoiceShippingTypeId": invoiceShippingTypeId,
      "invoiceSubject": invoiceSubject,
      "invoiceCompanyId": invoiceCompanyId,
      "invoiceBankAcc": invoiceBankAcc,
      "invoiceAction": invoiceAction.toMap(),
      "invoiceBranchId": invoiceBranchId,
      "invoiceDate": invoiceDate,
      "invoiceTotalAmount": invoiceTotalAmount,
      "invoiceCurrencyId": invoiceCurrencyId,
      "invoiceDueDate": invoiceDueDate,
      "invoiceSupplyDate": invoiceSupplyDate,
      "invoiceTrnxId": invoiceTrnxId,
      "invoicePaymentTerms": invoicePaymentTerms,
      "isInvGenWithWf": isInvGenWithWf,
      "invoiceCreatedBy": invoiceCreatedBy,
      "invoiceId": invoiceId,
      "isInvoiceverified": isInvoiceverified,
      "invoiceStatus": invoiceStatus,
      "invoiceTermsAndConditions": invoiceTermsAndConditions,
      "invoiceRejectReason": invoiceRejectReason,
    };
  }
}

class ProductDetailItem {
  final int invDetInvoiceId;
  final double unitPrice;
  final int quantity;
  final int productId;
  final dynamic taxDesc;
  final double discountAmount;
  final String productName;
  final double productTotal;
  final int invDetId;
  final dynamic discountPercentage;
  final String unit;
  final dynamic productCategoryId;
  final dynamic othersDesc;
  final double othersAmount;
  final int unitId;
  final String prodTax;
  final String currency;
  final double totalTaxAmount;
  final String productDescription;
  final String taxType;
  final dynamic prodTaxExmpReason;

  ProductDetailItem({
    required this.invDetInvoiceId,
    required this.unitPrice,
    required this.quantity,
    required this.productId,
    this.taxDesc,
    required this.discountAmount,
    required this.productName,
    required this.productTotal,
    required this.invDetId,
    this.discountPercentage,
    required this.unit,
    this.productCategoryId,
    this.othersDesc,
    required this.othersAmount,
    required this.unitId,
    required this.prodTax,
    required this.currency,
    required this.totalTaxAmount,
    required this.productDescription,
    required this.taxType,
    this.prodTaxExmpReason,
  });

  factory ProductDetailItem.fromMap(Map<String, dynamic> json) {
    return ProductDetailItem(
      invDetInvoiceId: json["invDetInvoiceId"] ?? 0,
      unitPrice: _parseDouble(json["unitPrice"]),
      quantity: json["quantity"] ?? 0,
      productId: json["productId"] ?? 0,
      taxDesc: json["taxDesc"],
      discountAmount: _parseDouble(json["discountAmount"]),
      productName: json["productName"] ?? "",
      productTotal: _parseDouble(json["productTotal"]),
      invDetId: json["invDetId"] ?? 0,
      discountPercentage: json["discountPercentage"],
      unit: json["unit"] ?? "",
      productCategoryId: json["productCategoryId"],
      othersDesc: json["othersDesc"],
      othersAmount: _parseDouble(json["othersAmount"]),
      unitId: json["unitId"] ?? 0,
      prodTax: json["prodTax"] ?? "",
      currency: json["currency"] ?? "",
      totalTaxAmount: _parseDouble(json["totalTaxAmount"]),
      productDescription: json["productDescription"] ?? "",
      taxType: json["taxType"] ?? "",
      prodTaxExmpReason: json["prodTaxExmpReason"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "invDetInvoiceId": invDetInvoiceId,
      "unitPrice": unitPrice,
      "quantity": quantity,
      "productId": productId,
      "taxDesc": taxDesc,
      "discountAmount": discountAmount,
      "productName": productName,
      "productTotal": productTotal,
      "invDetId": invDetId,
      "discountPercentage": discountPercentage,
      "unit": unit,
      "productCategoryId": productCategoryId,
      "othersDesc": othersDesc,
      "othersAmount": othersAmount,
      "unitId": unitId,
      "prodTax": prodTax,
      "currency": currency,
      "totalTaxAmount": totalTaxAmount,
      "productDescription": productDescription,
      "taxType": taxType,
      "prodTaxExmpReason": prodTaxExmpReason,
    };
  }
}

class InvoiceAction {
  final dynamic invoiceId;
  final bool isCurrentUserReadyToApproveInvoice;
  final bool isInvoiceVerified;
  final bool currentUserHasPermissionToInvoice;
  final bool currentUserHasPermissionToApproveInvoice;
  final bool isWorkFlowExistsInvoice;
  final int invoiceStatus;
  final bool isInvoiceRejectedInApprovalPhase;
  final dynamic invoiceRejectedReason;

  InvoiceAction({
    this.invoiceId,
    required this.isCurrentUserReadyToApproveInvoice,
    required this.isInvoiceVerified,
    required this.currentUserHasPermissionToInvoice,
    required this.currentUserHasPermissionToApproveInvoice,
    required this.isWorkFlowExistsInvoice,
    required this.invoiceStatus,
    required this.isInvoiceRejectedInApprovalPhase,
    this.invoiceRejectedReason,
  });

  factory InvoiceAction.empty() => InvoiceAction(
        isCurrentUserReadyToApproveInvoice: false,
        isInvoiceVerified: false,
        currentUserHasPermissionToInvoice: false,
        currentUserHasPermissionToApproveInvoice: false,
        isWorkFlowExistsInvoice: false,
        invoiceStatus: 0,
        isInvoiceRejectedInApprovalPhase: false,
      );

  factory InvoiceAction.fromMap(Map<String, dynamic> json) {
    return InvoiceAction(
      invoiceId: json["invoiceId"],
      isCurrentUserReadyToApproveInvoice:
          json["isCurrentUserReadyToApproveInvoice"] ?? false,
      isInvoiceVerified: json["isInvoiceVerified"] ?? false,
      currentUserHasPermissionToInvoice:
          json["currentUserHasPermissionToInvoice"] ?? false,
      currentUserHasPermissionToApproveInvoice:
          json["currentUserHasPermissionToApproveInvoice"] ?? false,
      isWorkFlowExistsInvoice: json["isWorkFlowExistsInvoice"] ?? false,
      invoiceStatus: json["invoiceStatus"] ?? 0,
      isInvoiceRejectedInApprovalPhase:
          json["isInvoiceRejectedInApprovalPhase"] ?? false,
      invoiceRejectedReason: json["invoiceRejectedReason"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "invoiceId": invoiceId,
      "isCurrentUserReadyToApproveInvoice": isCurrentUserReadyToApproveInvoice,
      "isInvoiceVerified": isInvoiceVerified,
      "currentUserHasPermissionToInvoice": currentUserHasPermissionToInvoice,
      "currentUserHasPermissionToApproveInvoice":
          currentUserHasPermissionToApproveInvoice,
      "isWorkFlowExistsInvoice": isWorkFlowExistsInvoice,
      "invoiceStatus": invoiceStatus,
      "isInvoiceRejectedInApprovalPhase": isInvoiceRejectedInApprovalPhase,
      "invoiceRejectedReason": invoiceRejectedReason,
    };
  }
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
