class GetStateListModel {
  GetStateListModel({
      this.error, 
      this.message, 
      this.response, 
      this.status,});

  GetStateListModel.fromJson(dynamic json) {
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
GetStateListModel copyWith({  bool? error,
  String? message,
  List<Response>? response,
  bool? status,
}) => GetStateListModel(  error: error ?? this.error,
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
      this.rName, 
      this.rCode, 
      this.rId, 
      this.rCodeId,});

  Response.fromJson(dynamic json) {
    rName = json['rName'];
    rCode = json['rCode'];
    rId = json['rId'];
    rCodeId = json['rCodeId'];
  }
  String? rName;
  String? rCode;
  num? rId;
  num? rCodeId;
Response copyWith({  String? rName,
  String? rCode,
  num? rId,
  num? rCodeId,
}) => Response(  rName: rName ?? this.rName,
  rCode: rCode ?? this.rCode,
  rId: rId ?? this.rId,
  rCodeId: rCodeId ?? this.rCodeId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rName'] = rName;
    map['rCode'] = rCode;
    map['rId'] = rId;
    map['rCodeId'] = rCodeId;
    return map;
  }

}