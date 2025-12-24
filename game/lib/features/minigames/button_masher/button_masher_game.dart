import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../minigame_base.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';

class ButtonMasherGame extends MiniGameBase with TapDetector {
  int _score = 0;
  final VoidCallback onGameOver;

  late TextComponent _scoreText;
  late TextComponent _timerText;

  ButtonMasherGame({required this.onGameOver}) : super(timeLimitSeconds: 10);

  @override
  Future<void> onLoad() async {
    _scoreText = TextComponent(
      text: 'Taps: 0',
      position: Vector2(size.x / 2, size.y / 3),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 48, color: Colors.white),
      ),
    );
    add(_scoreText);

    _timerText = TextComponent(
      text: 'Time: 10',
      position: Vector2(size.x / 2, size.y / 5),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 32, color: AppColors.accent),
      ),
    );
    add(_timerText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timerText.text = 'Time: ${(timeLimitSeconds - elapsedTime).ceil()}';
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (isGameOver) return;
    _score++;
    _scoreText.text = 'Taps: $_score';

    // Simple visual feedback
    add(
      TextComponent(
        text: '+1',
        position: info.eventPosition.widget,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 24, color: AppColors.primary),
        ),
      )..add(
        MoveEffect.by(
          Vector2(0, -50),
          EffectController(duration: 0.5),
          onComplete: () => removeFromParent(),
        ),
      ),
    );
  }

  @override
  void onTimeExpired() {
    onGameOver();
  }

  @override
  int getScore() => _score;

  @override
  int getStars() {
    if (_score >= 60) return 3; // 6 taps/sec
    if (_score >= 40) return 2; // 4 taps/sec
    if (_score >= 20) return 1; // 2 taps/sec
    return 0;
  }
}
