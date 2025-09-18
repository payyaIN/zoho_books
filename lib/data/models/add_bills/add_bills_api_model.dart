class AddBillApiModel {
  final String? html;
  final String? status;
  final bool? error;
  final String? errorMsg;
  final String? transactionId;

  AddBillApiModel({this.html, this.status, this.error, this.errorMsg, this.transactionId});

  factory AddBillApiModel.fromJson(Map<String, dynamic> json) {
    return AddBillApiModel(
      html: json['html'],
      status: json['status'],
      error: json['error'],
      errorMsg: json['errorMsg'],
      transactionId: json['transactionId'],
    );
  }
}
