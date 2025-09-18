class RegisterVendorResponse {
  final bool error;
  final String? errorMsg;
  final String? successMsg;
  final dynamic response;
  final bool status;
  final String transactionId;

  RegisterVendorResponse({
    required this.error,
    this.errorMsg,
    this.successMsg,
    this.response,
    required this.status,
    required this.transactionId,
  });

  factory RegisterVendorResponse.fromJson(Map<String, dynamic> json) {
    return RegisterVendorResponse(
      error: json['error'] ?? false,
      errorMsg: json['errorMsg'],
      successMsg: json['successMsg'],
      response: json['response'],
      status: json['status'] ?? false,
      transactionId: json['transactionId'] ?? '',
    );
  }
}
