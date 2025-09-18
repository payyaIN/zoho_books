class GetPriceCurrency {
  GetPriceCurrency({
      this.currencyValue, 
      this.currencyId, 
      this.countryId,});

  GetPriceCurrency.fromJson(dynamic json) {
    currencyValue = json['currencyValue'];
    currencyId = json['currencyId'];
    countryId = json['countryId'];
  }
  String? currencyValue;
  num? currencyId;
  num? countryId;
GetPriceCurrency copyWith({  String? currencyValue,
  num? currencyId,
  num? countryId,
}) => GetPriceCurrency(  currencyValue: currencyValue ?? this.currencyValue,
  currencyId: currencyId ?? this.currencyId,
  countryId: countryId ?? this.countryId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currencyValue'] = currencyValue;
    map['currencyId'] = currencyId;
    map['countryId'] = countryId;
    return map;
  }

}