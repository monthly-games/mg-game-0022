import 'package:flutter_test/flutter_test.dart';
import 'package:game/features/monsters/monster_model.dart';

void main() {
  group('Monster Stats Tests', () {
    test('Monster initialization has default stats', () {
      const monster = Monster(id: 'm1', name: 'TestBlob');
      expect(monster.stats, isNotNull);
      expect(monster.stats['STR'], greaterThanOrEqualTo(0));
      expect(monster.stats['AGI'], greaterThanOrEqualTo(0));
      expect(monster.stats['INT'], greaterThanOrEqualTo(0));
    });

    test('Monster persistence saves stats and traits', () {
      final monster = Monster(
        id: 'm2',
        name: 'StrongBlob',
        stats: {'STR': 10, 'AGI': 5, 'INT': 2},
        traits: ['Lucky'],
      );

      final json = monster.toJson();
      final loaded = Monster.fromJson(json);

      expect(loaded.stats['STR'], 10);
      expect(loaded.traits, contains('Lucky'));
    });

    test('Evolution boosts stats (mock logic)', () {
      // In a real game, evolve() would boost stats.
      // For now, let's just assume evolve keeps or boosts them.
      // This test might need adjustment based on implementation detail,
      // but let's define the expectation: Evolution shouldn't LOSE stats.

      final base = Monster(
        id: 'm3',
        name: 'Poke',
        level: 20,
        currentXp: 0,
        stats: {'STR': 5, 'AGI': 5, 'INT': 5},
      );

      // Force allow evolve? logic checks level >= 20.
      final evolved = base.evolve('Super Poke');

      expect(evolved.speciesName, 'Super Poke');
      expect(evolved.stats['STR'], greaterThanOrEqualTo(5));
    });
  });
}
