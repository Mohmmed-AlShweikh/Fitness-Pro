class ExerciseModel {
  String name;
  int sets;
  int reps;
  double weight;

  ExerciseModel({
    this.name = '',
    this.sets = 3,
    this.reps = 10,
    this.weight = 0,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sets': sets,
        'reps': reps,
        'weight': weight,
      };

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        name: (json['name'] as String?) ?? '',
        sets: (json['sets'] as int?) ?? 3,
        reps: (json['reps'] as int?) ?? 10,
        weight: (json['weight'] as num?)?.toDouble() ?? 0,
      );
}

class WorkoutModel {
  int id;
  String title;
  String category;
  int duration; // minutes
  int calories;
  DateTime date;
  List<ExerciseModel> exercises;

  WorkoutModel({
    this.id = 0,
    this.title = '',
    this.category = 'chest',
    this.duration = 30,
    this.calories = 200,
    DateTime? date,
    List<ExerciseModel>? exercises,
  })  : date = date ?? DateTime.now(),
        exercises = exercises ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'duration': duration,
        'calories': calories,
        'date': date.toIso8601String(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
        id: (json['id'] as int?) ?? 0,
        title: (json['title'] as String?) ?? '',
        category: (json['category'] as String?) ?? 'chest',
        duration: (json['duration'] as int?) ?? 30,
        calories: (json['calories'] as int?) ?? 200,
        date: json['date'] != null
            ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
            : DateTime.now(),
        exercises: (json['exercises'] as List<dynamic>?)
                ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
