class Unit {
  final int unitId;
  final String displayUnit;
  final String? groupName;

  Unit({
    required this.unitId,
    required this.displayUnit,
    this.groupName,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unitId: json['unitId'],
      displayUnit: json['displayUnit'],
      groupName: json['groupName'],
    );
  }
}
