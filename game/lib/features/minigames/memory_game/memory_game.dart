import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../minigame_base.dart';

class MemoryGame extends MiniGameBase with TapDetector {
  final VoidCallback onGameOver;
  int _level = 1;
  List<int> _sequence = [];
  List<int> _playerInput = [];
  bool _isPlayerTurn = false;

  late List<ColorButton> _buttons;
  late TextComponent _infoText;

  MemoryGame({required this.onGameOver}) : super(timeLimitSeconds: 60);

  @override
  Future<void> onLoad() async {
    _buttons = [
      ColorButton(0, Colors.red, Vector2(size.x / 2 - 60, size.y / 2 - 60)),
      ColorButton(1, Colors.blue, Vector2(size.x / 2 + 60, size.y / 2 - 60)),
      ColorButton(2, Colors.green, Vector2(size.x / 2 - 60, size.y / 2 + 60)),
      ColorButton(3, Colors.yellow, Vector2(size.x / 2 + 60, size.y / 2 + 60)),
    ];
    addAll(_buttons);

    _infoText = TextComponent(
      text: 'Watch!',
      position: Vector2(size.x / 2, size.y / 4),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 32, color: Colors.white),
      ),
    );
    add(_infoText);

    _startRound();
  }

  void _startRound() {
    _isPlayerTurn = false;
    _playerInput.clear();
    _infoText.text = 'Watch! (Lv.$_level)';

    _sequence.add(Random().nextInt(4));

    _playSequence();
  }

  Future<void> _playSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (final index in _sequence) {
      _buttons[index].highlight();
      await Future.delayed(const Duration(milliseconds: 600));
    }

    _isPlayerTurn = true;
    _infoText.text = 'Your Turn!';
  }

  void onButtonTap(int index) {
    if (!_isPlayerTurn || isGameOver) return; // Public field

    _buttons[index].highlight();
    _playerInput.add(index);

    final currentStep = _playerInput.length - 1;
    if (_playerInput[currentStep] != _sequence[currentStep]) {
      isGameOver = true; // Public field
      _infoText.text = 'Game Over!';
      _infoText.textRenderer = TextPaint(
        style: const TextStyle(fontSize: 32, color: Colors.red),
      );
      Future.delayed(const Duration(seconds: 1), onGameOver);
    } else {
      if (_playerInput.length == _sequence.length) {
        _level++;
        Future.delayed(const Duration(seconds: 1), _startRound);
      }
    }
  }

  @override
  void onTimeExpired() {
    onGameOver();
  }

  @override
  int getScore() => (_level - 1) * 100;

  @override
  int getStars() {
    if (_level >= 8) return 3;
    if (_level >= 5) return 2;
    if (_level >= 3) return 1;
    return 0;
  }
}

class ColorButton extends PositionComponent
    with TapCallbacks, HasGameRef<MemoryGame> {
  final int index;
  final Color baseColor;
  late CircleComponent _circle;

  ColorButton(this.index, this.baseColor, Vector2 position)
    : super(position: position, size: Vector2(100, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    _circle = CircleComponent(
      radius: 45,
      anchor: Anchor.center,
      position: size / 2,
      paint: Paint()..color = baseColor.withOpacity(0.6),
    );
    add(_circle);
  }

  void highlight() {
    _circle.paint.color = baseColor.withOpacity(1.0);
    // Needed flume/effects import - added in this version
    add(
      ScaleEffect.by(
        Vector2.all(1.2),
        EffectController(duration: 0.1, reverseDuration: 0.1),
      ),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _circle.paint.color = baseColor.withOpacity(0.6);
    });
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.onButtonTap(index);
  }
}
