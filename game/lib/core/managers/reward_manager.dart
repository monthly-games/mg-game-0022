import 'package:flutter/foundation.dart';

/// Manages reward multipliers and distribution
class RewardManager extends ChangeNotifier {
  double _coinMultiplier = 1.0;
  double _xpMultiplier = 1.0;

  double get coinMultiplier => _coinMultiplier;
  double get xpMultiplier => _xpMultiplier;

  void setCoinMultiplier(double value) {
    _coinMultiplier = value;
    notifyListeners();
  }

  void setXpMultiplier(double value) {
    _xpMultiplier = value;
    notifyListeners();
  }

  int calculateCoinReward(int baseCoins) => (baseCoins * _coinMultiplier).round();
  int calculateXpReward(int baseXp) => (baseXp * _xpMultiplier).round();
}
