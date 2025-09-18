class QuotesDetailsModel {
  QuotesDetailsModel({
      this.qteCurId, 
      this.quoteTermsCond, 
      this.quoteCmpId, 
      this.isQuoteSubWithWf, 
      this.quoteOrgId, 
      this.quoteShippingAddress, 
      this.productDetails, 
      this.quoteStatus, 
      this.quoteProductTotal, 
      this.paymentScheduleType, 
      this.paymentSchedule, 
      this.quoteReference, 
      this.qteSubmittedByName, 
      this.quoteCustomerNote, 
      this.quoteShippingType, 
      this.quoteCustomerId, 
      this.quotePostedBy, 
      this.quoteWfRejectReason, 
      this.incQteWfRejectReason, 
      this.qteIsVerified, 
      this.quoteId, 
      this.quoteCurrency, 
      this.quoteExpDate, 
      this.quoteNum, 
      this.quoteAction, 
      this.quoteBranchId, 
      this.quoteProcessDays, 
      this.quoteBusinessTerms, 
      this.quoteAttachIsPresent, 
      this.quoteEstimateDate, 
      this.quoteProductTotalWithTax, 
      this.quotePrefDetails, 
      this.quotePostedDate, 
      this.quoteRevNum, 
      this.quoteName,});

  QuotesDetailsModel.fromJson(dynamic json) {
    qteCurId = json['qteCurId'];
    quoteTermsCond = json['quoteTermsCond'];
    quoteCmpId = json['quoteCmpId'];
    isQuoteSubWithWf = json['isQuoteSubWithWf'];
    quoteOrgId = json['quoteOrgId'];
    quoteShippingAddress = json['quoteShippingAddress'];
    if (json['productDetails'] != null) {
      productDetails = [];
      json['productDetails'].forEach((v) {
        productDetails?.add(ProductDetails.fromJson(v));
      });
    }
    quoteStatus = json['quoteStatus'];
    quoteProductTotal = json['quoteProductTotal'];
    paymentScheduleType = json['paymentScheduleType'];
    if (json['paymentSchedule'] != null) {
      paymentSchedule = [];
      json['paymentSchedule'].forEach((v) {
        paymentSchedule?.add(PaymentSchedule.fromJson(v));
      });
    }
    quoteReference = json['quoteReference'];
    qteSubmittedByName = json['qteSubmittedByName'];
    quoteCustomerNote = json['quoteCustomerNote'];
    quoteShippingType = json['quoteShippingType'];
    quoteCustomerId = json['quoteCustomerId'];
    quotePostedBy = json['quotePostedBy'];
    quoteWfRejectReason = json['quoteWfRejectReason'];
    incQteWfRejectReason = json['incQteWfRejectReason'];
    qteIsVerified = json['qteIsVerified'];
    quoteId = json['quoteId'];
    quoteCurrency = json['quoteCurrency'];
    quoteExpDate = json['quoteExpDate'];
    quoteNum = json['quoteNum'];
    quoteAction = json['quoteAction'] != null ? QuoteAction.fromJson(json['quoteAction']) : null;
    quoteBranchId = json['quoteBranchId'];
    quoteProcessDays = json['quoteProcessDays'];
    quoteBusinessTerms = json['quoteBusinessTerms'];
    quoteAttachIsPresent = json['quoteAttachIsPresent'];
    quoteEstimateDate = json['quoteEstimateDate'];
    quoteProductTotalWithTax = json['quoteProductTotalWithTax'];
    quotePrefDetails = json['quotePrefDetails'];
    quotePostedDate = json['quotePostedDate'];
    quoteRevNum = json['quoteRevNum'];
    quoteName = json['quoteName'];
  }
  num? qteCurId;
  String? quoteTermsCond;
  String? quoteCmpId;
  bool? isQuoteSubWithWf;
  String? quoteOrgId;
  dynamic quoteShippingAddress;
  List<ProductDetails>? productDetails;
  num? quoteStatus;
  num? quoteProductTotal;
  num? paymentScheduleType;
  List<PaymentSchedule>? paymentSchedule;
  String? quoteReference;
  String? qteSubmittedByName;
  String? quoteCustomerNote;
  num? quoteShippingType;
  num? quoteCustomerId;
  String? quotePostedBy;
  dynamic quoteWfRejectReason;
  dynamic incQteWfRejectReason;
  num? qteIsVerified;
  num? quoteId;
  String? quoteCurrency;
  String? quoteExpDate;
  num? quoteNum;
  QuoteAction? quoteAction;
  num? quoteBranchId;
  num? quoteProcessDays;
  num? quoteBusinessTerms;
  num? quoteAttachIsPresent;
  String? quoteEstimateDate;
  num? quoteProductTotalWithTax;
  String? quotePrefDetails;
  String? quotePostedDate;
  num? quoteRevNum;
  String? quoteName;
QuotesDetailsModel copyWith({  num? qteCurId,
  String? quoteTermsCond,
  String? quoteCmpId,
  bool? isQuoteSubWithWf,
  String? quoteOrgId,
  dynamic quoteShippingAddress,
  List<ProductDetails>? productDetails,
  num? quoteStatus,
  num? quoteProductTotal,
  num? paymentScheduleType,
  List<PaymentSchedule>? paymentSchedule,
  String? quoteReference,
  String? qteSubmittedByName,
  String? quoteCustomerNote,
  num? quoteShippingType,
  num? quoteCustomerId,
  String? quotePostedBy,
  dynamic quoteWfRejectReason,
  dynamic incQteWfRejectReason,
  num? qteIsVerified,
  num? quoteId,
  String? quoteCurrency,
  String? quoteExpDate,
  num? quoteNum,
  QuoteAction? quoteAction,
  num? quoteBranchId,
  num? quoteProcessDays,
  num? quoteBusinessTerms,
  num? quoteAttachIsPresent,
  String? quoteEstimateDate,
  num? quoteProductTotalWithTax,
  String? quotePrefDetails,
  String? quotePostedDate,
  num? quoteRevNum,
  String? quoteName,
}) => QuotesDetailsModel(  qteCurId: qteCurId ?? this.qteCurId,
  quoteTermsCond: quoteTermsCond ?? this.quoteTermsCond,
  quoteCmpId: quoteCmpId ?? this.quoteCmpId,
  isQuoteSubWithWf: isQuoteSubWithWf ?? this.isQuoteSubWithWf,
  quoteOrgId: quoteOrgId ?? this.quoteOrgId,
  quoteShippingAddress: quoteShippingAddress ?? this.quoteShippingAddress,
  productDetails: productDetails ?? this.productDetails,
  quoteStatus: quoteStatus ?? this.quoteStatus,
  quoteProductTotal: quoteProductTotal ?? this.quoteProductTotal,
  paymentScheduleType: paymentScheduleType ?? this.paymentScheduleType,
  paymentSchedule: paymentSchedule ?? this.paymentSchedule,
  quoteReference: quoteReference ?? this.quoteReference,
  qteSubmittedByName: qteSubmittedByName ?? this.qteSubmittedByName,
  quoteCustomerNote: quoteCustomerNote ?? this.quoteCustomerNote,
  quoteShippingType: quoteShippingType ?? this.quoteShippingType,
  quoteCustomerId: quoteCustomerId ?? this.quoteCustomerId,
  quotePostedBy: quotePostedBy ?? this.quotePostedBy,
  quoteWfRejectReason: quoteWfRejectReason ?? this.quoteWfRejectReason,
  incQteWfRejectReason: incQteWfRejectReason ?? this.incQteWfRejectReason,
  qteIsVerified: qteIsVerified ?? this.qteIsVerified,
  quoteId: quoteId ?? this.quoteId,
  quoteCurrency: quoteCurrency ?? this.quoteCurrency,
  quoteExpDate: quoteExpDate ?? this.quoteExpDate,
  quoteNum: quoteNum ?? this.quoteNum,
  quoteAction: quoteAction ?? this.quoteAction,
  quoteBranchId: quoteBranchId ?? this.quoteBranchId,
  quoteProcessDays: quoteProcessDays ?? this.quoteProcessDays,
  quoteBusinessTerms: quoteBusinessTerms ?? this.quoteBusinessTerms,
  quoteAttachIsPresent: quoteAttachIsPresent ?? this.quoteAttachIsPresent,
  quoteEstimateDate: quoteEstimateDate ?? this.quoteEstimateDate,
  quoteProductTotalWithTax: quoteProductTotalWithTax ?? this.quoteProductTotalWithTax,
  quotePrefDetails: quotePrefDetails ?? this.quotePrefDetails,
  quotePostedDate: quotePostedDate ?? this.quotePostedDate,
  quoteRevNum: quoteRevNum ?? this.quoteRevNum,
  quoteName: quoteName ?? this.quoteName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qteCurId'] = qteCurId;
    map['quoteTermsCond'] = quoteTermsCond;
    map['quoteCmpId'] = quoteCmpId;
    map['isQuoteSubWithWf'] = isQuoteSubWithWf;
    map['quoteOrgId'] = quoteOrgId;
    map['quoteShippingAddress'] = quoteShippingAddress;
    if (productDetails != null) {
      map['productDetails'] = productDetails?.map((v) => v.toJson()).toList();
    }
    map['quoteStatus'] = quoteStatus;
    map['quoteProductTotal'] = quoteProductTotal;
    map['paymentScheduleType'] = paymentScheduleType;
    if (paymentSchedule != null) {
      map['paymentSchedule'] = paymentSchedule?.map((v) => v.toJson()).toList();
    }
    map['quoteReference'] = quoteReference;
    map['qteSubmittedByName'] = qteSubmittedByName;
    map['quoteCustomerNote'] = quoteCustomerNote;
    map['quoteShippingType'] = quoteShippingType;
    map['quoteCustomerId'] = quoteCustomerId;
    map['quotePostedBy'] = quotePostedBy;
    map['quoteWfRejectReason'] = quoteWfRejectReason;
    map['incQteWfRejectReason'] = incQteWfRejectReason;
    map['qteIsVerified'] = qteIsVerified;
    map['quoteId'] = quoteId;
    map['quoteCurrency'] = quoteCurrency;
    map['quoteExpDate'] = quoteExpDate;
    map['quoteNum'] = quoteNum;
    if (quoteAction != null) {
      map['quoteAction'] = quoteAction?.toJson();
    }
    map['quoteBranchId'] = quoteBranchId;
    map['quoteProcessDays'] = quoteProcessDays;
    map['quoteBusinessTerms'] = quoteBusinessTerms;
    map['quoteAttachIsPresent'] = quoteAttachIsPresent;
    map['quoteEstimateDate'] = quoteEstimateDate;
    map['quoteProductTotalWithTax'] = quoteProductTotalWithTax;
    map['quotePrefDetails'] = quotePrefDetails;
    map['quotePostedDate'] = quotePostedDate;
    map['quoteRevNum'] = quoteRevNum;
    map['quoteName'] = quoteName;
    return map;
  }

}

class QuoteAction {
  QuoteAction({
      this.qteId, 
      this.isCurrentUserReadyToApproveQte, 
      this.isQteVerified, 
      this.currentUserHasPermissionToQte, 
      this.currentUserHasPermissionToApproveQte, 
      this.isWorkFlowExistsQte, 
      this.qteStatus, 
      this.isQteRejectedInApprovalPhase, 
      this.qteRejectedReason,});

  QuoteAction.fromJson(dynamic json) {
    qteId = json['qteId'];
    isCurrentUserReadyToApproveQte = json['isCurrentUserReadyToApproveQte'];
    isQteVerified = json['isQteVerified'];
    currentUserHasPermissionToQte = json['currentUserHasPermissionToQte'];
    currentUserHasPermissionToApproveQte = json['currentUserHasPermissionToApproveQte'];
    isWorkFlowExistsQte = json['isWorkFlowExistsQte'];
    qteStatus = json['qteStatus'];
    isQteRejectedInApprovalPhase = json['isQteRejectedInApprovalPhase'];
    qteRejectedReason = json['qteRejectedReason'];
  }
  dynamic qteId;
  bool? isCurrentUserReadyToApproveQte;
  bool? isQteVerified;
  bool? currentUserHasPermissionToQte;
  bool? currentUserHasPermissionToApproveQte;
  bool? isWorkFlowExistsQte;
  num? qteStatus;
  bool? isQteRejectedInApprovalPhase;
  dynamic qteRejectedReason;
QuoteAction copyWith({  dynamic qteId,
  bool? isCurrentUserReadyToApproveQte,
  bool? isQteVerified,
  bool? currentUserHasPermissionToQte,
  bool? currentUserHasPermissionToApproveQte,
  bool? isWorkFlowExistsQte,
  num? qteStatus,
  bool? isQteRejectedInApprovalPhase,
  dynamic qteRejectedReason,
}) => QuoteAction(  qteId: qteId ?? this.qteId,
  isCurrentUserReadyToApproveQte: isCurrentUserReadyToApproveQte ?? this.isCurrentUserReadyToApproveQte,
  isQteVerified: isQteVerified ?? this.isQteVerified,
  currentUserHasPermissionToQte: currentUserHasPermissionToQte ?? this.currentUserHasPermissionToQte,
  currentUserHasPermissionToApproveQte: currentUserHasPermissionToApproveQte ?? this.currentUserHasPermissionToApproveQte,
  isWorkFlowExistsQte: isWorkFlowExistsQte ?? this.isWorkFlowExistsQte,
  qteStatus: qteStatus ?? this.qteStatus,
  isQteRejectedInApprovalPhase: isQteRejectedInApprovalPhase ?? this.isQteRejectedInApprovalPhase,
  qteRejectedReason: qteRejectedReason ?? this.qteRejectedReason,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qteId'] = qteId;
    map['isCurrentUserReadyToApproveQte'] = isCurrentUserReadyToApproveQte;
    map['isQteVerified'] = isQteVerified;
    map['currentUserHasPermissionToQte'] = currentUserHasPermissionToQte;
    map['currentUserHasPermissionToApproveQte'] = currentUserHasPermissionToApproveQte;
    map['isWorkFlowExistsQte'] = isWorkFlowExistsQte;
    map['qteStatus'] = qteStatus;
    map['isQteRejectedInApprovalPhase'] = isQteRejectedInApprovalPhase;
    map['qteRejectedReason'] = qteRejectedReason;
    return map;
  }

}

class PaymentSchedule {
  PaymentSchedule({
      this.paymentScheduleAmount, 
      this.paymentMilestone, 
      this.paymentQuoteId, 
      this.paymentPercentage, 
      this.paymentPayType, 
      this.paymentId, 
      this.paymentTotalAmount, 
      this.paymentEvent, 
      this.paymentCurrency,});

  PaymentSchedule.fromJson(dynamic json) {
    paymentScheduleAmount = json['paymentScheduleAmount'];
    paymentMilestone = json['paymentMilestone'];
    paymentQuoteId = json['paymentQuoteId'];
    paymentPercentage = json['paymentPercentage'];
    paymentPayType = json['paymentPayType'];
    paymentId = json['paymentId'];
    paymentTotalAmount = json['paymentTotalAmount'];
    paymentEvent = json['paymentEvent'];
    paymentCurrency = json['paymentCurrency'];
  }
  num? paymentScheduleAmount;
  num? paymentMilestone;
  num? paymentQuoteId;
  num? paymentPercentage;
  num? paymentPayType;
  num? paymentId;
  num? paymentTotalAmount;
  num? paymentEvent;
  String? paymentCurrency;
PaymentSchedule copyWith({  num? paymentScheduleAmount,
  num? paymentMilestone,
  num? paymentQuoteId,
  num? paymentPercentage,
  num? paymentPayType,
  num? paymentId,
  num? paymentTotalAmount,
  num? paymentEvent,
  String? paymentCurrency,
}) => PaymentSchedule(  paymentScheduleAmount: paymentScheduleAmount ?? this.paymentScheduleAmount,
  paymentMilestone: paymentMilestone ?? this.paymentMilestone,
  paymentQuoteId: paymentQuoteId ?? this.paymentQuoteId,
  paymentPercentage: paymentPercentage ?? this.paymentPercentage,
  paymentPayType: paymentPayType ?? this.paymentPayType,
  paymentId: paymentId ?? this.paymentId,
  paymentTotalAmount: paymentTotalAmount ?? this.paymentTotalAmount,
  paymentEvent: paymentEvent ?? this.paymentEvent,
  paymentCurrency: paymentCurrency ?? this.paymentCurrency,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paymentScheduleAmount'] = paymentScheduleAmount;
    map['paymentMilestone'] = paymentMilestone;
    map['paymentQuoteId'] = paymentQuoteId;
    map['paymentPercentage'] = paymentPercentage;
    map['paymentPayType'] = paymentPayType;
    map['paymentId'] = paymentId;
    map['paymentTotalAmount'] = paymentTotalAmount;
    map['paymentEvent'] = paymentEvent;
    map['paymentCurrency'] = paymentCurrency;
    return map;
  }

}

class ProductDetails {
  ProductDetails({
      this.unitPrice, 
      this.quantity, 
      this.productId, 
      this.revisionNumber, 
      this.discountAmount, 
      this.productUnit, 
      this.productName, 
      this.productTotal, 
      this.quoteNumber, 
      this.othersDescription, 
      this.productCategoryId, 
      this.othersAmount, 
      this.taxDescription, 
      this.unitId, 
      this.prodTax, 
      this.currency, 
      this.quoteDetId, 
      this.quoteDetQuoteId, 
      this.taxAmount, 
      this.productDescription, 
      this.taxType, 
      this.prodTaxExmpReason,});

  ProductDetails.fromJson(dynamic json) {
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
    productId = json['productId'];
    revisionNumber = json['revisionNumber'];
    discountAmount = json['discountAmount'];
    productUnit = json['productUnit'];
    productName = json['productName'];
    productTotal = json['productTotal'];
    quoteNumber = json['quoteNumber'];
    othersDescription = json['othersDescription'];
    productCategoryId = json['productCategoryId'];
    othersAmount = json['othersAmount'];
    taxDescription = json['taxDescription'];
    unitId = json['unitId'];
    prodTax = json['prodTax'];
    currency = json['currency'];
    quoteDetId = json['quoteDetId'];
    quoteDetQuoteId = json['quoteDetQuoteId'];
    taxAmount = json['taxAmount'];
    productDescription = json['productDescription'];
    taxType = json['taxType'];
    prodTaxExmpReason = json['prodTaxExmpReason'];
  }
  num? unitPrice;
  num? quantity;
  num? productId;
  num? revisionNumber;
  num? discountAmount;
  String? productUnit;
  String? productName;
  num? productTotal;
  num? quoteNumber;
  dynamic othersDescription;
  num? productCategoryId;
  num? othersAmount;
  dynamic taxDescription;
  num? unitId;
  String? prodTax;
  String? currency;
  num? quoteDetId;
  num? quoteDetQuoteId;
  num? taxAmount;
  String? productDescription;
  String? taxType;
  dynamic prodTaxExmpReason;
ProductDetails copyWith({  num? unitPrice,
  num? quantity,
  num? productId,
  num? revisionNumber,
  num? discountAmount,
  String? productUnit,
  String? productName,
  num? productTotal,
  num? quoteNumber,
  dynamic othersDescription,
  num? productCategoryId,
  num? othersAmount,
  dynamic taxDescription,
  num? unitId,
  String? prodTax,
  String? currency,
  num? quoteDetId,
  num? quoteDetQuoteId,
  num? taxAmount,
  String? productDescription,
  String? taxType,
  dynamic prodTaxExmpReason,
}) => ProductDetails(  unitPrice: unitPrice ?? this.unitPrice,
  quantity: quantity ?? this.quantity,
  productId: productId ?? this.productId,
  revisionNumber: revisionNumber ?? this.revisionNumber,
  discountAmount: discountAmount ?? this.discountAmount,
  productUnit: productUnit ?? this.productUnit,
  productName: productName ?? this.productName,
  productTotal: productTotal ?? this.productTotal,
  quoteNumber: quoteNumber ?? this.quoteNumber,
  othersDescription: othersDescription ?? this.othersDescription,
  productCategoryId: productCategoryId ?? this.productCategoryId,
  othersAmount: othersAmount ?? this.othersAmount,
  taxDescription: taxDescription ?? this.taxDescription,
  unitId: unitId ?? this.unitId,
  prodTax: prodTax ?? this.prodTax,
  currency: currency ?? this.currency,
  quoteDetId: quoteDetId ?? this.quoteDetId,
  quoteDetQuoteId: quoteDetQuoteId ?? this.quoteDetQuoteId,
  taxAmount: taxAmount ?? this.taxAmount,
  productDescription: productDescription ?? this.productDescription,
  taxType: taxType ?? this.taxType,
  prodTaxExmpReason: prodTaxExmpReason ?? this.prodTaxExmpReason,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unitPrice'] = unitPrice;
    map['quantity'] = quantity;
    map['productId'] = productId;
    map['revisionNumber'] = revisionNumber;
    map['discountAmount'] = discountAmount;
    map['productUnit'] = productUnit;
    map['productName'] = productName;
    map['productTotal'] = productTotal;
    map['quoteNumber'] = quoteNumber;
    map['othersDescription'] = othersDescription;
    map['productCategoryId'] = productCategoryId;
    map['othersAmount'] = othersAmount;
    map['taxDescription'] = taxDescription;
    map['unitId'] = unitId;
    map['prodTax'] = prodTax;
    map['currency'] = currency;
    map['quoteDetId'] = quoteDetId;
    map['quoteDetQuoteId'] = quoteDetQuoteId;
    map['taxAmount'] = taxAmount;
    map['productDescription'] = productDescription;
    map['taxType'] = taxType;
    map['prodTaxExmpReason'] = prodTaxExmpReason;
    return map;
  }

}