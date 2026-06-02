import 'package:flutter_test/flutter_test.dart';
import 'package:game/core/game_state.dart';

void main() {
  group('Shop Logic Tests', () {
    test('Buy Tickets', () {
      final state = GameState();
      state.addCoins(200); // Give coins

      expect(state.tickets, 5); // Start with 5
      expect(state.coins, 200);

      // Simulate Buy Action from ShopScreen
      if (state.coins >= 100) {
        state.addCoins(-100);
        state.addTickets(5);
      }

      expect(state.coins, 100);
      expect(state.tickets, 10);
    });

    test('Buy XP', () {
      final state = GameState();
      state.addCoins(200);

      expect(state.activeMonster.currentXp, 0);

      // Simulate Buy Action
      if (state.coins >= 200) {
        state.addCoins(-200);
        state.addMonsterXp(100);
      }

      expect(state.coins, 0);
      // 100 XP at Level 1 triggers level up (100 required)
      // So Level should be 2, XP 0
      expect(state.activeMonster.level, 2);
      expect(state.activeMonster.currentXp, 0);
    });
  });
}
