// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\user_preferences.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_preferences.g.dart';

@JsonSerializable()
class UserPreferences {
  final String id;
  final List<String> dietaryRestrictions; // e.g. "vegan", "gluten_free"
  final int? targetCaloriesPerMeal;
  final List<String> dislikedIngredients;
  final String? preferredGroceryAppScheme; // user-chosen grocery app deeplink scheme

  const UserPreferences({
    required this.id,
    this.dietaryRestrictions = const [],
    this.targetCaloriesPerMeal,
    this.dislikedIngredients = const [],
    this.preferredGroceryAppScheme,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}

