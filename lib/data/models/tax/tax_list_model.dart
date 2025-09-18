import 'dart:convert';

class GetTaxListModel {
  final bool error;
  final String message;
  final TaxListResponse response;
  final bool status;

  GetTaxListModel({
    required this.error,
    required this.message,
    required this.response,
    required this.status,
  });

  factory GetTaxListModel.fromJson(String str) =>
      GetTaxListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetTaxListModel.fromMap(Map<String, dynamic> json) {
    print('GetTaxListModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    return GetTaxListModel(
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      response: json["response"] != null && json["response"] is Map
          ? TaxListResponse.fromMap(Map<String, dynamic>.from(json["response"]))
          : TaxListResponse.empty(),
      status: json["status"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "response": response.toMap(),
        "status": status,
      };

  factory GetTaxListModel.empty() => GetTaxListModel(
        error: false,
        message: "",
        response: TaxListResponse.empty(),
        status: false,
      );
}

class TaxListResponse {
  final List<IGSTTax> igstTax;
  final List<dynamic> customTax;
  final List<dynamic> taxGroup;

  TaxListResponse({
    required this.igstTax,
    required this.customTax,
    required this.taxGroup,
  });

  factory TaxListResponse.fromJson(String str) =>
      TaxListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaxListResponse.fromMap(Map<String, dynamic> json) {
    print('TaxListResponse.fromMap - Processing response data');

    List<dynamic> igstTaxList = [];
    List<dynamic> customTaxList = [];
    List<dynamic> taxGroupList = [];

    if (json.containsKey("IGSTTax")) {
      if (json["IGSTTax"] is List) {
        igstTaxList = json["IGSTTax"] as List;
        print('Found ${igstTaxList.length} IGSTTax items in response');
      } else {
        print('Warning: "IGSTTax" is not a List');
      }
    } else {
      print('Warning: No "IGSTTax" key found');
    }

    if (json.containsKey("customTax")) {
      if (json["customTax"] is List) {
        customTaxList = json["customTax"] as List;
        print('Found ${customTaxList.length} customTax items in response');
      } else {
        print('Warning: "customTax" is not a List');
      }
    } else {
      print('Warning: No "customTax" key found');
    }

    if (json.containsKey("taxGroup")) {
      if (json["taxGroup"] is List) {
        taxGroupList = json["taxGroup"] as List;
        print('Found ${taxGroupList.length} taxGroup items in response');
      } else {
        print('Warning: "taxGroup" is not a List');
      }
    } else {
      print('Warning: No "taxGroup" key found');
    }

    return TaxListResponse(
      igstTax: List<IGSTTax>.from(igstTaxList.map((x) {
        if (x is Map) {
          return IGSTTax.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: IGSTTax item is not a Map');
          return IGSTTax.empty();
        }
      })),
      customTax: customTaxList,
      taxGroup: taxGroupList,
    );
  }

  Map<String, dynamic> toMap() => {
        "IGSTTax": List<dynamic>.from(igstTax.map((x) => x.toMap())),
        "customTax": List<dynamic>.from(customTax.map((x) => x)),
        "taxGroup": List<dynamic>.from(taxGroup.map((x) => x)),
      };

  factory TaxListResponse.empty() => TaxListResponse(
        igstTax: [],
        customTax: [],
        taxGroup: [],
      );
}

class IGSTTax {
  final int tcdTaxId;
  final String tcdTaxName;
  final int tcdTaxType;
  final double tcdTaxRate;
  final int tcdAtive;
  final int tcdCompanyId;
  final int tcdIsCustom;
  final int tcdIsCountryDefault;

  IGSTTax({
    required this.tcdTaxId,
    required this.tcdTaxName,
    required this.tcdTaxType,
    required this.tcdTaxRate,
    required this.tcdAtive,
    required this.tcdCompanyId,
    required this.tcdIsCustom,
    required this.tcdIsCountryDefault,
  });

  factory IGSTTax.fromJson(String str) => IGSTTax.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IGSTTax.fromMap(Map<String, dynamic> json) {
    return IGSTTax(
      tcdTaxId: json["tcdTaxId"] ?? 0,
      tcdTaxName: json["tcdTaxName"] ?? "",
      tcdTaxType: json["tcdTaxType"] ?? 0,
      tcdTaxRate: _parseDouble(json["tcdTaxRate"]),
      tcdAtive: json["tcdAtive"] ?? 0,
      tcdCompanyId: json["tcdCompanyId"] ?? 0,
      tcdIsCustom: json["tcdIsCustom"] ?? 0,
      tcdIsCountryDefault: json["tcdIsCountryDefault"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "tcdTaxId": tcdTaxId,
        "tcdTaxName": tcdTaxName,
        "tcdTaxType": tcdTaxType,
        "tcdTaxRate": tcdTaxRate,
        "tcdAtive": tcdAtive,
        "tcdCompanyId": tcdCompanyId,
        "tcdIsCustom": tcdIsCustom,
        "tcdIsCountryDefault": tcdIsCountryDefault,
      };

  factory IGSTTax.empty() => IGSTTax(
        tcdTaxId: 0,
        tcdTaxName: "",
        tcdTaxType: 0,
        tcdTaxRate: 0.0,
        tcdAtive: 0,
        tcdCompanyId: 0,
        tcdIsCustom: 0,
        tcdIsCountryDefault: 0,
      );
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (_) {
      return 0.0;
    }
  }
  return 0.0;
}
