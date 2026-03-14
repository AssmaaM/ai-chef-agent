import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/recipe.dart';
import 'recipe_api_client.dart';

class FreeRecipeApiClient implements RecipeApiClient {
  final String endpoint;

  FreeRecipeApiClient(this.endpoint);

  @override
  Future<List<Recipe>> searchRecipes({
    required String query,
    Map<String, Object?> constraints = const {},
  }) async {
    try {
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': query,
          'constraints': constraints,
        }),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body)['recipes'] ?? [];
        return data.map((r) => Recipe.fromJson(r)).toList();
      }
      return [];
    } catch (e) {
      // Log or handle error
      return [];
    }
  }
}
