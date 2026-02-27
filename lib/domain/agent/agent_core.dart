// C:\Users\assma\OneDrive\Bureau\ai_chef_agent\lib\domain\agent\agent_core.dart
import 'agent_action.dart';
import 'agent_context.dart';
import 'agent_event.dart';
import 'agent_state_id.dart';
import '../models/cooking_session.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/cooking_timer.dart';
import 'agent_mode.dart';

/// Result of handling an event: new state, updated context, and zero or more
/// high-level actions for the application/infra layers.
class AgentTransitionResult {
  final AgentStateId nextState;
  final AgentContext nextContext;
  final List<AgentAction> actions;

  const AgentTransitionResult({
    required this.nextState,
    required this.nextContext,
    this.actions = const [],
  });
}

/// Deterministic finite state machine core.
///
/// - Pure: it does not call OS APIs, network, DB, or LLMs directly.
/// - All side effects are expressed as AgentAction instances.
/// - This makes it straightforward to test and to audit transitions.
class AgentCore {
  final AgentStateId state;
  final AgentContext context;
  final AgentMode mode;

  const AgentCore({
    required this.state,
    required this.context,
    required this.mode,
  });

  AgentCore.initial() : this(state: AgentStateId.idle, context: const AgentContext(), mode: AgentMode.idle);

  AgentTransitionResult handleEvent(AgentEvent event) {
    switch (state) {
      case AgentStateId.idle:
        return _onIdle(event);
      case AgentStateId.suggestingRecipes:
        return _onSuggestingRecipes(event);
      case AgentStateId.recipeSelected:
        return _onRecipeSelected(event);
      case AgentStateId.checkingIngredients:
        return _onCheckingIngredients(event);
      case AgentStateId.substitutingIngredients:
        return _onSubstitutingIngredients(event);
      case AgentStateId.orderingIngredients:
        return _onOrderingIngredients(event);
      case AgentStateId.cookingPreparation:
        return _onCookingPreparation(event);
      case AgentStateId.cookingStep:
        return _onCookingStep(event);
      case AgentStateId.timerRunning:
        return _onTimerRunning(event);
      case AgentStateId.finished:
        return _onFinished(event);
      case AgentStateId.error:
        return _onError(event);
      case AgentStateId.awaitingConfirmation:
        return _onAwaitingConfirmation(event);
    }
  }




  AgentTransitionResult _onIdle(AgentEvent event) {
    switch (event.type) {
      case AgentEventType.userRequestedMealSuggestions:
        // Ask infra to fetch/calc recipe suggestions via LLM + APIs.
        return AgentTransitionResult(
          nextState: AgentStateId.suggestingRecipes,
          nextContext: context.copyWith(suggestedRecipes: []),
          actions: const [
            AgentAction(type: AgentActionType.fetchRecipesFromApi),
            AgentAction(type: AgentActionType.callLlmForRecipeSuggestions),
          ],
        );
      case AgentEventType.userStartedSession:
        return AgentTransitionResult(
          nextState: AgentStateId.idle,
          nextContext: context,
        );
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onSuggestingRecipes(AgentEvent event) {
    switch (event.type) {
      case AgentEventType.recipesSuggested:
        final recipes = (event.payload['recipes'] as List<Recipe>? ?? []);
        return AgentTransitionResult(
          nextState: AgentStateId.suggestingRecipes,
          nextContext: context.copyWith(suggestedRecipes: recipes),
          actions: [
            AgentAction(
              type: AgentActionType.presentRecipeSuggestions,
              payload: {'recipes': recipes},
            ),
          ],
        );
      case AgentEventType.userSelectedRecipe:
        final recipe = event.payload['recipe'] as Recipe?;
        if (recipe == null) {
          return _error("Missing recipe in userSelectedRecipe");
        }
        // Initialize a new cooking session with unknown ingredient statuses.
        final ingredientStatuses = recipe.ingredients
            .map(
              (ing) => IngredientStatus(
                ingredient: ing,
                availability: IngredientAvailabilityStatus.unknown,
              ),
            )
            .toList();

        final session = CookingSession(
          id: event.payload['sessionId'] as String? ?? DateTime.now().toIso8601String(),
          startedAt: DateTime.now(),
          recipe: recipe,
          ingredientStatuses: ingredientStatuses,
        );

        return AgentTransitionResult(
          nextState: AgentStateId.recipeSelected,
          nextContext: context.copyWith(
            selectedRecipe: recipe,
            activeSession: session,
          ),
          actions: [
            AgentAction(
              type: AgentActionType.presentRecipeDetails,
              payload: {'recipe': recipe},
            ),
          ],
        );
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onRecipeSelected(AgentEvent event) {
    switch (event.type) {
      case AgentEventType.userReadyToPrepare:
        // Start ingredient-by-ingredient availability checks.
        final session = context.activeSession;
        if (session == null) return _error("No active session in recipeSelected");

        return _askNextIngredientAvailability(
          ingredientIndex: 0,
          session: session,
        );
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onCheckingIngredients(AgentEvent event) {
    final session = context.activeSession;
    if (session == null) return _error("No active session in checkingIngredients");
    final index = context.ingredientCheckIndex ?? 0;

    switch (event.type) {
      case AgentEventType.userAnsweredIngredientAvailability:
        final available = event.payload['available'] as bool? ?? false;
        if (index < 0 || index >= session.ingredientStatuses.length) {
          return _error("Ingredient index out of range");
        }

        final statuses = [...session.ingredientStatuses];
        final currentStatus = statuses[index];

        statuses[index] = currentStatus.copyWith(
          availability:
              available ? IngredientAvailabilityStatus.available : IngredientAvailabilityStatus.missing,
        );

        final updatedSession = session.copyWith(ingredientStatuses: statuses);

        if (!available) {
          // Ask LLM for substitution OR move to ordering as needed.
          return AgentTransitionResult(
            nextState: AgentStateId.substitutingIngredients,
            nextContext: context.copyWith(
              activeSession: updatedSession,
              ingredientCheckIndex: index,
            ),
            actions: [
              AgentAction(
                type: AgentActionType.callLlmForSubstitutions,
                payload: {
                  'missingIngredient': currentStatus.ingredient,
                  'recipeId': session.recipe.id,
                },
              ),
            ],
          );
        }

        // Move to next ingredient or move on to preparation.
        if (index + 1 < updatedSession.ingredientStatuses.length) {
          return _askNextIngredientAvailability(
            ingredientIndex: index + 1,
            session: updatedSession,
          );
        } else {
          return AgentTransitionResult(
            nextState: AgentStateId.cookingPreparation,
            nextContext: context.copyWith(
              activeSession: updatedSession,
              ingredientCheckIndex: null,
            ),
            actions: const [
              AgentAction(
                type: AgentActionType.sendChatMessage,
                payload: {
                  'message': 'All ingredients checked. Ready to start preparation.',
                },
              ),
            ],
          );
        }
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onSubstitutingIngredients(AgentEvent event) {
    final session = context.activeSession;
    final index = context.ingredientCheckIndex;
    if (session == null || index == null) {
      return _error("Missing session or ingredient index in substitutingIngredients");
    }

    switch (event.type) {
      case AgentEventType.substitutionsSuggested:
        // Payload is expected to be validated substitutions from LLM.
        final substitution = event.payload['substitution'] as Ingredient?;
        if (substitution == null) {
          // No valid substitution -> consider ordering assistance.
          return AgentTransitionResult(
            nextState: AgentStateId.orderingIngredients,
            nextContext: context,
            actions: [
              AgentAction(
                type: AgentActionType.presentMissingIngredients,
                payload: {'missing': [session.ingredientStatuses[index].ingredient]},
              ),
              const AgentAction(
                type: AgentActionType.estimateGroceryCost,
              ),
            ],
          );
        }

        final statuses = [...session.ingredientStatuses];
        final current = statuses[index];
        statuses[index] = current.copyWith(
          availability: IngredientAvailabilityStatus.substituted,
          substitution: substitution,
        );
        final updatedSession = session.copyWith(ingredientStatuses: statuses);

        // After successful substitution, continue ingredient checks.
        if (index + 1 < updatedSession.ingredientStatuses.length) {
          return _askNextIngredientAvailability(
            ingredientIndex: index + 1,
            session: updatedSession,
          );
        } else {
          return AgentTransitionResult(
            nextState: AgentStateId.cookingPreparation,
            nextContext: context.copyWith(
              activeSession: updatedSession,
              ingredientCheckIndex: null,
            ),
          );
        }
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onOrderingIngredients(AgentEvent event) {
    switch (event.type) {
      case AgentEventType.userRequestedOrderingAssistance:
        // List missing ingredients and estimate cost.
        return AgentTransitionResult(
          nextState: AgentStateId.orderingIngredients,
          nextContext: context,
          actions: const [
            AgentAction(type: AgentActionType.presentMissingIngredients),
            AgentAction(type: AgentActionType.estimateGroceryCost),
          ],
        );
      case AgentEventType.userConfirmedOrderingAssistance:
        // Move to awaitingConfirmation for security/manual gating.
        return AgentTransitionResult(
          nextState: AgentStateId.awaitingConfirmation,
          nextContext: context.copyWith(
            pendingAction: const AgentAction(type: AgentActionType.assistOpeningGroceryApp),
          ),
          actions: const [
            AgentAction(
              type: AgentActionType.sendChatMessage,
              payload: {'message': 'Are you sure you want to open the grocery app?'},
            ),
          ],
        );
      case AgentEventType.userDeclinedOrderingAssistance:
        return AgentTransitionResult(
          nextState: AgentStateId.idle,
          nextContext: context.clearSession(),
        );
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onAwaitingConfirmation(AgentEvent event) {
    final pendingAction = context.pendingAction;
    if (pendingAction == null) return _error("No pending action in awaitingConfirmation");

    switch (event.type) {
      case AgentEventType.userConfirmedAction:
        // Execute the pending action.
        return AgentTransitionResult(
          nextState: AgentStateId.idle, // Or return to a sensible state
          nextContext: context.clearPendingAction(),
          actions: [pendingAction],
        );
      case AgentEventType.userCancelledAction:
        return AgentTransitionResult(
          nextState: AgentStateId.idle,
          nextContext: context.clearPendingAction(),
        );
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onCookingPreparation(AgentEvent event) {
    switch (event.type) {
      case AgentEventType.userReadyForNextStep:
        return AgentTransitionResult(
          nextState: AgentStateId.cookingStep,
          nextContext: context,
        );
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onCookingStep(AgentEvent event) {
    final session = context.activeSession;
    if (session == null) return _error("No active session in cookingStep");

    switch (event.type) {
      case AgentEventType.userConfirmedStepCompleted:
        final nextIndex = session.currentStepIndex + 1;
        if (nextIndex >= session.recipe.steps.length) {
          return AgentTransitionResult(
            nextState: AgentStateId.finished,
            nextContext: context.copyWith(
              activeSession: session.copyWith(
                finishedAt: DateTime.now(),
                currentStepIndex: nextIndex,
              ),
            ),
            actions: const [
              AgentAction(type: AgentActionType.persistCookingSession),
            ],
          );
        }
        return AgentTransitionResult(
          nextState: AgentStateId.cookingStep,
          nextContext: context.copyWith(
            activeSession: session.copyWith(currentStepIndex: nextIndex),
          ),
        );
      case AgentEventType.userPutDishInOven:
        // Create a logical timer for the current step if it has suggestedSeconds.
        final step = session.recipe.steps[session.currentStepIndex];
        final duration = step.suggestedSeconds;
        if (duration == null) {
          return AgentTransitionResult(
            nextState: AgentStateId.cookingStep,
            nextContext: context,
          );
        }
        final newTimer = CookingTimer(
          id: 'timer_${session.id}_${session.currentStepIndex}',
          label: 'Step ${session.currentStepIndex + 1}: ${step.instruction}',
          startTime: DateTime.now(),
          durationSeconds: duration,
        );
        final updatedSession = session.copyWith(
          timers: [...session.timers, newTimer],
        );
        return AgentTransitionResult(
          nextState: AgentStateId.timerRunning,
          nextContext: context.copyWith(activeSession: updatedSession),
          actions: [
            AgentAction(
              type: AgentActionType.scheduleCookingTimer,
              payload: {'timer': newTimer},
            ),
          ],
        );
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onTimerRunning(AgentEvent event) {
    final session = context.activeSession;
    if (session == null) return _error("No active session in timerRunning");

    switch (event.type) {
      case AgentEventType.timerFired:
        final timerId = event.payload['timerId'] as String?;
        if (timerId == null) return _error("Missing timerId in timerFired");
        final timers = session.timers
            .map(
              (t) => t.id == timerId
                  ? CookingTimer(
                      id: t.id,
                      label: t.label,
                      startTime: t.startTime,
                      durationSeconds: t.durationSeconds,
                      active: false,
                    )
                  : t,
            )
            .toList();
        final updatedSession = session.copyWith(timers: timers);

        return AgentTransitionResult(
          nextState: AgentStateId.cookingStep,
          nextContext: context.copyWith(activeSession: updatedSession),
          actions: const [
            AgentAction(
              type: AgentActionType.sendChatMessage,
              payload: {'message': 'Timer finished. Please check your dish.'},
            ),
          ],
        );
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onFinished(AgentEvent event) {
    switch (event.type) {
      case AgentEventType.userStartedSession:
        return AgentCore.initial().handleEvent(event);
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  AgentTransitionResult _onError(AgentEvent event) {
    switch (event.type) {
      case AgentEventType.userStartedSession:
        return AgentCore.initial().handleEvent(event);
      default:
        return AgentTransitionResult(nextState: state, nextContext: context);
    }
  }

  // --- Helpers ---

  AgentTransitionResult _error(String message) {
    return AgentTransitionResult(
      nextState: AgentStateId.error,
      nextContext: context,
      actions: [
        AgentAction(
          type: AgentActionType.sendChatMessage,
          payload: {'message': 'Sorry, something went wrong: $message'},
        ),
      ],
    );
  }

  AgentTransitionResult _askNextIngredientAvailability({
    required int ingredientIndex,
    required CookingSession session,
  }) {
    final status = session.ingredientStatuses[ingredientIndex];
    return AgentTransitionResult(
      nextState: AgentStateId.checkingIngredients,
      nextContext: context.copyWith(
        activeSession: session,
        ingredientCheckIndex: ingredientIndex,
      ),
      actions: [
        AgentAction(
          type: AgentActionType.askForIngredientAvailability,
          payload: {
            'ingredient': status.ingredient,
            'index': ingredientIndex,
            'total': session.ingredientStatuses.length,
          },
        ),
      ],
    );
  }
}

