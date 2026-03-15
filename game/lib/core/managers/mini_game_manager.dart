import 'package:flutter/foundation.dart';

/// Manages available mini-games and their states
class MiniGameManager extends ChangeNotifier {
  final List<String> _availableGames = ['button_masher', 'catch', 'memory'];
  int _currentGameIndex = 0;

  List<String> get availableGames => _availableGames;
  int get currentGameIndex => _currentGameIndex;

  void selectGame(int index) {
    _currentGameIndex = index.clamp(0, _availableGames.length - 1);
    notifyListeners();
  }
}
