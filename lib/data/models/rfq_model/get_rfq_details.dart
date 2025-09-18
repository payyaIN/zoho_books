class GetRfqDetails {
  GetRfqDetails({
      this.rfqDetails,});

  GetRfqDetails.fromJson(dynamic json) {
    rfqDetails = json['rfqDetails'] != null ? RfqDetails.fromJson(json['rfqDetails']) : null;
  }
  RfqDetails? rfqDetails;
GetRfqDetails copyWith({  RfqDetails? rfqDetails,
}) => GetRfqDetails(  rfqDetails: rfqDetails ?? this.rfqDetails,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (rfqDetails != null) {
      map['rfqDetails'] = rfqDetails?.toJson();
    }
    return map;
  }

}

class RfqDetails {
  RfqDetails({
      this.rfqTotalAmt, 
      this.rfqOrgId, 
      this.rfqDestination, 
      this.rfqDeliveryTerm, 
      this.isRfqRejected, 
      this.rfqStatus, 
      this.productDetails, 
      this.rfqId, 
      this.rfqCustomerNote, 
      this.rfqExpDate, 
      this.isRfqSubWithWf, 
      this.rfqCompanyId, 
      this.rfqName, 
      this.rfqVenderId, 
      this.rfqTermsCondition, 
      this.rfqCurrency, 
      this.rfqBranchId, 
      this.rfqDeliveryAdd, 
      this.rfqCurrencyId, 
      this.rfqCreatedBy, 
      this.rfqShippingMethod, 
      this.rfqType, 
      this.rfqRejectReason, 
      this.rfqCreatedDate, 
      this.rfqIsverified, 
      this.rfqAction, 
      this.rfqReference, 
      this.rfqSubmittedByName,});

  RfqDetails.fromJson(dynamic json) {
    rfqTotalAmt = json['rfqTotalAmt'];
    rfqOrgId = json['rfqOrgId'];
    rfqDestination = json['rfqDestination'];
    rfqDeliveryTerm = json['rfqDeliveryTerm'];
    isRfqRejected = json['isRfqRejected'];
    rfqStatus = json['rfqStatus'];
    if (json['productDetails'] != null) {
      productDetails = [];
      json['productDetails'].forEach((v) {
        productDetails?.add(ProductDetails.fromJson(v));
      });
    }
    rfqId = json['rfqId'];
    rfqCustomerNote = json['rfqCustomerNote'];
    rfqExpDate = json['rfqExpDate'];
    isRfqSubWithWf = json['isRfqSubWithWf'];
    rfqCompanyId = json['rfqCompanyId'];
    rfqName = json['rfqName'];
    rfqVenderId = json['rfqVenderId'];
    rfqTermsCondition = json['rfqTermsCondition'];
    rfqCurrency = json['rfqCurrency'];
    rfqBranchId = json['rfqBranchId'];
    rfqDeliveryAdd = json['rfqDeliveryAdd'];
    rfqCurrencyId = json['rfqCurrencyId'];
    rfqCreatedBy = json['rfqCreatedBy'];
    rfqShippingMethod = json['rfqShippingMethod'];
    rfqType = json['rfqType'];
    rfqRejectReason = json['rfqRejectReason'];
    rfqCreatedDate = json['rfqCreatedDate'];
    rfqIsverified = json['rfqIsverified'];
    rfqAction = json['rfqAction'] != null ? RfqAction.fromJson(json['rfqAction']) : null;
    rfqReference = json['rfqReference'];
    rfqSubmittedByName = json['rfqSubmittedByName'];
  }
  num? rfqTotalAmt;
  String? rfqOrgId;
  num? rfqDestination;
  num? rfqDeliveryTerm;
  bool? isRfqRejected;
  num? rfqStatus;
  List<ProductDetails>? productDetails;
  num? rfqId;
  String? rfqCustomerNote;
  String? rfqExpDate;
  bool? isRfqSubWithWf;
  String? rfqCompanyId;
  String? rfqName;
  num? rfqVenderId;
  String? rfqTermsCondition;
  String? rfqCurrency;
  num? rfqBranchId;
  num? rfqDeliveryAdd;
  num? rfqCurrencyId;
  String? rfqCreatedBy;
  num? rfqShippingMethod;
  num? rfqType;
  dynamic rfqRejectReason;
  String? rfqCreatedDate;
  num? rfqIsverified;
  RfqAction? rfqAction;
  String? rfqReference;
  String? rfqSubmittedByName;
RfqDetails copyWith({  num? rfqTotalAmt,
  String? rfqOrgId,
  num? rfqDestination,
  num? rfqDeliveryTerm,
  bool? isRfqRejected,
  num? rfqStatus,
  List<ProductDetails>? productDetails,
  num? rfqId,
  String? rfqCustomerNote,
  String? rfqExpDate,
  bool? isRfqSubWithWf,
  String? rfqCompanyId,
  String? rfqName,
  num? rfqVenderId,
  String? rfqTermsCondition,
  String? rfqCurrency,
  num? rfqBranchId,
  num? rfqDeliveryAdd,
  num? rfqCurrencyId,
  String? rfqCreatedBy,
  num? rfqShippingMethod,
  num? rfqType,
  dynamic rfqRejectReason,
  String? rfqCreatedDate,
  num? rfqIsverified,
  RfqAction? rfqAction,
  String? rfqReference,
  String? rfqSubmittedByName,
}) => RfqDetails(  rfqTotalAmt: rfqTotalAmt ?? this.rfqTotalAmt,
  rfqOrgId: rfqOrgId ?? this.rfqOrgId,
  rfqDestination: rfqDestination ?? this.rfqDestination,
  rfqDeliveryTerm: rfqDeliveryTerm ?? this.rfqDeliveryTerm,
  isRfqRejected: isRfqRejected ?? this.isRfqRejected,
  rfqStatus: rfqStatus ?? this.rfqStatus,
  productDetails: productDetails ?? this.productDetails,
  rfqId: rfqId ?? this.rfqId,
  rfqCustomerNote: rfqCustomerNote ?? this.rfqCustomerNote,
  rfqExpDate: rfqExpDate ?? this.rfqExpDate,
  isRfqSubWithWf: isRfqSubWithWf ?? this.isRfqSubWithWf,
  rfqCompanyId: rfqCompanyId ?? this.rfqCompanyId,
  rfqName: rfqName ?? this.rfqName,
  rfqVenderId: rfqVenderId ?? this.rfqVenderId,
  rfqTermsCondition: rfqTermsCondition ?? this.rfqTermsCondition,
  rfqCurrency: rfqCurrency ?? this.rfqCurrency,
  rfqBranchId: rfqBranchId ?? this.rfqBranchId,
  rfqDeliveryAdd: rfqDeliveryAdd ?? this.rfqDeliveryAdd,
  rfqCurrencyId: rfqCurrencyId ?? this.rfqCurrencyId,
  rfqCreatedBy: rfqCreatedBy ?? this.rfqCreatedBy,
  rfqShippingMethod: rfqShippingMethod ?? this.rfqShippingMethod,
  rfqType: rfqType ?? this.rfqType,
  rfqRejectReason: rfqRejectReason ?? this.rfqRejectReason,
  rfqCreatedDate: rfqCreatedDate ?? this.rfqCreatedDate,
  rfqIsverified: rfqIsverified ?? this.rfqIsverified,
  rfqAction: rfqAction ?? this.rfqAction,
  rfqReference: rfqReference ?? this.rfqReference,
  rfqSubmittedByName: rfqSubmittedByName ?? this.rfqSubmittedByName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rfqTotalAmt'] = rfqTotalAmt;
    map['rfqOrgId'] = rfqOrgId;
    map['rfqDestination'] = rfqDestination;
    map['rfqDeliveryTerm'] = rfqDeliveryTerm;
    map['isRfqRejected'] = isRfqRejected;
    map['rfqStatus'] = rfqStatus;
    if (productDetails != null) {
      map['productDetails'] = productDetails?.map((v) => v.toJson()).toList();
    }
    map['rfqId'] = rfqId;
    map['rfqCustomerNote'] = rfqCustomerNote;
    map['rfqExpDate'] = rfqExpDate;
    map['isRfqSubWithWf'] = isRfqSubWithWf;
    map['rfqCompanyId'] = rfqCompanyId;
    map['rfqName'] = rfqName;
    map['rfqVenderId'] = rfqVenderId;
    map['rfqTermsCondition'] = rfqTermsCondition;
    map['rfqCurrency'] = rfqCurrency;
    map['rfqBranchId'] = rfqBranchId;
    map['rfqDeliveryAdd'] = rfqDeliveryAdd;
    map['rfqCurrencyId'] = rfqCurrencyId;
    map['rfqCreatedBy'] = rfqCreatedBy;
    map['rfqShippingMethod'] = rfqShippingMethod;
    map['rfqType'] = rfqType;
    map['rfqRejectReason'] = rfqRejectReason;
    map['rfqCreatedDate'] = rfqCreatedDate;
    map['rfqIsverified'] = rfqIsverified;
    if (rfqAction != null) {
      map['rfqAction'] = rfqAction?.toJson();
    }
    map['rfqReference'] = rfqReference;
    map['rfqSubmittedByName'] = rfqSubmittedByName;
    return map;
  }

}

class RfqAction {
  RfqAction({
      this.rfqId, 
      this.isCurrentUserReadyToApproveRfq, 
      this.isRfqVerified, 
      this.currentUserHasPermissionToRfq, 
      this.currentUserHasPermissionToApproveRfq, 
      this.isWorkFlowExistsRfq,});

  RfqAction.fromJson(dynamic json) {
    rfqId = json['rfqId'];
    isCurrentUserReadyToApproveRfq = json['isCurrentUserReadyToApproveRfq'];
    isRfqVerified = json['isRfqVerified'];
    currentUserHasPermissionToRfq = json['currentUserHasPermissionToRfq'];
    currentUserHasPermissionToApproveRfq = json['currentUserHasPermissionToApproveRfq'];
    isWorkFlowExistsRfq = json['isWorkFlowExistsRfq'];
  }
  dynamic rfqId;
  bool? isCurrentUserReadyToApproveRfq;
  bool? isRfqVerified;
  bool? currentUserHasPermissionToRfq;
  bool? currentUserHasPermissionToApproveRfq;
  bool? isWorkFlowExistsRfq;
RfqAction copyWith({  dynamic rfqId,
  bool? isCurrentUserReadyToApproveRfq,
  bool? isRfqVerified,
  bool? currentUserHasPermissionToRfq,
  bool? currentUserHasPermissionToApproveRfq,
  bool? isWorkFlowExistsRfq,
}) => RfqAction(  rfqId: rfqId ?? this.rfqId,
  isCurrentUserReadyToApproveRfq: isCurrentUserReadyToApproveRfq ?? this.isCurrentUserReadyToApproveRfq,
  isRfqVerified: isRfqVerified ?? this.isRfqVerified,
  currentUserHasPermissionToRfq: currentUserHasPermissionToRfq ?? this.currentUserHasPermissionToRfq,
  currentUserHasPermissionToApproveRfq: currentUserHasPermissionToApproveRfq ?? this.currentUserHasPermissionToApproveRfq,
  isWorkFlowExistsRfq: isWorkFlowExistsRfq ?? this.isWorkFlowExistsRfq,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rfqId'] = rfqId;
    map['isCurrentUserReadyToApproveRfq'] = isCurrentUserReadyToApproveRfq;
    map['isRfqVerified'] = isRfqVerified;
    map['currentUserHasPermissionToRfq'] = currentUserHasPermissionToRfq;
    map['currentUserHasPermissionToApproveRfq'] = currentUserHasPermissionToApproveRfq;
    map['isWorkFlowExistsRfq'] = isWorkFlowExistsRfq;
    return map;
  }

}

class ProductDetails {
  ProductDetails({
      this.unitPrice, 
      this.productSpecJson, 
      this.quantity, 
      this.productId, 
      this.totalPrice, 
      this.productCurrency, 
      this.productUnit, 
      this.productName, 
      this.productDescription, 
      this.productUnitId,});

  ProductDetails.fromJson(dynamic json) {
    unitPrice = json['unitPrice'];
    productSpecJson = json['productSpecJson'];
    quantity = json['quantity'];
    productId = json['productId'];
    totalPrice = json['totalPrice'];
    productCurrency = json['productCurrency'];
    productUnit = json['productUnit'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    productUnitId = json['productUnitId'];
  }
  num? unitPrice;
  String? productSpecJson;
  num? quantity;
  num? productId;
  num? totalPrice;
  String? productCurrency;
  String? productUnit;
  String? productName;
  String? productDescription;
  num? productUnitId;
ProductDetails copyWith({  num? unitPrice,
  String? productSpecJson,
  num? quantity,
  num? productId,
  num? totalPrice,
  String? productCurrency,
  String? productUnit,
  String? productName,
  String? productDescription,
  num? productUnitId,
}) => ProductDetails(  unitPrice: unitPrice ?? this.unitPrice,
  productSpecJson: productSpecJson ?? this.productSpecJson,
  quantity: quantity ?? this.quantity,
  productId: productId ?? this.productId,
  totalPrice: totalPrice ?? this.totalPrice,
  productCurrency: productCurrency ?? this.productCurrency,
  productUnit: productUnit ?? this.productUnit,
  productName: productName ?? this.productName,
  productDescription: productDescription ?? this.productDescription,
  productUnitId: productUnitId ?? this.productUnitId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unitPrice'] = unitPrice;
    map['productSpecJson'] = productSpecJson;
    map['quantity'] = quantity;
    map['productId'] = productId;
    map['totalPrice'] = totalPrice;
    map['productCurrency'] = productCurrency;
    map['productUnit'] = productUnit;
    map['productName'] = productName;
    map['productDescription'] = productDescription;
    map['productUnitId'] = productUnitId;
    return map;
  }

}