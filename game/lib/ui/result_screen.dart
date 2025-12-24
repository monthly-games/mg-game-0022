import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/game_state.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int stars;

  const ResultScreen({super.key, required this.score, required this.stars});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _scoreAnimation;
  bool _rewardsClaimed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scoreAnimation = IntTween(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _claimRewards();
  }

  void _claimRewards() {
    if (_rewardsClaimed) return;
    _rewardsClaimed = true;

    // Defer to next frame to ensure provider is ready if needed,
    // though initState is usually fine for listen:false calls.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = context.read<GameState>();
      // Award Coins: Score / 10
      final coinsEarned = (widget.score / 10).floor();
      // Award XP: Score / 5
      final xpEarned = (widget.score / 5).floor();

      gameState.addCoins(coinsEarned);
      gameState.addMonsterXp(xpEarned);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 32),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < widget.stars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 64,
                );
              }),
            ),
            const SizedBox(height: 16),

            // Animated Score
            AnimatedBuilder(
              animation: _scoreAnimation,
              builder: (context, child) {
                return Text(
                  'Score: ${_scoreAnimation.value}',
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                );
              },
            ),
            const SizedBox(height: 48),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Continue', style: TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }
}
