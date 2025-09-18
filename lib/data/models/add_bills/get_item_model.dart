class Item {
  final int? itemId;
  final String? itemName;
  final double? salesRate;
  final double? costRate;
  final String? salesDescription;
  final String? costDescription;
  final int? unitId;
  final String? hsnOrSac;

  Item({
    this.itemId,
    this.itemName,
    this.salesRate,
    this.costRate,
    this.salesDescription,
    this.costDescription,
    this.unitId,
    this.hsnOrSac,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['itemId'],
      itemName: json['itemName'],
      salesRate: (json['salesRate'] as num?)?.toDouble(),
      costRate: (json['costRate'] as num?)?.toDouble(),
      salesDescription: json['salesDescription'],
      costDescription: json['costDescription'],
      unitId: json['unitId'],
      hsnOrSac: json['hsnOrSac'],
    );
  }
}
