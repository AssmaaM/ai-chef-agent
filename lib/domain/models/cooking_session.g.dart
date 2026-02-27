// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\cooking_session.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookingSession _$CookingSessionFromJson(Map<String, dynamic> json) =>
    CookingSession(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      finishedAt: json['finishedAt'] == null
          ? null
          : DateTime.parse(json['finishedAt'] as String),
      recipe: Recipe.fromJson(json['recipe'] as Map<String, dynamic>),
      ingredientStatuses: (json['ingredientStatuses'] as List<dynamic>)
          .map((e) => IngredientStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentStepIndex: (json['currentStepIndex'] as num?)?.toInt() ?? 0,
      timers: (json['timers'] as List<dynamic>?)
              ?.map((e) => CookingTimer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CookingSessionToJson(CookingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startedAt': instance.startedAt.toIso8601String(),
      'finishedAt': instance.finishedAt?.toIso8601String(),
      'recipe': instance.recipe,
      'ingredientStatuses': instance.ingredientStatuses,
      'currentStepIndex': instance.currentStepIndex,
      'timers': instance.timers,
    };
