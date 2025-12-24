import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../features/monsters/monster_model.dart';
import 'managers/save_manager.dart';

class GameState extends ChangeNotifier {
  int _coins = 0;
  int _tickets = 5;
  late Monster _activeMonster;
  Map<String, int> _highScores = {};
  String? _lastLoginDate;
  List<String> _inventory = [];

  int get coins => _coins;
  int get tickets => _tickets;
  Monster get activeMonster => _activeMonster;
  Map<String, int> get highScores => Map.unmodifiable(_highScores);
  List<String> get inventory => List.unmodifiable(_inventory);

  // No-arg constructor for new game
  GameState() {
    _activeMonster = const Monster(id: 'm001', name: 'Slime');
  }

  // Constructor for loading
  GameState.fromData({
    required int coins,
    required int tickets,
    required Monster activeMonster,
    Map<String, int>? highScores,
    String? lastLoginDate,
    List<String>? inventory,
  }) {
    _coins = coins;
    _tickets = tickets;
    _activeMonster = activeMonster;
    _highScores = highScores ?? {};
    _lastLoginDate = lastLoginDate;
    _inventory = inventory ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      'coins': _coins,
      'tickets': _tickets,
      'activeMonster': _activeMonster.toJson(),
      'highScores': _highScores,
      'lastLoginDate': _lastLoginDate,
      'inventory': _inventory,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState.fromData(
      coins: json['coins'] as int? ?? 0,
      tickets: json['tickets'] as int? ?? 5,
      activeMonster: Monster.fromJson(json['activeMonster']),
      highScores: (json['highScores'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ),
      lastLoginDate: json['lastLoginDate'] as String?,
      inventory: (json['inventory'] as List<dynamic>?)?.cast<String>(),
    );
  }

  factory GameState.initial() => GameState();

  void _autoSave() {
    try {
      // Check if SaveManager is registered to avoid test crashes if not mocked
      if (GetIt.I.isRegistered<SaveManager>()) {
        GetIt.I<SaveManager>().saveGameState(this);
      }
    } catch (e) {
      debugPrint('Auto-save failed: $e');
    }
  }

  void addItem(String itemId) {
    _inventory.add(itemId);
    notifyListeners();
    _autoSave();
  }

  bool useItem(String itemId) {
    if (!_inventory.contains(itemId)) return false;

    // Item Effects
    bool consumed = false;
    if (itemId == 'potion_xp') {
      addMonsterXp(500); // Effect
      consumed = true;
    } else if (itemId == 'ticket_refill') {
      _tickets = 5;
      notifyListeners();
      _autoSave();
      consumed = true;
    }

    if (consumed) {
      _inventory.remove(itemId); // Removes first instance
      notifyListeners();
      _autoSave();
      return true;
    }
    return false;
  }

  bool checkDailyLogin() {
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}"; // Simple YYYY-M-D

    if (_lastLoginDate != today) {
      _coins += 100; // Daily Bonus
      _tickets = 5; // Refill tickets too? Let's say yes.
      _lastLoginDate = today;
      notifyListeners();
      _autoSave();
      return true;
    }
    return false;
  }

  void updateHighScore(String gameId, int score) {
    int currentHigh = _highScores[gameId] ?? 0;
    if (score > currentHigh) {
      _highScores[gameId] = score;
      notifyListeners();
      _autoSave();
    }
  }

  int getHighScore(String gameId) => _highScores[gameId] ?? 0;

  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
    _autoSave();
  }

  void addTickets(int amount) {
    _tickets += amount;
    notifyListeners();
    _autoSave();
  }

  void consumeTicket() {
    if (_tickets > 0) {
      _tickets--;
      notifyListeners();
      _autoSave();
    }
  }

  void addMonsterXp(int amount) {
    _activeMonster = _activeMonster.addXp(amount);
    notifyListeners();
    _autoSave();
  }

  void evolveMonster() {
    if (_activeMonster.canEvolve) {
      String newSpecies = 'Super ${_activeMonster.speciesName}';
      if (_activeMonster.evolutionStage == 2) {
        newSpecies = 'Mega ${_activeMonster.speciesName}';
      }

      _activeMonster = _activeMonster.evolve(newSpecies);
      notifyListeners();
      _autoSave();
    }
  }
}
