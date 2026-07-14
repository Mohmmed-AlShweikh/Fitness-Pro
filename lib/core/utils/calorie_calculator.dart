/// Mifflin-St Jeor BMR & TDEE calculator
abstract class CalorieCalculator {
  static const Map<String, double> _activityMultipliers = {
    'sedentary': 1.2,
    'lightly_active': 1.375,
    'moderately_active': 1.55,
    'very_active': 1.725,
    'extra_active': 1.9,
  };

  /// Calculates Basal Metabolic Rate using Mifflin-St Jeor equation
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender.toLowerCase() == 'male' ? base + 5 : base - 161;
  }

  /// Calculates Total Daily Energy Expenditure
  static double calculateTDEE({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
  }) {
    final bmr = calculateBMR(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
    );
    final multiplier = _activityMultipliers[activityLevel] ?? 1.2;
    return bmr * multiplier;
  }

  /// Returns daily calorie targets for different goals
  static Map<String, int> getCalorieTargets({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
  }) {
    final tdee = calculateTDEE(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
    );
    return {
      'lose_weight': (tdee - 500).round(),
      'maintain': tdee.round(),
      'gain_muscle': (tdee + 300).round(),
    };
  }

  /// Calculates BMI
  static double calculateBMI({
    required double weightKg,
    required double heightCm,
  }) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Returns BMI category
  static String bmiCategory(double bmi) {
    if (bmi < 18.5) return 'bmi_underweight';
    if (bmi < 25.0) return 'bmi_normal';
    if (bmi < 30.0) return 'bmi_overweight';
    return 'bmi_obese';
  }
}
