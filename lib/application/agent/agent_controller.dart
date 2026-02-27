// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\application\agent\agent_controller.dart
import 'package:flutter/foundation.dart';

import '../../domain/agent/agent_action.dart';
import '../../domain/agent/agent_core.dart';
import '../../domain/agent/agent_event.dart';
import '../../domain/agent/agent_state_id.dart';
import '../../domain/security/capability_gate.dart';
import '../../domain/security/capability.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../infrastructure/llm/llm_client.dart';
import '../../domain/models/recipe.dart';
import '../../domain/agent/agent_event.dart';

/// Application-layer orchestrator around the pure AgentCore FSM.
///
/// - Owns the mutable instance of AgentCore.
/// - Translates UI/system events into AgentEvent.
/// - Interprets AgentAction into calls to infrastructure services
///   (LLM, recipe APIs, DB, timers, voice, capabilities).
class AgentController extends ChangeNotifier {
  AgentCore _core = AgentCore.initial();
  final LlmClient _llmClient;
  final RecipeRepository _recipeRepository;
  final SessionRepository _sessionRepository;

  AgentController({
    required LlmClient llmClient,
    required RecipeRepository recipeRepository,
    required SessionRepository sessionRepository,
  })  : _llmClient = llmClient,
        _recipeRepository = recipeRepository,
        _sessionRepository = sessionRepository;

  AgentStateId get state => _core.state;
  AgentCore get core => _core;

  Future<void> bootstrap() async {
    final lastSession = await _sessionRepository.getLastSession();
    if (lastSession != null && lastSession.finishedAt == null) {
      // Restore session
      _core = AgentCore(
        state: AgentStateId.cookingStep, // Simplified restoration
        context: _core.context.copyWith(activeSession: lastSession),
        mode: _core.mode,
      );
      notifyListeners();
    }
  }

  void handleEvent(AgentEvent event) {
    final result = _core.handleEvent(event);
    _core = AgentCore(state: result.nextState, context: result.nextContext, mode: _core.mode);
    _interpretActions(result.actions);
    notifyListeners();
  }

  void _interpretActions(List<AgentAction> actions) async {
    final gate = CapabilityGate({
      Capability.useLlm,
      Capability.fetchRecipesFromApi,
      Capability.setInAppTimers,
      Capability.cacheRecipes,
      Capability.openGroceryApp,
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
          try {
            final data = await _llmClient.suggestRecipes(
              userQuery: "suggest recipes", // Simplified
              constraints: {},
            );
            // Validation step
            if (data.containsKey('recipes')) {
              handleEvent(AgentEvent(
                type: AgentEventType.recipesSuggested,
                source: EventSource.system,
                payload: {'recipes': (data['recipes'] as List).map((r) => Recipe.fromJson(r)).toList()},
              ));
            }
          } catch (e) {
            handleEvent(const AgentEvent(type: AgentEventType.recipesFailed, source: EventSource.system));
          }
          break;
        case AgentActionType.callLlmForSubstitutions:
          gate.require(Capability.useLlm);
          try {
            final data = await _llmClient.suggestSubstitutions(
              missingIngredient: action.payload['missingIngredient'] as Map<String, Object?>,
              recipeContext: {'recipeId': action.payload['recipeId']},
            );
            // Validation
            if (data.containsKey('substitution')) {
              handleEvent(AgentEvent(
                type: AgentEventType.substitutionsSuggested,
                source: EventSource.system,
                payload: data,
              ));
            }
          } catch (e) {
            handleEvent(const AgentEvent(type: AgentEventType.substitutionsFailed, source: EventSource.system));
          }
          break;
        case AgentActionType.fetchRecipesFromApi:
          gate.require(Capability.fetchRecipesFromApi);
          try {
            final recipes = await _recipeRepository.searchRecipes("healthy");
            handleEvent(AgentEvent(
              type: AgentEventType.recipesSuggested,
              source: EventSource.system,
              payload: {'recipes': recipes},
            ));
          } catch (e) {
            handleEvent(const AgentEvent(type: AgentEventType.recipesFailed, source: EventSource.system));
          }
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
          if (_core.context.activeSession != null) {
            await _sessionRepository.saveSession(_core.context.activeSession!);
          }
          break;
        case AgentActionType.cacheRecipes:
          gate.require(Capability.cacheRecipes);
          if (action.payload.containsKey('recipes')) {
            await _recipeRepository.cacheRecipes(action.payload['recipes'] as List<Recipe>);
          }
          break;
      }
    }
  }
}

