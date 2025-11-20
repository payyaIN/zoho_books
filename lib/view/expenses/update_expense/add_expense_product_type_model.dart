class AddExpenseProductTypeModel {
  final String type; // 'Claimable' or 'Non-claimable'
  final bool isClaimable;

  AddExpenseProductTypeModel({
    required this.type,
    required this.isClaimable,
  });

  AddExpenseProductTypeModel copyWith({String? type, bool? isClaimable}) {
    return AddExpenseProductTypeModel(
      type: type ?? this.type,
      isClaimable: isClaimable ?? this.isClaimable,
    );
  }
}