class InvoiceDetailModel {
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
  final List<InvoiceProductDetail> productDetails;
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
  final DateTime invoiceDate;
  final double invoiceTotalAmount;
  final int invoiceCurrencyId;
  final DateTime invoiceDueDate;
  final DateTime invoiceSupplyDate;
  final int invoiceTrnxId;
  final String invoicePaymentTerms;
  final bool isInvGenWithWf;
  final String invoiceCreatedBy;
  final int invoiceId;
  final int isInvoiceverified;
  final int invoiceStatus;
  final String invoiceTermsAndConditions;
  final dynamic invoiceRejectReason;

  InvoiceDetailModel({
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

  factory InvoiceDetailModel.empty() => InvoiceDetailModel(
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
        invoiceDate: DateTime.now(),
        invoiceTotalAmount: 0.0,
        invoiceCurrencyId: 0,
        invoiceDueDate: DateTime.now(),
        invoiceSupplyDate: DateTime.now(),
        invoiceTrnxId: 0,
        invoicePaymentTerms: "",
        isInvGenWithWf: false,
        invoiceCreatedBy: "",
        invoiceId: 0,
        isInvoiceverified: 0,
        invoiceStatus: 0,
        invoiceTermsAndConditions: "",
      );

  factory InvoiceDetailModel.fromMap(Map<String, dynamic> json) {
    print(
        'InvoiceDetailModel.fromMap - Processing invoice with ID: ${json["invoiceId"]}');

    List<dynamic> productDetailsList = [];

    if (json.containsKey("productDetails")) {
      if (json["productDetails"] is List) {
        productDetailsList = json["productDetails"] as List;
        print(
            'Found ${productDetailsList.length} product details for invoice ID: ${json["invoiceId"]}');
      } else {
        print('Warning: "productDetails" is not a List');
      }
    } else {
      print('Warning: No "productDetails" key found');
    }

    return InvoiceDetailModel(
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
      productDetails:
          List<InvoiceProductDetail>.from(productDetailsList.map((x) {
        if (x is Map) {
          return InvoiceProductDetail.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Product detail item is not a Map');
          return InvoiceProductDetail.empty();
        }
      })),
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
      invoiceAction:
          json["invoiceAction"] != null && json["invoiceAction"] is Map
              ? InvoiceAction.fromMap(
                  Map<String, dynamic>.from(json["invoiceAction"]))
              : InvoiceAction.empty(),
      invoiceBranchId: json["invoiceBranchId"] ?? 0,
      invoiceDate: json["invoiceDate"] != null
          ? DateTime.parse(json["invoiceDate"])
          : DateTime.now(),
      invoiceTotalAmount: _parseDouble(json["invoiceTotalAmount"]),
      invoiceCurrencyId: json["invoiceCurrencyId"] ?? 0,
      invoiceDueDate: json["invoiceDueDate"] != null
          ? DateTime.parse(json["invoiceDueDate"])
          : DateTime.now(),
      invoiceSupplyDate: json["invoiceSupplyDate"] != null
          ? DateTime.parse(json["invoiceSupplyDate"])
          : DateTime.now(),
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

  Map<String, dynamic> toMap() => {
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
        "invoiceDate": invoiceDate.toIso8601String(),
        "invoiceTotalAmount": invoiceTotalAmount,
        "invoiceCurrencyId": invoiceCurrencyId,
        "invoiceDueDate": invoiceDueDate.toIso8601String(),
        "invoiceSupplyDate": invoiceSupplyDate.toIso8601String(),
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

class InvoiceProductDetail {
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

  InvoiceProductDetail({
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

  factory InvoiceProductDetail.empty() => InvoiceProductDetail(
        invDetInvoiceId: 0,
        unitPrice: 0.0,
        quantity: 0,
        productId: 0,
        discountAmount: 0.0,
        productName: "",
        productTotal: 0.0,
        invDetId: 0,
        unit: "",
        othersAmount: 0.0,
        unitId: 0,
        prodTax: "",
        currency: "",
        totalTaxAmount: 0.0,
        productDescription: "",
        taxType: "",
      );

  factory InvoiceProductDetail.fromMap(Map<String, dynamic> json) {
    return InvoiceProductDetail(
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

  Map<String, dynamic> toMap() => {
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

  Map<String, dynamic> toMap() => {
        "invoiceId": invoiceId,
        "isCurrentUserReadyToApproveInvoice":
            isCurrentUserReadyToApproveInvoice,
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

// Helper function to safely parse double values
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
