class GoalModel {
  int id;
  String title;
  double target;
  double current;
  String unit;
  String type;
  bool completed;
  DateTime startDate;
  DateTime? targetDate;

  GoalModel({
    this.id = 0,
    this.title = '',
    this.target = 100,
    this.current = 0,
    this.unit = 'kg',
    this.type = 'weight',
    this.completed = false,
    DateTime? startDate,
    this.targetDate,
  }) : startDate = startDate ?? DateTime.now();

  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'target': target,
        'current': current,
        'unit': unit,
        'type': type,
        'completed': completed,
        'startDate': startDate.toIso8601String(),
        'targetDate': targetDate?.toIso8601String(),
      };

  factory GoalModel.fromJson(Map<String, dynamic> json) => GoalModel(
        id: (json['id'] as int?) ?? 0,
        title: (json['title'] as String?) ?? '',
        target: (json['target'] as num?)?.toDouble() ?? 100,
        current: (json['current'] as num?)?.toDouble() ?? 0,
        unit: (json['unit'] as String?) ?? 'kg',
        type: (json['type'] as String?) ?? 'weight',
        completed: (json['completed'] as bool?) ?? false,
        startDate: json['startDate'] != null
            ? DateTime.tryParse(json['startDate'] as String) ?? DateTime.now()
            : DateTime.now(),
        targetDate: json['targetDate'] != null
            ? DateTime.tryParse(json['targetDate'] as String)
            : null,
      );
}
