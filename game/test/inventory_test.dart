import 'package:flutter_test/flutter_test.dart';
import 'package:game/core/game_state.dart';

void main() {
  group('Inventory Tests', () {
    test('Add and remove Items', () {
      final state = GameState();
      expect(state.inventory, isEmpty);

      state.addItem('potion_xp');
      expect(state.inventory, contains('potion_xp'));
      expect(state.inventory.length, 1);

      state.addItem('potion_xp');
      expect(
        state.inventory.length,
        2,
      ); // Duplicates allowed? Yes for consumables.
    });

    test('Use Item - XP Potion', () {
      final state = GameState();
      state.addItem('potion_xp');

      int initialXp = state.activeMonster.currentXp;
      bool success = state.useItem('potion_xp');

      expect(success, true);
      expect(state.inventory, isEmpty);
      expect(state.activeMonster.currentXp, greaterThan(initialXp));
    });

    test('Use Item - Ticket Refill', () {
      final state = GameState();
      // Need to consume tickets first logic-wise, but we can set up state or use public methods?
      // GameState doesn't let us set tickets directly, let's consume some.
      state.consumeTicket();
      state.consumeTicket();
      // Assume max is 5.

      state.addItem('ticket_refill');
      bool success = state.useItem('ticket_refill');

      expect(success, true);
      expect(state.tickets, 5); // Should refill to max
    });

    test('Use Invalid/Missing Item', () {
      final state = GameState();
      bool success = state.useItem('unknown_item');
      expect(success, false);
    });
  });
}
