import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'core/game_state.dart';
import 'core/managers/save_manager.dart';
import 'ui/main_menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupDI();
  await GetIt.I<AudioManager>().initialize();

  // Load State
  final saveManager = GetIt.I<SaveManager>();
  final initialState = await saveManager.loadGameState() ?? GameState();

  runApp(MonsterPartyApp(initialState: initialState));
}

Future<void> _setupDI() async {
  if (!GetIt.I.isRegistered<AudioManager>()) {
    GetIt.I.registerSingleton<AudioManager>(AudioManager());
  }
  if (!GetIt.I.isRegistered<SaveManager>()) {
    GetIt.I.registerSingleton<SaveManager>(SaveManager());
  }
}

class MonsterPartyApp extends StatelessWidget {
  final GameState initialState;

  const MonsterPartyApp({super.key, required this.initialState});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => initialState)],
      child: MaterialApp(
        title: 'Monster Party',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
        ),
        home: const MainMenuScreen(),
      ),
    );
  }
}
