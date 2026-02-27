// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\ingredient.dart
import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

enum IngredientAvailabilityStatus {
  unknown,
  available,
  missing,
  substituting,
  substituted,
}

@JsonSerializable()
class Ingredient {
  final String id;
  final String name;
  final String unit; // e.g. "g", "ml", "piece"
  final double quantity;

  const Ingredient({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}

/// Tracks per-ingredient availability and any chosen substitution.
@JsonSerializable()
class IngredientStatus {
  final Ingredient ingredient;
  final IngredientAvailabilityStatus availability;
  final Ingredient? substitution;

  const IngredientStatus({
    required this.ingredient,
    this.availability = IngredientAvailabilityStatus.unknown,
    this.substitution,
  });

  IngredientStatus copyWith({
    Ingredient? ingredient,
    IngredientAvailabilityStatus? availability,
    Ingredient? substitution,
  }) {
    return IngredientStatus(
      ingredient: ingredient ?? this.ingredient,
      availability: availability ?? this.availability,
      substitution: substitution ?? this.substitution,
    );
  }

  factory IngredientStatus.fromJson(Map<String, dynamic> json) =>
      _$IngredientStatusFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientStatusToJson(this);
}

