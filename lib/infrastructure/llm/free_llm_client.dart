import 'dart:convert';
import 'package:http/http.dart' as http;
import 'llm_client.dart';

class FreeLlmClient implements LlmClient {
  final String endpoint;

  FreeLlmClient(this.endpoint);

  @override
  Future<Map<String, Object?>> suggestRecipes({
    required String userQuery,
    required Map<String, Object?> constraints,
  }) async {
    int retries = 3;
    while (retries > 0) {
      try {
        final res = await http.post(
          Uri.parse(endpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'query': userQuery,
            'constraints': constraints,
          }),
        ).timeout(const Duration(seconds: 10));

        if (res.statusCode == 200) {
          return jsonDecode(res.body);
        }
      } catch (e) {
        if (retries == 1) rethrow;
      }
      retries--;
      await Future.delayed(const Duration(seconds: 1));
    }
    throw Exception('Failed to suggest recipes after retries');
  }

  @override
  Future<Map<String, Object?>> suggestSubstitutions({
    required Map<String, Object?> missingIngredient,
    required Map<String, Object?> recipeContext,
  }) async {
    // Same pattern
    return {};
  }
}
