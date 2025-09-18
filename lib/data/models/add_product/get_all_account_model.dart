class Account {
  final String? code;
  final String? label;
  final int? value;

  Account({this.code, this.label, this.value});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      code: json['code'],
      label: json['label'],
      value: json['value'],
    );
  }
}

class AccountResponse {
  final bool error;
  final String message;
  final List<Account> response;
  final bool status;

  AccountResponse({
    required this.error,
    required this.message,
    required this.response,
    required this.status,
  });

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    final responseList = json['response'] as List<dynamic>? ?? [];
    return AccountResponse(
      error: json['error'] ?? true,
      message: json['message'] ?? '',
      status: json['status'] ?? false,
      response: responseList.map((e) => Account.fromJson(e)).toList(),
    );
  }
}
