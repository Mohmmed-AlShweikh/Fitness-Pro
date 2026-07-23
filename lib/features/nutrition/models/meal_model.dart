class MealModel {
  int id;
  String name;
  int calories;
  double protein;
  double carbs;
  double fat;
  String mealType; // breakfast, lunch, dinner, snack
  DateTime date;

  MealModel({
    this.id = 0,
    required this.name,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.mealType = 'snack',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'mealType': mealType,
        'date': date.toIso8601String(),
      };

  factory MealModel.fromJson(Map<String, dynamic> j) => MealModel(
        id: j['id'] as int? ?? 0,
        name: j['name'] as String? ?? '',
        calories: j['calories'] as int? ?? 0,
        protein: (j['protein'] as num?)?.toDouble() ?? 0,
        carbs: (j['carbs'] as num?)?.toDouble() ?? 0,
        fat: (j['fat'] as num?)?.toDouble() ?? 0,
        mealType: j['mealType'] as String? ?? 'snack',
        date: DateTime.parse(j['date'] as String? ?? DateTime.now().toIso8601String()),
      );
}
