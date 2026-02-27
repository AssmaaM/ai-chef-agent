/// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\agent\agent_action.dart
/// High-level actions the agent can request.
///
/// IMPORTANT:
/// - These are NOT OS calls.
/// - The application/infrastructure layers interpret these into concrete effects.
/// - This keeps the agent core deterministic and side-effect free.
enum AgentActionType {
  // User-facing prompts & messages
  sendChatMessage,
  askForIngredientAvailability,
  presentRecipeSuggestions,
  presentRecipeDetails,
  presentMissingIngredients,

  // External reasoning helpers (LLM)
  callLlmForRecipeSuggestions,
  callLlmForSubstitutions,

  // External APIs (guarded by capabilities)
  fetchRecipesFromApi,
  estimateGroceryCost,
  assistOpeningGroceryApp,

  // Timers / alarms (in-app + OS)
  scheduleCookingTimer,
  cancelCookingTimer,

  // Persistence
  persistCookingSession,
  cacheRecipes,
}

/// Data associated with an action, kept generic to remain in the domain layer.
class AgentAction {
  final AgentActionType type;
  final Map<String, Object?> payload;

  const AgentAction({
    required this.type,
    this.payload = const {},
  });
}

