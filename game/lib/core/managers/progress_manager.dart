import 'package:flutter/foundation.dart';

/// Tracks player progress across mini-games
class ProgressManager extends ChangeNotifier {
  int _totalStars = 0;
  int _gamesPlayed = 0;
  final Map<String, int> _highScores = {};

  int get totalStars => _totalStars;
  int get gamesPlayed => _gamesPlayed;
  Map<String, int> get highScores => Map.unmodifiable(_highScores);

  void addStars(int stars) {
    _totalStars += stars;
    notifyListeners();
  }

  void recordGame(String gameId, int score) {
    _gamesPlayed++;
    final current = _highScores[gameId] ?? 0;
    if (score > current) {
      _highScores[gameId] = score;
    }
    notifyListeners();
  }
}
