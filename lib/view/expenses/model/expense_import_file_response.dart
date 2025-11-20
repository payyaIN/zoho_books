class ImportFileResponse {
  final bool? error;
  final String? message;
  final dynamic response;
  final bool? status;

  ImportFileResponse({
    this.error,
    this.message,
    this.response,
    this.status,
  });

  factory ImportFileResponse.fromJson(Map<String, dynamic> json) {
    return ImportFileResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      response: json['response'],
      status: json['status'] as bool?,
    );
  }
}
