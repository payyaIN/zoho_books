class RejectModel {
  final String code;
  final String message;
  final dynamic details;

  RejectModel({
    required this.code,
    required this.message,
    this.details,
  });

  factory RejectModel.fromMap(Map<String, dynamic> json) {
    print('RejectModel.fromMap - Processing response');

    return RejectModel(
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

  factory RejectModel.empty() => RejectModel(
        code: "",
        message: "",
      );

  bool get isSuccess => code.toUpperCase() == 'SUCCESS';
}
