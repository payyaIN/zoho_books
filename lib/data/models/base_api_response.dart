class BaseApiResponse {
  final bool? error;
  final String? errorMsg;
  final String? successMsg;
  final dynamic response;
  final bool? status;
  final String? transactionId;

  BaseApiResponse({
    this.error,
    this.errorMsg,
    this.successMsg,
    this.response,
    this.status,
    this.transactionId,
  });

  factory BaseApiResponse.fromJson(Map<String, dynamic> json) {
    return BaseApiResponse(
      error: json['error'],
      errorMsg: json['errorMsg'],
      successMsg: json['successMsg'],
      response: json['response'],
      status: json['status'],
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'errorMsg': errorMsg,
      'successMsg': successMsg,
      'response': response,
      'status': status,
      'transactionId': transactionId,
    };
  }
}
