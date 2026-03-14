// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\agent\agent_event.dart
/// Source of an event – used to enforce rules such as
/// "voice alone cannot grant sensitive permissions" (unless explicitly
/// allowed and capability-gated in the application layer).
enum EventSource {
  ui,
  voice,
  system,
}

/// Types of events the agent can handle.
///
/// These are intentionally explicit so all transitions are traceable.
enum AgentEventType {
  // High-level user intents
  userStartedSession,
  userRequestedMealSuggestions,
  userSelectedRecipe,
  userCancelled,

  // Ingredient availability flow
  userAnsweredIngredientAvailability,
  userAcceptedSubstitution,
  userRejectedSubstitution,

  // Ordering flow
  userRequestedOrderingAssistance,
  userConfirmedOrderingAssistance,
  userDeclinedOrderingAssistance,

  // Cooking flow
  userReadyToPrepare,
  userReadyForNextStep,
  userConfirmedStepCompleted,
  userPutDishInOven,

  // Timers
  timerStarted,
  timerStartedManually,
  timerFired,
  timerCancelled,

  // System / infra events
  recipesSuggested,
  recipesFailed,
  substitutionsSuggested,
  substitutionsFailed,
  errorOccurred,

  // Confirmation flow
  userConfirmedAction,
  userCancelledAction,
}

class AgentEvent {
  final AgentEventType type;
  final EventSource source;
  final Map<String, Object?> payload;

  const AgentEvent({
    required this.type,
    required this.source,
    this.payload = const {},
  });
}

