import 'package:flutter_test/flutter_test.dart';
import 'package:game/core/game_state.dart';

void main() {
  group('High Score Tests', () {
    test('Update High Score logic', () {
      final state = GameState();

      // Initial score 0
      expect(state.getHighScore('test_game'), 0);

      // New high score
      state.updateHighScore('test_game', 100);
      expect(state.getHighScore('test_game'), 100);

      // Lower score ignores update
      state.updateHighScore('test_game', 50);
      expect(state.getHighScore('test_game'), 100);

      // Higher score updates
      state.updateHighScore('test_game', 200);
      expect(state.getHighScore('test_game'), 200);
    });

    test('Serialization includes High Scores', () {
      final state = GameState();
      state.updateHighScore('game_1', 123);

      final json = state.toJson();
      final loaded = GameState.fromJson(json);

      expect(loaded.getHighScore('game_1'), 123);
    });
  });
}
