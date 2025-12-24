import 'package:flutter_test/flutter_test.dart';
import 'package:game/core/game_state.dart';

void main() {
  group('Daily Login Tests', () {
    test('First login gives bonus', () {
      final state = GameState();
      // Initially no login date?
      // Wait, default constructor doesn't set it, so it's null.

      int initialCoins = state.coins;
      bool received = state.checkDailyLogin();

      expect(received, true);
      expect(state.coins, initialCoins + 100);
      expect(state.tickets, 5); // Refill
    });

    test('Second login same day gives no bonus', () {
      final state = GameState();
      state.checkDailyLogin(); // First time

      int coinsAfterFirst = state.coins;
      bool receivedSecond = state.checkDailyLogin(); // Second time

      expect(receivedSecond, false);
      expect(state.coins, coinsAfterFirst);
    });
  });
}
