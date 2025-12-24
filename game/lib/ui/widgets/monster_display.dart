import 'package:flutter/material.dart';
import '../../features/monsters/monster_model.dart';

class MonsterDisplay extends StatelessWidget {
  final Monster monster;

  const MonsterDisplay({super.key, required this.monster});

  @override
  Widget build(BuildContext context) {
    // Determine asset based on evolution stage (prototype logic)
    // In real app, speciesName would map to assets.
    String assetPath = 'assets/images/monster_slime.png';
    Color filterColor = Colors.transparent;

    if (monster.evolutionStage == 2) {
      filterColor = Colors.red.withOpacity(0.3); // Super tint
    } else if (monster.evolutionStage == 3) {
      filterColor = Colors.purple.withOpacity(0.3); // Mega tint
    }

    // Fallback for different species if we had them

    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                assetPath,
                width: 100,
                fit: BoxFit.contain,
                color: filterColor == Colors.transparent ? null : filterColor,
                colorBlendMode: BlendMode.srcATop,
              ),
              if (monster.evolutionStage > 1)
                const Positioned(
                  bottom: 10,
                  child: Icon(Icons.star, color: Colors.amber, size: 24),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          monster.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Lv. ${monster.level} ${monster.speciesName ?? ''}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        // Stats and Traits
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatColumn(
              label: 'STR',
              value: monster.stats['STR'] ?? 0,
              color: Colors.redAccent,
            ),
            _StatColumn(
              label: 'AGI',
              value: monster.stats['AGI'] ?? 0,
              color: Colors.greenAccent,
            ),
            _StatColumn(
              label: 'INT',
              value: monster.stats['INT'] ?? 0,
              color: Colors.blueAccent,
            ),
          ],
        ),
        if (monster.traits.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              spacing: 8,
              children: monster.traits
                  .map(
                    (t) => Chip(
                      label: Text(t, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.amber.withOpacity(0.8),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (value / 50).clamp(0.0, 1.0), // Mock max stat 50
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
