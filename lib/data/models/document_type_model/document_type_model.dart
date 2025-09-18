class DocumentTypeModel {
  final String label;
  final int value;

  DocumentTypeModel({required this.label, required this.value});

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
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
