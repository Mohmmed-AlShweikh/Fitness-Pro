class ProgressModel {
  int id;
  double weight;
  double? bodyFat;
  String? notes;
  DateTime date;

  ProgressModel({
    this.id = 0,
    required this.weight,
    this.bodyFat,
    this.notes,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'weight': weight,
        'bodyFat': bodyFat,
        'notes': notes,
        'date': date.toIso8601String(),
      };

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
        id: (json['id'] as int?) ?? 0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0,
        bodyFat: (json['bodyFat'] as num?)?.toDouble(),
        notes: json['notes'] as String?,
        date: json['date'] != null
            ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}
