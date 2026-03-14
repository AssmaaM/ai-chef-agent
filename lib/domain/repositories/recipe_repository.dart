import '../models/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> searchRecipes(String query, {Map<String, Object?> constraints = const {}});
  Future<void> cacheRecipes(List<Recipe> recipes);
  Future<List<Recipe>> getCachedRecipes();
}
