class GetCountryListModel {
  GetCountryListModel({
    this.error,
    this.message,
    this.response,
    this.status,
  });

  GetCountryListModel.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    if (json['response'] != null) {
      response = [];
      json['response'].forEach((v) {
        response?.add(Response.fromJson(v));
      });
    }
    status = json['status'];
  }
  bool? error;
  String? message;
  List<Response>? response;
  bool? status;
  GetCountryListModel copyWith({
    bool? error,
    String? message,
    List<Response>? response,
    bool? status,
  }) =>
      GetCountryListModel(
        error: error ?? this.error,
        message: message ?? this.message,
        response: response ?? this.response,
        status: status ?? this.status,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    return map;
  }
}

class Response {
  Response({
    this.ccode,
    this.ccid,
    this.countryFlag,
    this.ccphnCode,
    this.countryName,
  });

  Response.fromJson(dynamic json) {
    ccode = json['ccode'];
    ccid = json['ccid'];
    countryFlag = json['countryFlag'];
    ccphnCode = json['ccphnCode'];
    countryName = json['countryName'];
  }
  String? ccode;
  num? ccid;
  String? countryFlag;
  String? ccphnCode;
  String? countryName;
  Response copyWith({
    String? ccode,
    num? ccid,
    String? countryFlag,
    String? ccphnCode,
    String? countryName,
  }) =>
      Response(
        ccode: ccode ?? this.ccode,
        ccid: ccid ?? this.ccid,
        countryFlag: countryFlag ?? this.countryFlag,
        ccphnCode: ccphnCode ?? this.ccphnCode,
        countryName: countryName ?? this.countryName,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ccode'] = ccode;
    map['ccid'] = ccid;
    map['countryFlag'] = countryFlag;
    map['ccphnCode'] = ccphnCode;
    map['countryName'] = countryName;
    return map;
  }
}
