// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\presentation\screens\home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../application/agent/agent_controller.dart';
import '../../domain/agent/agent_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AgentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chef Agent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current state: ${controller.state.name}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                controller.handleEvent(
                  const AgentEvent(
                    type: AgentEventType.userRequestedMealSuggestions,
                    source: EventSource.ui,
                  ),
                );
              },
              child: const Text('Suggest a meal'),
            ),
            const SizedBox(height: 12),
            Text(
              'This UI is intentionally minimal. The agent core lives in the domain layer and can be driven by chat, voice, or other inputs.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

