class TaxResponse {
  final List<TaxInfo> others;
  final List<TaxGroup> taxGroup;
  final List<CustomTax> customTax;
  final List<DefaultTax> defaultTax;

  TaxResponse({
    required this.others,
    required this.taxGroup,
    required this.customTax,
    required this.defaultTax,
  });

  factory TaxResponse.fromJson(Map<String, dynamic> json) {
    return TaxResponse(
      others: List<TaxInfo>.from(json['Others'].map((x) => TaxInfo.fromJson(x))),
      taxGroup: List<TaxGroup>.from(json['TaxGroup'].map((x) => TaxGroup.fromJson(x))),
      customTax: List<CustomTax>.from(json['CustomTax'].map((x) => CustomTax.fromJson(x))),
      defaultTax: List<DefaultTax>.from(json['DefaultTax'].map((x) => DefaultTax.fromJson(x))),
    );
  }
}

class TaxInfo {
  final int taxId;
  final String taxType;
  final String taxName;

  TaxInfo({
    required this.taxId,
    required this.taxType,
    required this.taxName,
  });

  factory TaxInfo.fromJson(Map<String, dynamic> json) {
    return TaxInfo(
      taxId: json['taxId'],
      taxType: json['taxType'],
      taxName: json['taxName'],
    );
  }
}

class TaxGroup {
  // Assuming empty structure for now
  TaxGroup();

  factory TaxGroup.fromJson(Map<String, dynamic> json) {
    return TaxGroup(); // Update if structure is known
  }
}

class CustomTax {
  // Assuming empty structure for now
  CustomTax();

  factory CustomTax.fromJson(Map<String, dynamic> json) {
    return CustomTax(); // Update if structure is known
  }
}

class DefaultTax {
  final int tcdAtive;
  final int tcdIsCustom;
  final double tcdTaxRate;
  final int tcdTaxId;
  final String tcdTaxName;
  final int tcdIsCountryDefault;
  final int taxId;
  final int tcdTaxType;
  final String taxName;
  final String taxType;
  final int tcdCompanyId;

  DefaultTax({
    required this.tcdAtive,
    required this.tcdIsCustom,
    required this.tcdTaxRate,
    required this.tcdTaxId,
    required this.tcdTaxName,
    required this.tcdIsCountryDefault,
    required this.taxId,
    required this.tcdTaxType,
    required this.taxName,
    required this.taxType,
    required this.tcdCompanyId,
  });

  factory DefaultTax.fromJson(Map<String, dynamic> json) {
    return DefaultTax(
      tcdAtive: json['tcdAtive'],
      tcdIsCustom: json['tcdIsCustom'],
      tcdTaxRate: (json['tcdTaxRate'] as num).toDouble(),
      tcdTaxId: json['tcdTaxId'],
      tcdTaxName: json['tcdTaxName'],
      tcdIsCountryDefault: json['tcdIsCountryDefault'],
      taxId: json['taxId'],
      tcdTaxType: json['tcdTaxType'],
      taxName: json['taxName'],
      taxType: json['taxType'],
      tcdCompanyId: json['tcdCompanyId'],
    );
  }
}
