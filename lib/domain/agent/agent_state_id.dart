/// Core agent states (deterministic, finite set).
/// Additional detail (e.g. which ingredient index we are on) lives in AgentContext.
enum AgentStateId {
  idle,
  suggestingRecipes,
  recipeSelected,
  checkingIngredients,
  substitutingIngredients,
  orderingIngredients,
  cookingPreparation,
  cookingStep,
  timerRunning,
  finished,
  error,
  awaitingConfirmation,
}

