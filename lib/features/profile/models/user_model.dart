class UserModel {
  int id;
  String name;
  int age;
  double height; // cm
  double weight; // kg
  String gender; // 'male' / 'female'
  String activityLevel;
  String fitnessGoal;

  UserModel({
    this.id = 1,
    this.name = '',
    this.age = 25,
    this.height = 170.0,
    this.weight = 70.0,
    this.gender = 'male',
    this.activityLevel = 'moderate',
    this.fitnessGoal = 'maintain',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'height': height,
        'weight': weight,
        'gender': gender,
        'activityLevel': activityLevel,
        'fitnessGoal': fitnessGoal,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] as int?) ?? 1,
        name: (json['name'] as String?) ?? '',
        age: (json['age'] as int?) ?? 25,
        height: (json['height'] as num?)?.toDouble() ?? 170.0,
        weight: (json['weight'] as num?)?.toDouble() ?? 70.0,
        gender: (json['gender'] as String?) ?? 'male',
        activityLevel: (json['activityLevel'] as String?) ?? 'moderate',
        fitnessGoal: (json['fitnessGoal'] as String?) ?? 'maintain',
      );
}
