import 'package:flutter_test/flutter_test.dart';
import 'package:ai_chef_agent/domain/agent/agent_core.dart';
import 'package:ai_chef_agent/domain/agent/agent_event.dart';
import 'package:ai_chef_agent/domain/agent/agent_state_id.dart';
import 'package:ai_chef_agent/domain/agent/agent_action.dart';

void main() {
  group('AgentCore FSM Tests', () {
    test('Initial state is idle', () {
      final core = AgentCore.initial();
      expect(core.state, AgentStateId.idle);
    });

    test('Transition to awaitingConfirmation on ordering assistance', () {
      final core = AgentCore.initial();

      // First move to orderingIngredients state (simplified for test)
      final orderingCore = AgentCore(
        state: AgentStateId.orderingIngredients,
        context: core.context,
        mode: core.mode,
      );

      final result = orderingCore.handleEvent(const AgentEvent(
        type: AgentEventType.userConfirmedOrderingAssistance,
        source: EventSource.ui,
      ));

      expect(result.nextState, AgentStateId.awaitingConfirmation);
      expect(result.nextContext.pendingAction?.type, AgentActionType.assistOpeningGroceryApp);
    });

    test('Execute action after confirmation', () {
      final core = AgentCore.initial();
      final pendingAction = const AgentAction(type: AgentActionType.assistOpeningGroceryApp);

      final awaitingCore = AgentCore(
        state: AgentStateId.awaitingConfirmation,
        context: core.context.copyWith(pendingAction: pendingAction),
        mode: core.mode,
      );

      final result = awaitingCore.handleEvent(const AgentEvent(
        type: AgentEventType.userConfirmedAction,
        source: EventSource.ui,
      ));

      expect(result.nextState, AgentStateId.idle);
      expect(result.actions.contains(pendingAction), true);
      expect(result.nextContext.pendingAction, null);
    });
  });
}
