// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\cooking_timer.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookingTimer _$CookingTimerFromJson(Map<String, dynamic> json) => CookingTimer(
      id: json['id'] as String,
      label: json['label'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      active: json['active'] as bool? ?? true,
    );

Map<String, dynamic> _$CookingTimerToJson(CookingTimer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'startTime': instance.startTime.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
      'active': instance.active,
    };
