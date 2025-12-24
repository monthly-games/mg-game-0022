import 'package:flutter_test/flutter_test.dart';
import 'package:game/core/game_state.dart';
import 'package:game/features/monsters/monster_model.dart';

void main() {
  group('Monster Evolution Tests', () {
    test('Evolution Constraints', () {
      // Level 1 Monster
      const monster = Monster(id: '1', name: 'Slime');
      expect(monster.canEvolve, false);

      // Level 20 Monster
      const lv20 = Monster(id: '1', name: 'Slime', level: 20);
      expect(lv20.canEvolve, true);
    });

    test('Evolution Logic', () {
      const monster = Monster(
        id: '1',
        name: 'Slime',
        speciesName: 'Slime',
        level: 20,
      );
      final evolved = monster.evolve('Super Slime');

      expect(evolved.evolutionStage, 2);
      expect(evolved.speciesName, 'Super Slime');
      expect(
        evolved.level,
        1,
      ); // We decided to reset level in code logic? Let's check what I implemented.
      // Wait, in previous step I commented "For this prototype, let's keep level..." but code said:
      // level: 1
      // So checks should expect level 1.
    });

    test('GameState Evolution', () {
      final state = GameState();
      // Grind to Lv 20
      // Lv 1->2 needs 100. Lv 1->20 needs approx... summation.
      // Let's just force state if possible? No setters.
      // Use addMonsterXp.

      // Cheat: A lot of XP.
      // 20 levels * ~2000 xp avg = 40000
      state.addMonsterXp(500000);

      expect(state.activeMonster.level >= 20, true);
      expect(state.activeMonster.canEvolve, true);

      state.evolveMonster();

      expect(state.activeMonster.evolutionStage, 2);
      expect(state.activeMonster.speciesName, contains('Super'));
    });
  });
}
