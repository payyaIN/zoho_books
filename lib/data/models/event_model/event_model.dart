class EventModel {
  final String label;
  final int value;

  EventModel({required this.label, required this.value});

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}
