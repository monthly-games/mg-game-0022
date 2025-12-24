import 'package:flame/game.dart';

abstract class MiniGameBase extends FlameGame {
  final int timeLimitSeconds;
  double elapsedTime = 0;
  bool isGameOver = false;

  MiniGameBase({required this.timeLimitSeconds});

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    elapsedTime += dt;
    if (elapsedTime >= timeLimitSeconds) {
      isGameOver = true;
      onTimeExpired();
    }
  }

  void onTimeExpired();

  int getScore();

  // 0-3 Stars
  int getStars();
}
