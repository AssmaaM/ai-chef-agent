// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\cooking_session.dart
import 'package:json_annotation/json_annotation.dart';

import 'cooking_timer.dart';
import 'ingredient.dart';
import 'recipe.dart';

part 'cooking_session.g.dart';

@JsonSerializable()
class CookingSession {
  final String id;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final Recipe recipe;
  final List<IngredientStatus> ingredientStatuses;
  final int currentStepIndex;
  final List<CookingTimer> timers;

  const CookingSession({
    required this.id,
    required this.startedAt,
    this.finishedAt,
    required this.recipe,
    required this.ingredientStatuses,
    this.currentStepIndex = 0,
    this.timers = const [],
  });

  CookingSession copyWith({
    DateTime? finishedAt,
    List<IngredientStatus>? ingredientStatuses,
    int? currentStepIndex,
    List<CookingTimer>? timers,
  }) {
    return CookingSession(
      id: id,
      startedAt: startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      recipe: recipe,
      ingredientStatuses: ingredientStatuses ?? this.ingredientStatuses,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      timers: timers ?? this.timers,
    );
  }

  factory CookingSession.fromJson(Map<String, dynamic> json) =>
      _$CookingSessionFromJson(json);

  Map<String, dynamic> toJson() => _$CookingSessionToJson(this);
}

