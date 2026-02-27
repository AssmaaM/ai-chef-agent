// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\infrastructure\os\timer_service.dart
import '../../domain/models/cooking_timer.dart';

/// Abstraction over in-app timers and OS-level alarms / notifications.
///
/// The agent core only manipulates CookingTimer objects; this service
/// maps them to actual platform timers and ensures they survive
/// background / app restarts where possible.
abstract class TimerService {
  Future<void> scheduleTimer(CookingTimer timer);

  Future<void> cancelTimer(String timerId);
}

