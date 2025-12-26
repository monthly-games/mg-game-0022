/// VFX Manager for MG-0022 Monster Party
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mg_common_game/core/engine/effects/flame_effects.dart';

class VfxManager extends Component {
  VfxManager();

  Component? _gameRef;

  void setGame(Component game) {
    _gameRef = game;
  }

  void _addEffect(Component effect) {
    _gameRef?.add(effect);
  }

  /// Show monster summon effect
  void showMonsterSummon(Vector2 position, Color monsterColor) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: monsterColor,
        particleCount: 20,
        duration: 0.6,
        spreadRadius: 35.0,
      ),
    );
  }

  /// Show monster attack effect
  void showMonsterAttack(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.red,
        particleCount: 15,
        duration: 0.4,
        spreadRadius: 30.0,
      ),
    );
  }

  /// Show party boost effect
  void showPartyBoost(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.purple,
        particleCount: 25,
        duration: 0.7,
        spreadRadius: 45.0,
      ),
    );
  }

  /// Show monster level up effect
  void showMonsterLevelUp(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.yellow,
        particleCount: 30,
        duration: 0.8,
        spreadRadius: 40.0,
      ),
    );
  }

  /// Show candy collect effect
  void showCandyCollect(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.pink,
        particleCount: 12,
        duration: 0.4,
        spreadRadius: 25.0,
      ),
    );
  }

  /// Show party celebration effect
  void showPartyCelebration(Vector2 position) {
    _addEffect(
      FlameParticleEffect(
        position: position.clone(),
        color: Colors.amber,
        particleCount: 40,
        duration: 1.0,
        spreadRadius: 60.0,
      ),
    );
  }
}
