// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\recipe.dart
import 'package:json_annotation/json_annotation.dart';

import 'ingredient.dart';

part 'recipe.g.dart';

@JsonSerializable()
class RecipeStep {
  final int index;
  final String instruction;
  final int? suggestedSeconds; // optional, used for timers (e.g. baking time)

  const RecipeStep({
    required this.index,
    required this.instruction,
    this.suggestedSeconds,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeStepToJson(this);
}

@JsonSerializable()
class Recipe {
  final String id;
  final String title;
  final String? imageUrl;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;
  final int totalCalories; // approximate is acceptable
  final int totalTimeSeconds; // cooking time in seconds (approximate)
  final List<String> tags; // diet, cuisine, etc.

  const Recipe({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.totalCalories,
    required this.totalTimeSeconds,
    this.tags = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}

