class GetOrderDetailsModel {
  GetOrderDetailsModel({
      this.poVenderId, 
      this.poCurrency, 
      this.poShippingType, 
      this.poCmpId, 
      this.isPoSubWithWf, 
      this.poRevNum, 
      this.poProductTotal, 
      this.poAttachIsPresent, 
      this.productDetails, 
      this.poId, 
      this.poRejectReason, 
      this.poOrgId, 
      this.paymentScheduleType, 
      this.poBranchId, 
      this.paymentSchedule, 
      this.poNum, 
      this.poPostedDate, 
      this.poStatus, 
      this.poPostedBy, 
      this.poAdditionalDetails, 
      this.termsAndCondition, 
      this.poBusinessTerms, 
      this.paymentTerms, 
      this.poTypeId, 
      this.poOrderDate, 
      this.poShippingAddress, 
      this.poOrdCode, 
      this.poCurrencyId, 
      this.isPoRejected, 
      this.poProcessDays, 
      this.poPrefDetails, 
      this.orderAction, 
      this.poProductTotalWithTax, 
      this.companyId, 
      this.poName, 
      this.poSubmittedByName, 
      this.poIsVerified, 
      this.poReference,});

  GetOrderDetailsModel.fromJson(dynamic json) {
    poVenderId = json['poVenderId'];
    poCurrency = json['poCurrency'];
    poShippingType = json['poShippingType'];
    poCmpId = json['poCmpId'];
    isPoSubWithWf = json['isPoSubWithWf'];
    poRevNum = json['poRevNum'];
    poProductTotal = json['poProductTotal'];
    poAttachIsPresent = json['poAttachIsPresent'];
    if (json['productDetails'] != null) {
      productDetails = [];
      json['productDetails'].forEach((v) {
        productDetails?.add(ProductDetails.fromJson(v));
      });
    }
    poId = json['poId'];
    poRejectReason = json['poRejectReason'];
    poOrgId = json['poOrgId'];
    paymentScheduleType = json['paymentScheduleType'];
    poBranchId = json['poBranchId'];
    if (json['paymentSchedule'] != null) {
      paymentSchedule = [];
      json['paymentSchedule'].forEach((v) {
        paymentSchedule?.add(PaymentSchedule.fromJson(v));
      });
    }
    poNum = json['poNum'];
    poPostedDate = json['poPostedDate'];
    poStatus = json['poStatus'];
    poPostedBy = json['poPostedBy'];
    poAdditionalDetails = json['poAdditionalDetails'];
    termsAndCondition = json['termsAndCondition'];
    poBusinessTerms = json['poBusinessTerms'];
    paymentTerms = json['paymentTerms'];
    poTypeId = json['poTypeId'];
    poOrderDate = json['poOrderDate'];
    poShippingAddress = json['poShippingAddress'];
    poOrdCode = json['poOrdCode'];
    poCurrencyId = json['poCurrencyId'];
    isPoRejected = json['isPoRejected'];
    poProcessDays = json['poProcessDays'];
    poPrefDetails = json['poPrefDetails'];
    orderAction = json['orderAction'] != null ? OrderAction.fromJson(json['orderAction']) : null;
    poProductTotalWithTax = json['poProductTotalWithTax'];
    companyId = json['companyId'];
    poName = json['poName'];
    poSubmittedByName = json['poSubmittedByName'];
    poIsVerified = json['poIsVerified'];
    poReference = json['poReference'];
  }
  num? poVenderId;
  String? poCurrency;
  num? poShippingType;
  String? poCmpId;
  bool? isPoSubWithWf;
  num? poRevNum;
  num? poProductTotal;
  num? poAttachIsPresent;
  List<ProductDetails>? productDetails;
  num? poId;
  dynamic poRejectReason;
  String? poOrgId;
  num? paymentScheduleType;
  num? poBranchId;
  List<PaymentSchedule>? paymentSchedule;
  num? poNum;
  String? poPostedDate;
  num? poStatus;
  String? poPostedBy;
  String? poAdditionalDetails;
  String? termsAndCondition;
  num? poBusinessTerms;
  String? paymentTerms;
  num? poTypeId;
  String? poOrderDate;
  num? poShippingAddress;
  String? poOrdCode;
  num? poCurrencyId;
  bool? isPoRejected;
  num? poProcessDays;
  String? poPrefDetails;
  OrderAction? orderAction;
  num? poProductTotalWithTax;
  String? companyId;
  String? poName;
  String? poSubmittedByName;
  num? poIsVerified;
  String? poReference;
GetOrderDetailsModel copyWith({  num? poVenderId,
  String? poCurrency,
  num? poShippingType,
  String? poCmpId,
  bool? isPoSubWithWf,
  num? poRevNum,
  num? poProductTotal,
  num? poAttachIsPresent,
  List<ProductDetails>? productDetails,
  num? poId,
  dynamic poRejectReason,
  String? poOrgId,
  num? paymentScheduleType,
  num? poBranchId,
  List<PaymentSchedule>? paymentSchedule,
  num? poNum,
  String? poPostedDate,
  num? poStatus,
  String? poPostedBy,
  String? poAdditionalDetails,
  String? termsAndCondition,
  num? poBusinessTerms,
  String? paymentTerms,
  num? poTypeId,
  String? poOrderDate,
  num? poShippingAddress,
  String? poOrdCode,
  num? poCurrencyId,
  bool? isPoRejected,
  num? poProcessDays,
  String? poPrefDetails,
  OrderAction? orderAction,
  num? poProductTotalWithTax,
  String? companyId,
  String? poName,
  String? poSubmittedByName,
  num? poIsVerified,
  String? poReference,
}) => GetOrderDetailsModel(  poVenderId: poVenderId ?? this.poVenderId,
  poCurrency: poCurrency ?? this.poCurrency,
  poShippingType: poShippingType ?? this.poShippingType,
  poCmpId: poCmpId ?? this.poCmpId,
  isPoSubWithWf: isPoSubWithWf ?? this.isPoSubWithWf,
  poRevNum: poRevNum ?? this.poRevNum,
  poProductTotal: poProductTotal ?? this.poProductTotal,
  poAttachIsPresent: poAttachIsPresent ?? this.poAttachIsPresent,
  productDetails: productDetails ?? this.productDetails,
  poId: poId ?? this.poId,
  poRejectReason: poRejectReason ?? this.poRejectReason,
  poOrgId: poOrgId ?? this.poOrgId,
  paymentScheduleType: paymentScheduleType ?? this.paymentScheduleType,
  poBranchId: poBranchId ?? this.poBranchId,
  paymentSchedule: paymentSchedule ?? this.paymentSchedule,
  poNum: poNum ?? this.poNum,
  poPostedDate: poPostedDate ?? this.poPostedDate,
  poStatus: poStatus ?? this.poStatus,
  poPostedBy: poPostedBy ?? this.poPostedBy,
  poAdditionalDetails: poAdditionalDetails ?? this.poAdditionalDetails,
  termsAndCondition: termsAndCondition ?? this.termsAndCondition,
  poBusinessTerms: poBusinessTerms ?? this.poBusinessTerms,
  paymentTerms: paymentTerms ?? this.paymentTerms,
  poTypeId: poTypeId ?? this.poTypeId,
  poOrderDate: poOrderDate ?? this.poOrderDate,
  poShippingAddress: poShippingAddress ?? this.poShippingAddress,
  poOrdCode: poOrdCode ?? this.poOrdCode,
  poCurrencyId: poCurrencyId ?? this.poCurrencyId,
  isPoRejected: isPoRejected ?? this.isPoRejected,
  poProcessDays: poProcessDays ?? this.poProcessDays,
  poPrefDetails: poPrefDetails ?? this.poPrefDetails,
  orderAction: orderAction ?? this.orderAction,
  poProductTotalWithTax: poProductTotalWithTax ?? this.poProductTotalWithTax,
  companyId: companyId ?? this.companyId,
  poName: poName ?? this.poName,
  poSubmittedByName: poSubmittedByName ?? this.poSubmittedByName,
  poIsVerified: poIsVerified ?? this.poIsVerified,
  poReference: poReference ?? this.poReference,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['poVenderId'] = poVenderId;
    map['poCurrency'] = poCurrency;
    map['poShippingType'] = poShippingType;
    map['poCmpId'] = poCmpId;
    map['isPoSubWithWf'] = isPoSubWithWf;
    map['poRevNum'] = poRevNum;
    map['poProductTotal'] = poProductTotal;
    map['poAttachIsPresent'] = poAttachIsPresent;
    if (productDetails != null) {
      map['productDetails'] = productDetails?.map((v) => v.toJson()).toList();
    }
    map['poId'] = poId;
    map['poRejectReason'] = poRejectReason;
    map['poOrgId'] = poOrgId;
    map['paymentScheduleType'] = paymentScheduleType;
    map['poBranchId'] = poBranchId;
    if (paymentSchedule != null) {
      map['paymentSchedule'] = paymentSchedule?.map((v) => v.toJson()).toList();
    }
    map['poNum'] = poNum;
    map['poPostedDate'] = poPostedDate;
    map['poStatus'] = poStatus;
    map['poPostedBy'] = poPostedBy;
    map['poAdditionalDetails'] = poAdditionalDetails;
    map['termsAndCondition'] = termsAndCondition;
    map['poBusinessTerms'] = poBusinessTerms;
    map['paymentTerms'] = paymentTerms;
    map['poTypeId'] = poTypeId;
    map['poOrderDate'] = poOrderDate;
    map['poShippingAddress'] = poShippingAddress;
    map['poOrdCode'] = poOrdCode;
    map['poCurrencyId'] = poCurrencyId;
    map['isPoRejected'] = isPoRejected;
    map['poProcessDays'] = poProcessDays;
    map['poPrefDetails'] = poPrefDetails;
    if (orderAction != null) {
      map['orderAction'] = orderAction?.toJson();
    }
    map['poProductTotalWithTax'] = poProductTotalWithTax;
    map['companyId'] = companyId;
    map['poName'] = poName;
    map['poSubmittedByName'] = poSubmittedByName;
    map['poIsVerified'] = poIsVerified;
    map['poReference'] = poReference;
    return map;
  }

}

class OrderAction {
  OrderAction({
      this.poId, 
      this.isCurrentUserReadyToApprovePo, 
      this.isPoVerified, 
      this.currentUserHasPermissionToPo, 
      this.currentUserHasPermissionToApprovePo, 
      this.isWorkFlowExistsPo, 
      this.poStatus, 
      this.isPoRejectedInApprovalPhase, 
      this.poRejectedReason,});

  OrderAction.fromJson(dynamic json) {
    poId = json['poId'];
    isCurrentUserReadyToApprovePo = json['isCurrentUserReadyToApprovePo'];
    isPoVerified = json['isPoVerified'];
    currentUserHasPermissionToPo = json['currentUserHasPermissionToPo'];
    currentUserHasPermissionToApprovePo = json['currentUserHasPermissionToApprovePo'];
    isWorkFlowExistsPo = json['isWorkFlowExistsPo'];
    poStatus = json['poStatus'];
    isPoRejectedInApprovalPhase = json['isPoRejectedInApprovalPhase'];
    poRejectedReason = json['poRejectedReason'];
  }
  dynamic poId;
  bool? isCurrentUserReadyToApprovePo;
  bool? isPoVerified;
  bool? currentUserHasPermissionToPo;
  bool? currentUserHasPermissionToApprovePo;
  bool? isWorkFlowExistsPo;
  num? poStatus;
  bool? isPoRejectedInApprovalPhase;
  dynamic poRejectedReason;
OrderAction copyWith({  dynamic poId,
  bool? isCurrentUserReadyToApprovePo,
  bool? isPoVerified,
  bool? currentUserHasPermissionToPo,
  bool? currentUserHasPermissionToApprovePo,
  bool? isWorkFlowExistsPo,
  num? poStatus,
  bool? isPoRejectedInApprovalPhase,
  dynamic poRejectedReason,
}) => OrderAction(  poId: poId ?? this.poId,
  isCurrentUserReadyToApprovePo: isCurrentUserReadyToApprovePo ?? this.isCurrentUserReadyToApprovePo,
  isPoVerified: isPoVerified ?? this.isPoVerified,
  currentUserHasPermissionToPo: currentUserHasPermissionToPo ?? this.currentUserHasPermissionToPo,
  currentUserHasPermissionToApprovePo: currentUserHasPermissionToApprovePo ?? this.currentUserHasPermissionToApprovePo,
  isWorkFlowExistsPo: isWorkFlowExistsPo ?? this.isWorkFlowExistsPo,
  poStatus: poStatus ?? this.poStatus,
  isPoRejectedInApprovalPhase: isPoRejectedInApprovalPhase ?? this.isPoRejectedInApprovalPhase,
  poRejectedReason: poRejectedReason ?? this.poRejectedReason,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['poId'] = poId;
    map['isCurrentUserReadyToApprovePo'] = isCurrentUserReadyToApprovePo;
    map['isPoVerified'] = isPoVerified;
    map['currentUserHasPermissionToPo'] = currentUserHasPermissionToPo;
    map['currentUserHasPermissionToApprovePo'] = currentUserHasPermissionToApprovePo;
    map['isWorkFlowExistsPo'] = isWorkFlowExistsPo;
    map['poStatus'] = poStatus;
    map['isPoRejectedInApprovalPhase'] = isPoRejectedInApprovalPhase;
    map['poRejectedReason'] = poRejectedReason;
    return map;
  }

}

class PaymentSchedule {
  PaymentSchedule({
      this.paymentScheduleAmount, 
      this.paymentMilestone, 
      this.paymentPercentage, 
      this.paymentPayType, 
      this.paymentId, 
      this.paymentTotalAmount, 
      this.paymentEvent, 
      this.paymentCurrency, 
      this.paymentPoId,});

  PaymentSchedule.fromJson(dynamic json) {
    paymentScheduleAmount = json['paymentScheduleAmount'];
    paymentMilestone = json['paymentMilestone'];
    paymentPercentage = json['paymentPercentage'];
    paymentPayType = json['paymentPayType'];
    paymentId = json['paymentId'];
    paymentTotalAmount = json['paymentTotalAmount'];
    paymentEvent = json['paymentEvent'];
    paymentCurrency = json['paymentCurrency'];
    paymentPoId = json['paymentPoId'];
  }
  num? paymentScheduleAmount;
  num? paymentMilestone;
  num? paymentPercentage;
  num? paymentPayType;
  num? paymentId;
  num? paymentTotalAmount;
  num? paymentEvent;
  String? paymentCurrency;
  num? paymentPoId;
PaymentSchedule copyWith({  num? paymentScheduleAmount,
  num? paymentMilestone,
  num? paymentPercentage,
  num? paymentPayType,
  num? paymentId,
  num? paymentTotalAmount,
  num? paymentEvent,
  String? paymentCurrency,
  num? paymentPoId,
}) => PaymentSchedule(  paymentScheduleAmount: paymentScheduleAmount ?? this.paymentScheduleAmount,
  paymentMilestone: paymentMilestone ?? this.paymentMilestone,
  paymentPercentage: paymentPercentage ?? this.paymentPercentage,
  paymentPayType: paymentPayType ?? this.paymentPayType,
  paymentId: paymentId ?? this.paymentId,
  paymentTotalAmount: paymentTotalAmount ?? this.paymentTotalAmount,
  paymentEvent: paymentEvent ?? this.paymentEvent,
  paymentCurrency: paymentCurrency ?? this.paymentCurrency,
  paymentPoId: paymentPoId ?? this.paymentPoId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paymentScheduleAmount'] = paymentScheduleAmount;
    map['paymentMilestone'] = paymentMilestone;
    map['paymentPercentage'] = paymentPercentage;
    map['paymentPayType'] = paymentPayType;
    map['paymentId'] = paymentId;
    map['paymentTotalAmount'] = paymentTotalAmount;
    map['paymentEvent'] = paymentEvent;
    map['paymentCurrency'] = paymentCurrency;
    map['paymentPoId'] = paymentPoId;
    return map;
  }

}

class ProductDetails {
  ProductDetails({
      this.unitPrice, 
      this.quantity, 
      this.poCurrency, 
      this.productId, 
      this.discountAmount, 
      this.revNum, 
      this.productName, 
      this.productTotal, 
      this.othersDescription, 
      this.poDetPoId, 
      this.productCategoryId, 
      this.othersAmount, 
      this.taxDescription, 
      this.unitId, 
      this.prodTax, 
      this.poNum, 
      this.taxAmount, 
      this.poDetId, 
      this.productDescription, 
      this.taxType, 
      this.prodTaxExmpReason,});

  ProductDetails.fromJson(dynamic json) {
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
    poCurrency = json['poCurrency'];
    productId = json['productId'];
    discountAmount = json['discountAmount'];
    revNum = json['revNum'];
    productName = json['productName'];
    productTotal = json['productTotal'];
    othersDescription = json['othersDescription'];
    poDetPoId = json['poDetPoId'];
    productCategoryId = json['productCategoryId'];
    othersAmount = json['othersAmount'];
    taxDescription = json['taxDescription'];
    unitId = json['unitId'];
    prodTax = json['prodTax'];
    poNum = json['poNum'];
    taxAmount = json['taxAmount'];
    poDetId = json['poDetId'];
    productDescription = json['productDescription'];
    taxType = json['taxType'];
    prodTaxExmpReason = json['prodTaxExmpReason'];
  }
  num? unitPrice;
  num? quantity;
  String? poCurrency;
  num? productId;
  num? discountAmount;
  num? revNum;
  String? productName;
  num? productTotal;
  dynamic othersDescription;
  num? poDetPoId;
  num? productCategoryId;
  num? othersAmount;
  dynamic taxDescription;
  num? unitId;
  String? prodTax;
  num? poNum;
  num? taxAmount;
  num? poDetId;
  String? productDescription;
  String? taxType;
  dynamic prodTaxExmpReason;
ProductDetails copyWith({  num? unitPrice,
  num? quantity,
  String? poCurrency,
  num? productId,
  num? discountAmount,
  num? revNum,
  String? productName,
  num? productTotal,
  dynamic othersDescription,
  num? poDetPoId,
  num? productCategoryId,
  num? othersAmount,
  dynamic taxDescription,
  num? unitId,
  String? prodTax,
  num? poNum,
  num? taxAmount,
  num? poDetId,
  String? productDescription,
  String? taxType,
  dynamic prodTaxExmpReason,
}) => ProductDetails(  unitPrice: unitPrice ?? this.unitPrice,
  quantity: quantity ?? this.quantity,
  poCurrency: poCurrency ?? this.poCurrency,
  productId: productId ?? this.productId,
  discountAmount: discountAmount ?? this.discountAmount,
  revNum: revNum ?? this.revNum,
  productName: productName ?? this.productName,
  productTotal: productTotal ?? this.productTotal,
  othersDescription: othersDescription ?? this.othersDescription,
  poDetPoId: poDetPoId ?? this.poDetPoId,
  productCategoryId: productCategoryId ?? this.productCategoryId,
  othersAmount: othersAmount ?? this.othersAmount,
  taxDescription: taxDescription ?? this.taxDescription,
  unitId: unitId ?? this.unitId,
  prodTax: prodTax ?? this.prodTax,
  poNum: poNum ?? this.poNum,
  taxAmount: taxAmount ?? this.taxAmount,
  poDetId: poDetId ?? this.poDetId,
  productDescription: productDescription ?? this.productDescription,
  taxType: taxType ?? this.taxType,
  prodTaxExmpReason: prodTaxExmpReason ?? this.prodTaxExmpReason,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unitPrice'] = unitPrice;
    map['quantity'] = quantity;
    map['poCurrency'] = poCurrency;
    map['productId'] = productId;
    map['discountAmount'] = discountAmount;
    map['revNum'] = revNum;
    map['productName'] = productName;
    map['productTotal'] = productTotal;
    map['othersDescription'] = othersDescription;
    map['poDetPoId'] = poDetPoId;
    map['productCategoryId'] = productCategoryId;
    map['othersAmount'] = othersAmount;
    map['taxDescription'] = taxDescription;
    map['unitId'] = unitId;
    map['prodTax'] = prodTax;
    map['poNum'] = poNum;
    map['taxAmount'] = taxAmount;
    map['poDetId'] = poDetId;
    map['productDescription'] = productDescription;
    map['taxType'] = taxType;
    map['prodTaxExmpReason'] = prodTaxExmpReason;
    return map;
  }

}