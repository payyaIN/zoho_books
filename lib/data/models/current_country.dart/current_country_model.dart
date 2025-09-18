import 'dart:convert';

class GetCurrentCountryModel {
  final int countryCode;

  GetCurrentCountryModel({
    required this.countryCode,
  });

  factory GetCurrentCountryModel.fromJson(String str) =>
      GetCurrentCountryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCurrentCountryModel.fromMap(Map<String, dynamic> json) {
    print('GetCurrentCountryModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    return GetCurrentCountryModel(
      countryCode: json["countryCode"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "countryCode": countryCode,
      };

  factory GetCurrentCountryModel.empty() => GetCurrentCountryModel(
        countryCode: 0,
      );
}
