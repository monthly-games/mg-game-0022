import 'package:equatable/equatable.dart';

class Monster extends Equatable {
  final String id;
  final String name;
  final int level;
  final int currentXp;
  final int evolutionStage; // 1, 2, 3
  final String? speciesName; // e.g. "Slime", "Super Slime"
  final Map<String, int> stats; // STR, AGI, INT
  final List<String> traits;

  const Monster({
    required this.id,
    required this.name,
    this.level = 1,
    this.currentXp = 0,
    this.evolutionStage = 1,
    this.speciesName,
    this.stats = const {'STR': 1, 'AGI': 1, 'INT': 1},
    this.traits = const [],
  });

  int get requiredXp => level * 100;

  Monster addXp(int amount) {
    int newXp = currentXp + amount;
    int newLevel = level;

    // Simple level up logic
    while (newXp >= newLevel * 100) {
      newXp -= newLevel * 100;
      newLevel++;
    }

    return Monster(
      id: id,
      name: name,
      level: newLevel,
      currentXp: newXp,
      evolutionStage: evolutionStage,
      speciesName: speciesName,
      stats: stats, // preserve stats on level up (could increment too)
      traits: traits,
    );
  }

  bool get canEvolve => level >= 20;

  Monster evolve(String newSpeciesName) {
    if (!canEvolve) return this;

    // Boost stats on evolution
    final newStats = Map<String, int>.from(stats);
    newStats.updateAll((key, val) => val + 5); // +5 to all stats

    return Monster(
      id: id,
      name: name,
      level: 1, // Reset level on evolution
      currentXp: currentXp,
      evolutionStage: evolutionStage + 1,
      speciesName: newSpeciesName,
      stats: newStats,
      traits: traits,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'currentXp': currentXp,
      'evolutionStage': evolutionStage,
      'speciesName': speciesName,
      'stats': stats,
      'traits': traits,
    };
  }

  factory Monster.fromJson(Map<String, dynamic> json) {
    return Monster(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      currentXp: json['currentXp'] as int,
      evolutionStage: json['evolutionStage'] as int? ?? 1,
      speciesName: json['speciesName'] as String?,
      stats:
          (json['stats'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const {'STR': 1, 'AGI': 1, 'INT': 1},
      traits: (json['traits'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    level,
    currentXp,
    evolutionStage,
    speciesName,
  ];
}
