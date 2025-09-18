class GetAllOrdersListModel {
  GetAllOrdersListModel({
      this.count, 
      this.orderData, 
      this.totalCount,});

  GetAllOrdersListModel.fromJson(dynamic json) {
    count = json['count'];
    if (json['orderData'] != null) {
      orderData = [];
      json['orderData'].forEach((v) {
        orderData?.add(OrderData.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
  }
  num? count;
  List<OrderData>? orderData;
  num? totalCount;
GetAllOrdersListModel copyWith({  num? count,
  List<OrderData>? orderData,
  num? totalCount,
}) => GetAllOrdersListModel(  count: count ?? this.count,
  orderData: orderData ?? this.orderData,
  totalCount: totalCount ?? this.totalCount,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    if (orderData != null) {
      map['orderData'] = orderData?.map((v) => v.toJson()).toList();
    }
    map['totalCount'] = totalCount;
    return map;
  }

}

class OrderData {
  OrderData({
      this.poVenderId, 
      this.poShippingType, 
      this.poCmpId, 
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
      this.poBusinessTerms, 
      this.isPoWithWf, 
      this.wfList, 
      this.poOrderDate, 
      this.poShippingAddress, 
      this.poOrdCode, 
      this.poCurrencyId, 
      this.isPoRejected, 
      this.poPrefDetails, 
      this.poProductTotalWithTax, 
      this.poName, 
      this.poCurId, 
      this.poIsVerified, 
      this.poReference,});

  OrderData.fromJson(dynamic json) {
    poVenderId = json['poVenderId'];
    poShippingType = json['poShippingType'];
    poCmpId = json['poCmpId'];
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
    poBusinessTerms = json['poBusinessTerms'];
    isPoWithWf = json['isPoWithWf'];
    if (json['wfList'] != null) {
      wfList = [];
      json['wfList'].forEach((v) {
        wfList?.add(WfList.fromJson(v));
      });
    }
    poOrderDate = json['poOrderDate'];
    poShippingAddress = json['poShippingAddress'];
    poOrdCode = json['poOrdCode'];
    poCurrencyId = json['poCurrencyId'];
    isPoRejected = json['isPoRejected'];
    poPrefDetails = json['poPrefDetails'];
    poProductTotalWithTax = json['poProductTotalWithTax'];
    poName = json['poName'];
    poCurId = json['poCurId'];
    poIsVerified = json['poIsVerified'];
    poReference = json['poReference'];
  }
  num? poVenderId;
  num? poShippingType;
  String? poCmpId;
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
  num? poBusinessTerms;
  bool? isPoWithWf;
  List<WfList>? wfList;
  String? poOrderDate;
  num? poShippingAddress;
  String? poOrdCode;
  String? poCurrencyId;
  bool? isPoRejected;
  String? poPrefDetails;
  num? poProductTotalWithTax;
  String? poName;
  num? poCurId;
  num? poIsVerified;
  String? poReference;
OrderData copyWith({  num? poVenderId,
  num? poShippingType,
  String? poCmpId,
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
  num? poBusinessTerms,
  bool? isPoWithWf,
  List<WfList>? wfList,
  String? poOrderDate,
  num? poShippingAddress,
  String? poOrdCode,
  String? poCurrencyId,
  bool? isPoRejected,
  String? poPrefDetails,
  num? poProductTotalWithTax,
  String? poName,
  num? poCurId,
  num? poIsVerified,
  String? poReference,
}) => OrderData(  poVenderId: poVenderId ?? this.poVenderId,
  poShippingType: poShippingType ?? this.poShippingType,
  poCmpId: poCmpId ?? this.poCmpId,
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
  poBusinessTerms: poBusinessTerms ?? this.poBusinessTerms,
  isPoWithWf: isPoWithWf ?? this.isPoWithWf,
  wfList: wfList ?? this.wfList,
  poOrderDate: poOrderDate ?? this.poOrderDate,
  poShippingAddress: poShippingAddress ?? this.poShippingAddress,
  poOrdCode: poOrdCode ?? this.poOrdCode,
  poCurrencyId: poCurrencyId ?? this.poCurrencyId,
  isPoRejected: isPoRejected ?? this.isPoRejected,
  poPrefDetails: poPrefDetails ?? this.poPrefDetails,
  poProductTotalWithTax: poProductTotalWithTax ?? this.poProductTotalWithTax,
  poName: poName ?? this.poName,
  poCurId: poCurId ?? this.poCurId,
  poIsVerified: poIsVerified ?? this.poIsVerified,
  poReference: poReference ?? this.poReference,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['poVenderId'] = poVenderId;
    map['poShippingType'] = poShippingType;
    map['poCmpId'] = poCmpId;
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
    map['poBusinessTerms'] = poBusinessTerms;
    map['isPoWithWf'] = isPoWithWf;
    if (wfList != null) {
      map['wfList'] = wfList?.map((v) => v.toJson()).toList();
    }
    map['poOrderDate'] = poOrderDate;
    map['poShippingAddress'] = poShippingAddress;
    map['poOrdCode'] = poOrdCode;
    map['poCurrencyId'] = poCurrencyId;
    map['isPoRejected'] = isPoRejected;
    map['poPrefDetails'] = poPrefDetails;
    map['poProductTotalWithTax'] = poProductTotalWithTax;
    map['poName'] = poName;
    map['poCurId'] = poCurId;
    map['poIsVerified'] = poIsVerified;
    map['poReference'] = poReference;
    return map;
  }

}

class WfList {
  WfList({
      this.wfDepartment, 
      this.verifiedOn, 
      this.wfStatus, 
      this.verifiedBy,});

  WfList.fromJson(dynamic json) {
    wfDepartment = json['wfDepartment'];
    verifiedOn = json['verifiedOn'];
    wfStatus = json['wfStatus'];
    verifiedBy = json['verifiedBy'];
  }
  String? wfDepartment;
  String? verifiedOn;
  num? wfStatus;
  String? verifiedBy;
WfList copyWith({  String? wfDepartment,
  String? verifiedOn,
  num? wfStatus,
  String? verifiedBy,
}) => WfList(  wfDepartment: wfDepartment ?? this.wfDepartment,
  verifiedOn: verifiedOn ?? this.verifiedOn,
  wfStatus: wfStatus ?? this.wfStatus,
  verifiedBy: verifiedBy ?? this.verifiedBy,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['wfDepartment'] = wfDepartment;
    map['verifiedOn'] = verifiedOn;
    map['wfStatus'] = wfStatus;
    map['verifiedBy'] = verifiedBy;
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
  num? paymentCurrency;
  num? paymentPoId;
PaymentSchedule copyWith({  num? paymentScheduleAmount,
  num? paymentMilestone,
  num? paymentPercentage,
  num? paymentPayType,
  num? paymentId,
  num? paymentTotalAmount,
  num? paymentEvent,
  num? paymentCurrency,
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
      this.poNum, 
      this.taxAmount, 
      this.currencyId, 
      this.poDetId, 
      this.productDescription,});

  ProductDetails.fromJson(dynamic json) {
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
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
    poNum = json['poNum'];
    taxAmount = json['taxAmount'];
    currencyId = json['currencyId'];
    poDetId = json['poDetId'];
    productDescription = json['productDescription'];
  }
  num? unitPrice;
  num? quantity;
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
  num? poNum;
  num? taxAmount;
  num? currencyId;
  num? poDetId;
  String? productDescription;
ProductDetails copyWith({  num? unitPrice,
  num? quantity,
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
  num? poNum,
  num? taxAmount,
  num? currencyId,
  num? poDetId,
  String? productDescription,
}) => ProductDetails(  unitPrice: unitPrice ?? this.unitPrice,
  quantity: quantity ?? this.quantity,
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
  poNum: poNum ?? this.poNum,
  taxAmount: taxAmount ?? this.taxAmount,
  currencyId: currencyId ?? this.currencyId,
  poDetId: poDetId ?? this.poDetId,
  productDescription: productDescription ?? this.productDescription,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unitPrice'] = unitPrice;
    map['quantity'] = quantity;
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
    map['poNum'] = poNum;
    map['taxAmount'] = taxAmount;
    map['currencyId'] = currencyId;
    map['poDetId'] = poDetId;
    map['productDescription'] = productDescription;
    return map;
  }

}