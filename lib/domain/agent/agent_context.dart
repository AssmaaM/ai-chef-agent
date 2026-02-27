//C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\agent\agent_context.dart
import '../models/cooking_session.dart';
import '../models/recipe.dart';
import '../models/user_preferences.dart';

/// Mutable logical context held by the agent FSM.
///
/// NOTE: This is treated immutably by the FSM – transitions always
/// produce a new AgentContext rather than mutating in place.
class AgentContext {
  final UserPreferences? preferences;
  final List<Recipe> suggestedRecipes;
  final Recipe? selectedRecipe;
  final CookingSession? activeSession;
  final int? ingredientCheckIndex;

  const AgentContext({
    this.preferences,
    this.suggestedRecipes = const [],
    this.selectedRecipe,
    this.activeSession,
    this.ingredientCheckIndex,
  });

  AgentContext copyWith({
    UserPreferences? preferences,
    List<Recipe>? suggestedRecipes,
    Recipe? selectedRecipe,
    CookingSession? activeSession,
    int? ingredientCheckIndex,
  }) {
    return AgentContext(
      preferences: preferences ?? this.preferences,
      suggestedRecipes: suggestedRecipes ?? this.suggestedRecipes,
      selectedRecipe: selectedRecipe ?? this.selectedRecipe,
      activeSession: activeSession ?? this.activeSession,
      ingredientCheckIndex: ingredientCheckIndex ?? this.ingredientCheckIndex,
    );
  }

  AgentContext clearSession() {
    return AgentContext(
      preferences: preferences,
    );
  }
}

