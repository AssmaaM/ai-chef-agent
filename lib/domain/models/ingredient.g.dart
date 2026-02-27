// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\ingredient.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      id: json['id'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit': instance.unit,
      'quantity': instance.quantity,
    };

IngredientStatus _$IngredientStatusFromJson(Map<String, dynamic> json) =>
    IngredientStatus(
      ingredient:
          Ingredient.fromJson(json['ingredient'] as Map<String, dynamic>),
      availability: $enumDecodeNullable(
              _$IngredientAvailabilityStatusEnumMap, json['availability']) ??
          IngredientAvailabilityStatus.unknown,
      substitution: json['substitution'] == null
          ? null
          : Ingredient.fromJson(json['substitution'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IngredientStatusToJson(IngredientStatus instance) =>
    <String, dynamic>{
      'ingredient': instance.ingredient,
      'availability':
          _$IngredientAvailabilityStatusEnumMap[instance.availability]!,
      'substitution': instance.substitution,
    };

const _$IngredientAvailabilityStatusEnumMap = {
  IngredientAvailabilityStatus.unknown: 'unknown',
  IngredientAvailabilityStatus.available: 'available',
  IngredientAvailabilityStatus.missing: 'missing',
  IngredientAvailabilityStatus.substituting: 'substituting',
  IngredientAvailabilityStatus.substituted: 'substituted',
};
