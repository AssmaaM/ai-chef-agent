
/// Sensitive capabilities the application can exercise on behalf of the user.
///
/// The agent core NEVER executes these directly – it only emits high-level
/// actions, and the application/infra layers check capabilities + permissions.
enum Capability {
  useLlm,
  fetchRecipesFromApi,
  cacheRecipes,
  openGroceryApp,
  assistOrderPlacement,
  setOsAlarms,
  setInAppTimers,
}

