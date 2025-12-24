import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../minigame_base.dart';

class CatchGame extends MiniGameBase with DragCallbacks, HasCollisionDetection {
  late Paddle _paddle;
  int _score = 0;
  final VoidCallback onGameOver;
  late TextComponent _scoreText;
  late TextComponent _timerText;
  double _spawnTimer = 0;

  CatchGame({required this.onGameOver}) : super(timeLimitSeconds: 30);

  @override
  Future<void> onLoad() async {
    // Preload images if not already cached, though Flame does this mostly auto if asked.
    // images.loadAll(['paddle.png', 'coin.png']); // Optional preloading

    _paddle = Paddle(position: Vector2(size.x / 2, size.y - 50));
    add(_paddle);

    _scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 40),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
    add(_scoreText);

    _timerText = TextComponent(
      text: 'Time: 30',
      position: Vector2(size.x - 20, 40),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, color: Colors.amber),
      ),
    );
    add(_timerText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    _timerText.text = 'Time: ${(timeLimitSeconds - elapsedTime).ceil()}';

    _spawnTimer += dt;
    if (_spawnTimer > 0.8) {
      _spawnTimer = 0;
      _spawnItem();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (isGameOver) return;
    _paddle.position.x = (_paddle.position.x + event.localDelta.x).clamp(
      50,
      size.x - 50,
    );
  }

  void _spawnItem() {
    final x = Random().nextDouble() * (size.x - 40) + 20;
    final isBomb = Random().nextDouble() < 0.2;
    // If it's a bomb, we use the CircleComponent fallback for now.
    // If it's a coin, we use the SpriteComponent.
    if (isBomb) {
      add(
        DroppableBomb(
          position: Vector2(x, -20),
          onCaught: () {
            _score = max(0, _score - 5);
            _scoreText.text = 'Score: $_score';
          },
        ),
      );
    } else {
      add(
        DroppableCoin(
          position: Vector2(x, -20),
          onCaught: () {
            _score += 10;
            _scoreText.text = 'Score: $_score';
          },
        ),
      );
    }
  }

  @override
  void onTimeExpired() {
    onGameOver();
  }

  @override
  int getScore() => _score;

  @override
  int getStars() {
    if (_score >= 200) return 3;
    if (_score >= 100) return 2;
    if (_score >= 50) return 1;
    return 0;
  }
}

class Paddle extends SpriteComponent
    with CollisionCallbacks, HasGameRef<CatchGame> {
  Paddle({required Vector2 position})
    : super(position: position, size: Vector2(100, 20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('paddle.png');
    add(RectangleHitbox());
  }
}

class DroppableCoin extends SpriteComponent
    with CollisionCallbacks, HasGameRef<CatchGame> {
  final VoidCallback onCaught;
  final double speed;

  DroppableCoin({required Vector2 position, required this.onCaught})
    : speed = 200 + Random().nextDouble() * 100,
      super(position: position, size: Vector2(32, 32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('coin.png');
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    if (position.y > gameRef.size.y + 50) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Paddle) {
      onCaught();
      removeFromParent();
    }
  }
}

class DroppableBomb extends CircleComponent
    with CollisionCallbacks, HasGameRef<CatchGame> {
  final VoidCallback onCaught;
  final double speed;

  DroppableBomb({required Vector2 position, required this.onCaught})
    : speed = 200 + Random().nextDouble() * 100,
      super(
        position: position,
        radius: 15,
        anchor: Anchor.center,
        paint: Paint()..color = Colors.red,
      );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    if (position.y > gameRef.size.y + 50) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Paddle) {
      onCaught();
      removeFromParent();
    }
  }
}
