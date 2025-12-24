import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../game_state.dart';

class SaveManager {
  static const String keyGameState = 'mg_game_0022_gamestate';

  Future<void> saveGameState(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.toJson());
    await prefs.setString(keyGameState, jsonString);
  }

  Future<GameState?> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(keyGameState);
    if (jsonString == null) return null;

    try {
      final jsonMap = jsonDecode(jsonString);
      return GameState.fromJson(jsonMap);
    } catch (e) {
      // Handle corruption or version mismatch
      return null;
    }
  }
}
