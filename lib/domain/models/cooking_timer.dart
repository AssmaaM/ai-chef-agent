// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\models\cooking_timer.dart
import 'package:json_annotation/json_annotation.dart';

part 'cooking_timer.g.dart';

/// Logical representation of a cooking timer.
///
/// The infrastructure layer is responsible for mapping this to
/// OS-level alarms or in-app notifications.
@JsonSerializable()
class CookingTimer {
  final String id;
  final String label;
  final DateTime startTime;
  final int durationSeconds;
  final bool active;

  const CookingTimer({
    required this.id,
    required this.label,
    required this.startTime,
    required this.durationSeconds,
    this.active = true,
  });

  DateTime get expectedEndTime =>
      startTime.add(Duration(seconds: durationSeconds));

  factory CookingTimer.fromJson(Map<String, dynamic> json) =>
      _$CookingTimerFromJson(json);

  Map<String, dynamic> toJson() => _$CookingTimerToJson(this);
}

