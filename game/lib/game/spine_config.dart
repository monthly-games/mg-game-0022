import 'package:mg_common_game/core/assets/asset_types.dart';

/// Spine 통합 플래그. `--dart-define=SPINE_ENABLED=true`로 활성화.
const kSpineEnabled = bool.fromEnvironment(
  'SPINE_ENABLED',
  defaultValue: false,
);

// ── Monster Slime ────────────────────────────────────────────

const kMonsterSlimeMeta = SpineAssetMeta(
  key: 'monster_slime',
  path: 'spine/characters/monster_slime',
  atlasPath:
      'assets/spine/characters/monster_slime/monster_slime.atlas',
  skeletonPath:
      'assets/spine/characters/monster_slime/monster_slime.json',
  animations: ['idle', 'walk', 'attack', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);

// ── Monster Dragon ───────────────────────────────────────────

const kMonsterDragonMeta = SpineAssetMeta(
  key: 'monster_dragon',
  path: 'spine/characters/monster_dragon',
  atlasPath:
      'assets/spine/characters/monster_dragon/monster_dragon.atlas',
  skeletonPath:
      'assets/spine/characters/monster_dragon/monster_dragon.json',
  animations: ['idle', 'walk', 'attack', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);

// ── Monster Golem ────────────────────────────────────────────

const kMonsterGolemMeta = SpineAssetMeta(
  key: 'monster_golem',
  path: 'spine/characters/monster_golem',
  atlasPath:
      'assets/spine/characters/monster_golem/monster_golem.atlas',
  skeletonPath:
      'assets/spine/characters/monster_golem/monster_golem.json',
  animations: ['idle', 'walk', 'attack', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);
