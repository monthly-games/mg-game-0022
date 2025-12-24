import 'package:flutter_test/flutter_test.dart';
import 'package:game/core/game_state.dart';
import 'package:game/features/monsters/monster_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get_it/get_it.dart';
import 'package:game/core/managers/save_manager.dart';

// Mock SaveManager
class MockSaveManager extends SaveManager {
  @override
  Future<void> saveGameState(GameState state) async {
    // No-op for test
  }
}

void main() {
  setUp(() {
    GetIt.I.reset();
    GetIt.I.registerSingleton<SaveManager>(MockSaveManager());
  });

  group('Persistence Tests', () {
    test('Monster Serialization', () {
      const monster = Monster(id: 'm1', name: 'Test', level: 5, currentXp: 100);
      final json = monster.toJson();
      final loaded = Monster.fromJson(json);

      expect(loaded.id, monster.id);
      expect(loaded.level, monster.level);
    });

    test('GameState Serialization', () {
      final state = GameState();
      state.addCoins(500);
      // Note: addCoins triggers _autoSave defined in GameState.
      // In this isolated test, GetIt is not set up, so _autoSave will safely skip or catch error.
      // We added a check `isRegistered` or try-catch in GameState to handle this.

      final json = state.toJson();
      final loaded = GameState.fromJson(json);

      expect(loaded.coins, 500);
      expect(loaded.tickets, 5);
      expect(loaded.activeMonster.name, 'Slime');
    });

    // We can't easily test SharedPreferences without mocking,
    // but we can test the generic logic.
    // For now, robust JSON testing is good enough for prototype.
  });
}
