import 'package:flutter_test/flutter_test.dart';
import 'package:game/core/game_state.dart';
import 'package:game/features/monsters/monster_model.dart';

void main() {
  group('GameState Tests', () {
    test('Initial State', () {
      final state = GameState();
      expect(state.coins, 0);
      expect(state.tickets, 5);
      expect(state.activeMonster.level, 1);
      expect(state.activeMonster.currentXp, 0);
    });

    test('Add Coins', () {
      final state = GameState();
      state.addCoins(100);
      expect(state.coins, 100);
    });

    test('Consume Ticket', () {
      final state = GameState();
      state.consumeTicket();
      expect(state.tickets, 4);

      // Consume all
      for (int i = 0; i < 5; i++) {
        state.consumeTicket();
      }
      expect(state.tickets, 0); // clamped at 0 essentially by check
    });

    test('Monster XP and Level Up', () {
      final state = GameState();
      // Level 1 requires 100 XP

      state.addMonsterXp(50);
      expect(state.activeMonster.level, 1);
      expect(state.activeMonster.currentXp, 50);

      // Add 50 more -> Level Up! (100 XP total)
      state.addMonsterXp(50);
      expect(state.activeMonster.level, 2);
      expect(state.activeMonster.currentXp, 0); // 100 - 100 = 0

      // Level 2 requires 200 XP
      state.addMonsterXp(250); // Total 250 XP
      // 250 - 200 = 50 remaining, Level 3
      expect(state.activeMonster.level, 3);
      expect(state.activeMonster.currentXp, 50);
    });
  });

  group('Monster Model Tests', () {
    test('XP Calculation', () {
      const monster = Monster(id: '1', name: 'Test');
      expect(monster.requiredXp, 100); // Level 1

      final level2 = monster.addXp(100);
      expect(level2.level, 2);
      expect(level2.requiredXp, 200); // Level 2
    });
  });
}
