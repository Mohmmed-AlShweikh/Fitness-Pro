/// Pre-built exercise library grouped by category.
/// Each entry is a plain exercise name the user can pick.
abstract class ExerciseLibrary {
  static const Map<String, List<String>> byCategory = {
    'chest': [
      'Bench Press',
      'Incline Bench Press',
      'Decline Bench Press',
      'Dumbbell Flyes',
      'Cable Crossover',
      'Push-Up',
      'Chest Dip',
      'Pec Deck Machine',
      'Dumbbell Pullover',
    ],
    'back': [
      'Pull-Up',
      'Lat Pulldown',
      'Barbell Row',
      'Dumbbell Row',
      'Seated Cable Row',
      'Deadlift',
      'Romanian Deadlift',
      'Face Pull',
      'Shrug',
      'Hyperextension',
    ],
    'legs': [
      'Barbell Squat',
      'Goblet Squat',
      'Leg Press',
      'Leg Extension',
      'Leg Curl',
      'Lunge',
      'Bulgarian Split Squat',
      'Calf Raise',
      'Glute Bridge',
      'Hip Thrust',
    ],
    'arms': [
      'Barbell Curl',
      'Dumbbell Curl',
      'Hammer Curl',
      'Preacher Curl',
      'Tricep Dip',
      'Skull Crusher',
      'Overhead Tricep Extension',
      'Tricep Pushdown',
      'Close-Grip Bench Press',
      'Wrist Curl',
    ],
    'cardio': [
      'Running',
      'Cycling',
      'Jump Rope',
      'Rowing Machine',
      'Elliptical',
      'Stair Climber',
      'Box Jump',
      'Burpee',
      'Mountain Climber',
      'High Knees',
    ],
    'full_body': [
      'Clean and Press',
      'Thruster',
      'Turkish Get-Up',
      'Kettlebell Swing',
      'Bear Crawl',
      'Farmer Carry',
      'Battle Rope',
      'Sled Push',
      'Pull-Up to Dip',
      'Man Maker',
    ],
  };

  static List<String> forCategory(String category) =>
      byCategory[category] ?? [];

  static List<String> search(String query, String category) {
    final pool = category == 'all'
        ? byCategory.values.expand((e) => e).toList()
        : forCategory(category);
    if (query.isEmpty) return pool;
    final q = query.toLowerCase();
    return pool.where((e) => e.toLowerCase().contains(q)).toList();
  }
}
