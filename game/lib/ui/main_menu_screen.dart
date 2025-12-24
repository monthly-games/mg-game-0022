import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import '../core/game_state.dart';
import '../features/minigames/minigame_base.dart';
import '../features/minigames/button_masher/button_masher_game.dart';
import '../features/minigames/catch_game/catch_game.dart';
import '../features/minigames/memory_game/memory_game.dart';
import 'result_screen.dart';
import 'shop_screen.dart';
import 'settings_screen.dart';
import 'inventory_screen.dart';
import 'widgets/monster_display.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    _playBgm();

    // Check Daily Login after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = context.read<GameState>();
      if (gameState.checkDailyLogin()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Daily Bonus!'),
            content: const Text('You received 100 Coins and Ticket Refill!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Awesome!'),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> _playBgm() async {
    // Ensure Audio is running?
    // Actually AudioManager handles this.
    // For prototype, we'll try to play a track if valid.
    // In Phase 3 task, we just want integration.
    // GetIt.I<AudioManager>().playBgm('bgm_menu.mp3');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final monster = gameState.activeMonster;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monster Party'),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InventoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Text(
                'Monster Party',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),

              // Active Monster Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Monster Display
                    MonsterDisplay(monster: monster),
                    const SizedBox(height: 16),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatBadge(
                          icon: Icons.confirmation_number,
                          value: '${gameState.tickets}',
                          color: Colors.blue,
                        ),
                        _StatBadge(
                          icon: Icons.monetization_on,
                          value: '${gameState.coins}',
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Play Button
              ElevatedButton.icon(
                onPressed: gameState.tickets > 0
                    ? () => _showGameSelection(context, gameState)
                    : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Mini-Game'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGameSelection(BuildContext context, GameState gameState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Game', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _gameOption(
              context,
              'Button Masher',
              Icons.touch_app,
              gameState,
              0,
            ),
            _gameOption(
              context,
              'Catch Game',
              Icons.catching_pokemon,
              gameState,
              1,
            ),
            _gameOption(context, 'Memory Game', Icons.grid_view, gameState, 2),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _gameOption(
    BuildContext context,
    String title,
    IconData icon,
    GameState state,
    int type,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        'High Score: ${state.getHighScore(type == 0
            ? 'button_masher'
            : type == 1
            ? 'catch_game'
            : 'memory_game')}',
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 16,
      ),
      onTap: () {
        Navigator.pop(context); // Close sheet
        _playGame(context, state, type);
      },
    );
  }

  void _playGame(BuildContext context, GameState gameState, int gameType) {
    try {
      GetIt.I<AudioManager>().playSfx('sfx_game_start.wav');
    } catch (_) {}
    gameState.consumeTicket();

    late MiniGameBase game;

    final onGameOver = () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(score: game.getScore(), stars: game.getStars()),
        ),
      );
      // Update High Score
      String gameId = 'unknown';
      if (gameType == 0) gameId = 'button_masher';
      if (gameType == 1) gameId = 'catch_game';
      if (gameType == 2) gameId = 'memory_game';

      gameState.updateHighScore(gameId, game.getScore());
    };

    switch (gameType) {
      case 0:
        game = ButtonMasherGame(onGameOver: onGameOver);
        break;
      case 1:
        game = CatchGame(onGameOver: onGameOver);
        break;
      case 2:
        game = MemoryGame(onGameOver: onGameOver);
        break;
      default:
        game = ButtonMasherGame(onGameOver: onGameOver);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(body: GameWidget(game: game)),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
