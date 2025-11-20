class AddExpenseApiResponse {
  final bool error;
  final String message;
  final dynamic response;
  final bool status;

  AddExpenseApiResponse({
    required this.error,
    required this.message,
    required this.response,
    required this.status,
  });

  factory AddExpenseApiResponse.fromJson(Map<String, dynamic> json) {
    return AddExpenseApiResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      response: json['response'], // Can be null or dynamic
      status: json['status'] ?? false,
    );
  }
}
