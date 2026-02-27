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
    final res = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': userQuery,
        'constraints': constraints,
      }),
    );

    return jsonDecode(res.body);
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
