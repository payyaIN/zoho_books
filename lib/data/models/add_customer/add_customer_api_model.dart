class AddCustomerApiModel {
  AddCustomerApiModel({
      this.error, 
      this.errorMsg, 
      this.successMsg, 
      this.response, 
      this.status, 
      this.transactionId,});

  AddCustomerApiModel.fromJson(dynamic json) {
    error = json['error'];
    errorMsg = json['errorMsg'];
    successMsg = json['successMsg'];
    response = json['response'];
    status = json['status'];
    transactionId = json['transactionId'];
  }
  bool? error;
  dynamic errorMsg;
  dynamic successMsg;
  dynamic response;
  bool? status;
  String? transactionId;
AddCustomerApiModel copyWith({  bool? error,
  dynamic errorMsg,
  dynamic successMsg,
  dynamic response,
  bool? status,
  String? transactionId,
}) => AddCustomerApiModel(  error: error ?? this.error,
  errorMsg: errorMsg ?? this.errorMsg,
  successMsg: successMsg ?? this.successMsg,
  response: response ?? this.response,
  status: status ?? this.status,
  transactionId: transactionId ?? this.transactionId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['errorMsg'] = errorMsg;
    map['successMsg'] = successMsg;
    map['response'] = response;
    map['status'] = status;
    map['transactionId'] = transactionId;
    return map;
  }

}