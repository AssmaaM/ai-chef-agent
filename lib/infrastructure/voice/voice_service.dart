// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\infrastructure\voice\voice_service.dart
/// Abstraction for voice I/O (speech-to-text and text-to-speech).
///
/// NOTE: The security model is enforced at the application layer.
/// Voice can be used for queries, navigation, and starting timers,
/// but permission granting and sensitive actions must be gated
/// by explicit capability checks and, where appropriate, UI confirmation.
abstract class VoiceService {
  Future<void> init();

  Stream<String> startListening();

  Future<void> stopListening();

  Future<void> speak(String text);
}

