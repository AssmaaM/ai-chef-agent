// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application/agent/agent_controller.dart';
import 'presentation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: Real initialization (DB, notifications, voice, etc.) is done
  // inside AgentController bootstrap to keep main.dart minimal.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AgentController()..bootstrap(),
        ),
      ],
      child: const AiChefApp(),
    ),
  );
}


