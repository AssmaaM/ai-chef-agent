// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application/agent/agent_controller.dart';
import 'presentation/app.dart';
import 'infrastructure/db/app_database.dart';
import 'infrastructure/llm/free_llm_client.dart';
import 'infrastructure/recipe/free_recipe_api_client.dart';
import 'infrastructure/repositories/recipe_repository_impl.dart';
import 'infrastructure/repositories/session_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await AppDatabase.open();
  final llmClient = FreeLlmClient('https://api.example.com/llm');
  final recipeApiClient = FreeRecipeApiClient('https://api.example.com/recipes');
  final recipeRepository = RecipeRepositoryImpl(recipeApiClient, db);
  final sessionRepository = SessionRepositoryImpl(db, AppDatabase.encryptionService);

  final agentController = AgentController(
    llmClient: llmClient,
    recipeRepository: recipeRepository,
    sessionRepository: sessionRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => agentController..bootstrap(),
        ),
      ],
      child: const AiChefApp(),
    ),
  );
}


