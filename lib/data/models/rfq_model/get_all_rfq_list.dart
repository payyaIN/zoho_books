class GetAllRfqList {
  GetAllRfqList({
      this.count, 
      this.rfqData, 
      this.totalCount,});

  GetAllRfqList.fromJson(dynamic json) {
    count = json['count'];
    if (json['rfqData'] != null) {
      rfqData = [];
      json['rfqData'].forEach((v) {
        rfqData?.add(RfqData.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
  }
  num? count;
  List<RfqData>? rfqData;
  num? totalCount;
GetAllRfqList copyWith({  num? count,
  List<RfqData>? rfqData,
  num? totalCount,
}) => GetAllRfqList(  count: count ?? this.count,
  rfqData: rfqData ?? this.rfqData,
  totalCount: totalCount ?? this.totalCount,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    if (rfqData != null) {
      map['rfqData'] = rfqData?.map((v) => v.toJson()).toList();
    }
    map['totalCount'] = totalCount;
    return map;
  }

}

class RfqData {
  RfqData({
      this.rfqTotalAmt, 
      this.rfqCreatedBy, 
      this.rfqBranchName, 
      this.rfqRejectReason, 
      this.rfqCreatedDate, 
      this.isRfqRejected, 
      this.rfqStatus, 
      this.productDetails, 
      this.rfqIsverified, 
      this.rfqId, 
      this.rfqVenderName, 
      this.rfqCustomerNote, 
      this.rfqExpDate, 
      this.isRfqSubWithWf, 
      this.rfqCompanyId, 
      this.rfqName, 
      this.rfqCreatedByName, 
      this.rfqCurrencyId, 
      this.rfqReference, 
      this.wfList,});

  RfqData.fromJson(dynamic json) {
    rfqTotalAmt = json['rfqTotalAmt'];
    rfqCreatedBy = json['rfqCreatedBy'];
    rfqBranchName = json['rfqBranchName'];
    rfqRejectReason = json['rfqRejectReason'];
    rfqCreatedDate = json['rfqCreatedDate'];
    isRfqRejected = json['isRfqRejected'];
    rfqStatus = json['rfqStatus'];
    if (json['productDetails'] != null) {
      productDetails = [];
      json['productDetails'].forEach((v) {
        productDetails?.add(ProductDetails.fromJson(v));
      });
    }
    rfqIsverified = json['rfqIsverified'];
    rfqId = json['rfqId'];
    rfqVenderName = json['rfqVenderName'];
    rfqCustomerNote = json['rfqCustomerNote'];
    rfqExpDate = json['rfqExpDate'];
    isRfqSubWithWf = json['isRfqSubWithWf'];
    rfqCompanyId = json['rfqCompanyId'];
    rfqName = json['rfqName'];
    rfqCreatedByName = json['rfqCreatedByName'];
    rfqCurrencyId = json['rfqCurrencyId'];
    rfqReference = json['rfqReference'];
    if (json['wfList'] != null) {
      wfList = [];
      json['wfList'].forEach((v) {
        wfList?.add(WfList.fromJson(v));
      });
    }
  }
  num? rfqTotalAmt;
  String? rfqCreatedBy;
  String? rfqBranchName;
  dynamic rfqRejectReason;
  String? rfqCreatedDate;
  bool? isRfqRejected;
  num? rfqStatus;
  List<ProductDetails>? productDetails;
  num? rfqIsverified;
  num? rfqId;
  String? rfqVenderName;
  String? rfqCustomerNote;
  String? rfqExpDate;
  bool? isRfqSubWithWf;
  String? rfqCompanyId;
  String? rfqName;
  String? rfqCreatedByName;
  String? rfqCurrencyId;
  String? rfqReference;
  List<WfList>? wfList;
RfqData copyWith({  num? rfqTotalAmt,
  String? rfqCreatedBy,
  String? rfqBranchName,
  dynamic rfqRejectReason,
  String? rfqCreatedDate,
  bool? isRfqRejected,
  num? rfqStatus,
  List<ProductDetails>? productDetails,
  num? rfqIsverified,
  num? rfqId,
  String? rfqVenderName,
  String? rfqCustomerNote,
  String? rfqExpDate,
  bool? isRfqSubWithWf,
  String? rfqCompanyId,
  String? rfqName,
  String? rfqCreatedByName,
  String? rfqCurrencyId,
  String? rfqReference,
  List<WfList>? wfList,
}) => RfqData(  rfqTotalAmt: rfqTotalAmt ?? this.rfqTotalAmt,
  rfqCreatedBy: rfqCreatedBy ?? this.rfqCreatedBy,
  rfqBranchName: rfqBranchName ?? this.rfqBranchName,
  rfqRejectReason: rfqRejectReason ?? this.rfqRejectReason,
  rfqCreatedDate: rfqCreatedDate ?? this.rfqCreatedDate,
  isRfqRejected: isRfqRejected ?? this.isRfqRejected,
  rfqStatus: rfqStatus ?? this.rfqStatus,
  productDetails: productDetails ?? this.productDetails,
  rfqIsverified: rfqIsverified ?? this.rfqIsverified,
  rfqId: rfqId ?? this.rfqId,
  rfqVenderName: rfqVenderName ?? this.rfqVenderName,
  rfqCustomerNote: rfqCustomerNote ?? this.rfqCustomerNote,
  rfqExpDate: rfqExpDate ?? this.rfqExpDate,
  isRfqSubWithWf: isRfqSubWithWf ?? this.isRfqSubWithWf,
  rfqCompanyId: rfqCompanyId ?? this.rfqCompanyId,
  rfqName: rfqName ?? this.rfqName,
  rfqCreatedByName: rfqCreatedByName ?? this.rfqCreatedByName,
  rfqCurrencyId: rfqCurrencyId ?? this.rfqCurrencyId,
  rfqReference: rfqReference ?? this.rfqReference,
  wfList: wfList ?? this.wfList,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rfqTotalAmt'] = rfqTotalAmt;
    map['rfqCreatedBy'] = rfqCreatedBy;
    map['rfqBranchName'] = rfqBranchName;
    map['rfqRejectReason'] = rfqRejectReason;
    map['rfqCreatedDate'] = rfqCreatedDate;
    map['isRfqRejected'] = isRfqRejected;
    map['rfqStatus'] = rfqStatus;
    if (productDetails != null) {
      map['productDetails'] = productDetails?.map((v) => v.toJson()).toList();
    }
    map['rfqIsverified'] = rfqIsverified;
    map['rfqId'] = rfqId;
    map['rfqVenderName'] = rfqVenderName;
    map['rfqCustomerNote'] = rfqCustomerNote;
    map['rfqExpDate'] = rfqExpDate;
    map['isRfqSubWithWf'] = isRfqSubWithWf;
    map['rfqCompanyId'] = rfqCompanyId;
    map['rfqName'] = rfqName;
    map['rfqCreatedByName'] = rfqCreatedByName;
    map['rfqCurrencyId'] = rfqCurrencyId;
    map['rfqReference'] = rfqReference;
    if (wfList != null) {
      map['wfList'] = wfList?.map((v) => v.toJson()).toList();
    }
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
  dynamic verifiedOn;
  num? wfStatus;
  String? verifiedBy;
WfList copyWith({  String? wfDepartment,
  dynamic verifiedOn,
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

class ProductDetails {
  ProductDetails({
      this.unitPrice, 
      this.quantity, 
      this.totalPrice, 
      this.productName,});

  ProductDetails.fromJson(dynamic json) {
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
    totalPrice = json['totalPrice'];
    productName = json['productName'];
  }
  num? unitPrice;
  num? quantity;
  num? totalPrice;
  String? productName;
ProductDetails copyWith({  num? unitPrice,
  num? quantity,
  num? totalPrice,
  String? productName,
}) => ProductDetails(  unitPrice: unitPrice ?? this.unitPrice,
  quantity: quantity ?? this.quantity,
  totalPrice: totalPrice ?? this.totalPrice,
  productName: productName ?? this.productName,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unitPrice'] = unitPrice;
    map['quantity'] = quantity;
    map['totalPrice'] = totalPrice;
    map['productName'] = productName;
    return map;
  }

}