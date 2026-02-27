// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\application\agent\agent_controller.dart
import 'package:flutter/foundation.dart';

import '../../domain/agent/agent_action.dart';
import '../../domain/agent/agent_core.dart';
import '../../domain/agent/agent_event.dart';
import '../../domain/agent/agent_state_id.dart';
import '../../domain/security/capability_gate.dart';
import '../../domain/security/capability.dart';

/// Application-layer orchestrator around the pure AgentCore FSM.
///
/// - Owns the mutable instance of AgentCore.
/// - Translates UI/system events into AgentEvent.
/// - Interprets AgentAction into calls to infrastructure services
///   (LLM, recipe APIs, DB, timers, voice, capabilities).
class AgentController extends ChangeNotifier {
  AgentCore _core = AgentCore.initial();

  AgentStateId get state => _core.state;
  AgentCore get core => _core;

  // In a full implementation these would be injected (LLM client, DB, etc.)

  Future<void> bootstrap() async {
    // TODO: initialize DB, notifications, voice, restore last session, etc.
  }

  void handleEvent(AgentEvent event) {
    final result = _core.handleEvent(event);
    _core = AgentCore(state: result.nextState, context: result.nextContext, mode: _core.mode);
    _interpretActions(result.actions);
    notifyListeners();
  }

  void _interpretActions(List<AgentAction> actions) {
    final gate = CapabilityGate({
      Capability.useLlm,
      Capability.fetchRecipesFromApi,
      Capability.setInAppTimers,
  });
    for (final action in actions) {
      switch (action.type) {
        case AgentActionType.sendChatMessage:
          gate.require(Capability.useLlm);
          // TODO: push to chat timeline.
          break;
        case AgentActionType.askForIngredientAvailability:
          gate.require(Capability.useLlm);
          // TODO: present explicit yes/no UI question for this ingredient.
          break;
        case AgentActionType.presentRecipeSuggestions:
          gate.require(Capability.useLlm);
          // TODO: map to UI model and show suggestion list.
          break;
        case AgentActionType.presentRecipeDetails:
          gate.require(Capability.useLlm);
          // TODO: navigate to / update recipe detail panel.
          break;
        case AgentActionType.presentMissingIngredients:
          gate.require(Capability.useLlm);
          // TODO: show list of missing ingredients + estimated cost.
          break;
        case AgentActionType.callLlmForRecipeSuggestions:
          gate.require(Capability.useLlm);
          // TODO: call LLM via capability-gated infra service.
          break;
        case AgentActionType.callLlmForSubstitutions:
          gate.require(Capability.useLlm);
          // TODO: call LLM and then send AgentEvent.substitutionsSuggested.
          break;
        case AgentActionType.fetchRecipesFromApi:
          gate.require(Capability.fetchRecipesFromApi);
          // TODO: query free recipe APIs, cache in local DB, send recipesSuggested.
          break;
        case AgentActionType.estimateGroceryCost:
          gate.require(Capability.fetchRecipesFromApi);
          // TODO: estimate prices using cached data or user-provided averages.
          break;
        case AgentActionType.assistOpeningGroceryApp:
          gate.require(Capability.openGroceryApp);
          // TODO: open grocery deep link only after explicit permission check.
          break;
        case AgentActionType.scheduleCookingTimer:
          gate.require(Capability.setInAppTimers);
          // TODO: schedule in-app + OS-level alarm via notifications.
          break;
        case AgentActionType.cancelCookingTimer:
          gate.require(Capability.setInAppTimers);
          // TODO: cancel timers and alarms.
          break;
        case AgentActionType.persistCookingSession:
          gate.require(Capability.setInAppTimers);
          // TODO: write cooking history to encrypted SQLite.
          break;
        case AgentActionType.cacheRecipes:
          gate.require(Capability.cacheRecipes);
          // TODO: upsert recipes in local DB.
          break;
      }
    }
  }
}

