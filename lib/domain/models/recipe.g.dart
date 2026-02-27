// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\recipe.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeStep _$RecipeStepFromJson(Map<String, dynamic> json) => RecipeStep(
      index: (json['index'] as num).toInt(),
      instruction: json['instruction'] as String,
      suggestedSeconds: (json['suggestedSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecipeStepToJson(RecipeStep instance) =>
    <String, dynamic>{
      'index': instance.index,
      'instruction': instance.instruction,
      'suggestedSeconds': instance.suggestedSeconds,
    };

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['totalCalories'] as num).toInt(),
      totalTimeSeconds: (json['totalTimeSeconds'] as num).toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'totalCalories': instance.totalCalories,
      'totalTimeSeconds': instance.totalTimeSeconds,
      'tags': instance.tags,
    };
