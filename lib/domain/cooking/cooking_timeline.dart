import '../models/cooking_timer.dart';
class CookingTimeline {
  final List<CookingTimer> timers;

  CookingTimeline(this.timers);

  CookingTimer? nextActiveTimer() {
    final now = DateTime.now();
    return timers
        .where((t) => t.active)
        .where((t) => t.expectedEndTime.isAfter(now))
        .reduce((a, b) =>
            a.expectedEndTime.isBefore(b.expectedEndTime) ? a : b);
  }
}
