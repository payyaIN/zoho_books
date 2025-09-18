import 'dart:convert';

class LogoutModel {
  final bool error;
  final dynamic message;
  final LogoutResponse response;
  final bool status;

  LogoutModel({
    required this.error,
    this.message,
    required this.response,
    required this.status,
  });

  factory LogoutModel.fromJson(String str) =>
      LogoutModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LogoutModel.fromMap(Map<String, dynamic> json) {
    return LogoutModel(
      error: json["error"] ?? false,
      message: json["message"],
      response: json["response"] != null
          ? LogoutResponse.fromMap(json["response"])
          : LogoutResponse.empty(),
      status: json["status"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "response": response.toMap(),
        "status": status,
      };

  factory LogoutModel.empty() => LogoutModel(
        error: false,
        message: null,
        response: LogoutResponse.empty(),
        status: false,
      );

  factory LogoutModel.localSuccess() => LogoutModel(
        error: false,
        message: null,
        response: LogoutResponse(
          code: "Success",
          message: "Logged out successfully from device.",
        ),
        status: true,
      );
}

class LogoutResponse {
  final String code;
  final String message;

  LogoutResponse({
    required this.code,
    required this.message,
  });

  factory LogoutResponse.fromJson(String str) =>
      LogoutResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LogoutResponse.fromMap(Map<String, dynamic> json) {
    return LogoutResponse(
      code: json["code"] ?? "",
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
      };

  factory LogoutResponse.empty() => LogoutResponse(
        code: "",
        message: "",
      );
}
