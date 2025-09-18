class ApproveModel {
  final String code;
  final String message;
  final dynamic details;

  ApproveModel({
    required this.code,
    required this.message,
    this.details,
  });

  factory ApproveModel.fromMap(Map<String, dynamic> json) {
    print('ApproveModel.fromMap - Processing response');

    return ApproveModel(
      code: json["code"] ?? "",
      message: json["message"] ?? "",
      details: json["details"],
    );
  }

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "details": details,
      };

  factory ApproveModel.empty() => ApproveModel(
        code: "",
        message: "",
      );

  bool get isSuccess => code.toUpperCase() == 'SUCCESS';
}
