// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\infrastructure\recipe\recipe_api_client.dart
import '../../domain/models/recipe.dart';

/// Client for free recipe/nutrition APIs.
///
/// Concrete implementation should:
/// - Use only free endpoints / tiers.
/// - Include ingredients with quantities, calories, instructions, and times.
/// - Normalize responses into domain Recipe models.
/// - Cache results locally (SQLite) via repositories.
abstract class RecipeApiClient {
  Future<List<Recipe>> searchRecipes({
    required String query,
    Map<String, Object?> constraints = const {},
  });
}

