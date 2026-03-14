import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../recipe/recipe_api_client.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeApiClient _apiClient;
  final Database _db;

  RecipeRepositoryImpl(this._apiClient, this._db);

  @override
  Future<List<Recipe>> searchRecipes(String query, {Map<String, Object?> constraints = const {}}) async {
    // Try API first
    try {
      final recipes = await _apiClient.searchRecipes(query: query, constraints: constraints);
      await cacheRecipes(recipes);
      return recipes;
    } catch (e) {
      // Fallback to cache
      return getCachedRecipes();
    }
  }

  @override
  Future<void> cacheRecipes(List<Recipe> recipes) async {
    final batch = _db.batch();
    for (final recipe in recipes) {
      batch.insert(
        'recipes',
        {'id': recipe.id, 'data': jsonEncode(recipe.toJson())},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Recipe>> getCachedRecipes() async {
    final List<Map<String, dynamic>> maps = await _db.query('recipes');
    return maps.map((m) => Recipe.fromJson(jsonDecode(m['data']))).toList();
  }
}
