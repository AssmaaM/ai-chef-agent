// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\infrastructure\llm\llm_client.dart
/// Minimal interface for free LLM usage as a reasoning assistant.
///
/// IMPORTANT:
/// - This client must NEVER execute actions, confirm payments, or trigger OS services.
/// - Responses must be structured (JSON when possible) and validated by the agent.
abstract class LlmClient {
  /// Suggest recipes given constraints (diet, calories, preferences).
  ///
  /// The return value should be JSON-serializable and later mapped
  /// to domain Recipe models by the application layer.
  Future<Map<String, Object?>> suggestRecipes({
    required String userQuery,
    required Map<String, Object?> constraints,
  });

  /// Suggest ingredient substitutions.
  ///
  /// The return value must be validated logically by domain logic
  /// before accepting any substitution.
  Future<Map<String, Object?>> suggestSubstitutions({
    required Map<String, Object?> missingIngredient,
    required Map<String, Object?> recipeContext,
  });
}

