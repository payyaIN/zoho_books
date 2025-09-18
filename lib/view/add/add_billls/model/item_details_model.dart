class ItemDetail {
  final int? prodId;
  final int? prodCatId;
  final String? itemName;
  final String? account;
  final int? quantity;
  final String? unitType;
  final String? rateDate; // ✅ changed to String
  final String? taxType;
  final String? customerDate; // ✅ changed to String
  final double? amount;
  final String? description;
  final String? exemptionReason;
  final String? taxDescription;
  final String? othersDescription;
  final int? unitId;
  final int? customerId;
  final double? taxAmount;
  final double? discountAmount;
  final double? discountPercentage;
  final double? othersAmount;
  final double? percentage;

  const ItemDetail({
    this.prodId,
    this.prodCatId,
    this.itemName,
    this.account,
    this.quantity,
    this.unitType,
    this.rateDate, // ✅ updated
    this.taxType,
    this.customerDate, // ✅ updated
    this.amount,
    this.description,
    this.exemptionReason,
    this.taxDescription,
    this.othersDescription,
    this.unitId,
    this.customerId,
    this.taxAmount,
    this.discountAmount,
    this.discountPercentage,
    this.othersAmount,
    this.percentage,
  });

  ItemDetail copyWith({
    int? prodId,
    int? prodCatId,
    String? itemName,
    String? account,
    int? quantity,
    String? unitType,
    String? rateDate, // ✅ updated
    String? taxType,
    String? customerDate, // ✅ updated
    double? amount,
    String? description,
    String? exemptionReason,
    String? taxDescription,
    String? othersDescription,
    int? unitId,
    int? customerId,
    double? taxAmount,
    double? discountAmount,
    double? discountPercentage,
    double? othersAmount,
    double? percentage,
  }) {
    return ItemDetail(
      prodId: prodId ?? this.prodId,
      prodCatId: prodCatId ?? this.prodCatId,
      itemName: itemName ?? this.itemName,
      account: account ?? this.account,
      quantity: quantity ?? this.quantity,
      unitType: unitType ?? this.unitType,
      rateDate: rateDate ?? this.rateDate, // ✅ updated
      taxType: taxType ?? this.taxType,
      customerDate: customerDate ?? this.customerDate, // ✅ updated
      amount: amount ?? this.amount,
      description: description ?? this.description,
      exemptionReason: exemptionReason ?? this.exemptionReason,
      taxDescription: taxDescription ?? this.taxDescription,
      othersDescription: othersDescription ?? this.othersDescription,
      unitId: unitId ?? this.unitId,
      customerId: customerId ?? this.customerId,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      othersAmount: othersAmount ?? this.othersAmount,
      percentage: percentage ?? this.percentage,
    );
  }
}
