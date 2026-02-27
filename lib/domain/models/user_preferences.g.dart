// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\user_preferences.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      id: json['id'] as String,
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      targetCaloriesPerMeal: (json['targetCaloriesPerMeal'] as num?)?.toInt(),
      dislikedIngredients: (json['dislikedIngredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferredGroceryAppScheme: json['preferredGroceryAppScheme'] as String?,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'targetCaloriesPerMeal': instance.targetCaloriesPerMeal,
      'dislikedIngredients': instance.dislikedIngredients,
      'preferredGroceryAppScheme': instance.preferredGroceryAppScheme,
    };
