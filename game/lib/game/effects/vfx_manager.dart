/// VFX Manager for MG-0022 Monster Party
library;
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
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: monsterColor,
          radius: 35.0,
        ),
    );
  }

  /// Show monster attack effect
  void showMonsterAttack(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.red,
          radius: 30.0,
        ),
    );
  }

  /// Show party boost effect
  void showPartyBoost(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.purple,
          radius: 45.0,
        ),
    );
  }

  /// Show monster level up effect
  void showMonsterLevelUp(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.yellow,
          radius: 40.0,
        ),
    );
  }

  /// Show candy collect effect
  void showCandyCollect(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.pink,
          radius: 25.0,
        ),
    );
  }

  /// Show party celebration effect
  void showPartyCelebration(Vector2 position) {
    _addEffect(
      FlameParticleEffect.explosion(
          position: position.clone(),
          color: Colors.amber,
          radius: 60.0,
        ),
    );
  }
}
