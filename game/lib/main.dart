import 'package:mg_common_game/mg_common_game.dart' hide SaveManager;
import 'package:mg_common_game/core/localization/localization.dart';
import 'package:mg_common_game/core/ui/accessibility/accessibility_settings.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'core/game_state.dart';
import 'core/managers/save_manager.dart';
import 'core/managers/mini_game_manager.dart';
import 'core/managers/progress_manager.dart';
import 'core/managers/reward_manager.dart';
import 'ui/main_menu_screen.dart';
import 'screens/daily_quest_screen.dart';
import 'screens/achievement_screen.dart';
import 'screens/battlepass_screen.dart';
import 'screens/gacha_screen.dart';
import 'screens/collection_screen.dart';
// // import 'game/tutorial_config.dart'; // TutorialManager not available
// import 'game/balancing_config.dart'; // BalancingManager not available
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:mg_common_game/systems/quests/daily_quest_v2.dart';
// import 'package:mg_common_game/core/ui/screens/daily_quest_screen_v2.dart';
// import 'package:mg_common_game/l10n/localization.dart';
import 'package:mg_common_game/l10n/extensions.dart';
// 
void main() async {
WidgetsFlutterBinding.ensureInitialized();
await _setupDI();
await GetIt.I<AudioManager>().initialize();
// Load saved state
final saveManager = GetIt.I<SaveManager>();
final initialState = await saveManager.loadGameState() ?? GameState();
// Load saved upgrade levels
final upgradeManager = GetIt.I<UpgradeManager>();
await upgradeManager.loadUpgrades();
// Apply upgrade effects to RewardManager
_applyUpgradeEffects(upgradeManager);
// ── Tutorial & Balancing ──────────────────────────────────
if (!GetIt.I.isRegistered<TutorialManager>()) {
final tutorialManager = TutorialManager();
await tutorialManager.initialize();
tutorialManager.registerTutorial(
kOnboardingTutorial.id,
kOnboardingTutorial.steps,
);
GetIt.I.registerSingleton<TutorialManager>(tutorialManager);
}
if (!GetIt.I.isRegistered<BalancingManager>()) {
GetIt.I.registerSingleton<BalancingManager>(
BalancingManager(defaultConfig: kDefaultBalancingConfig),
);
}
// ── Q7 DI Fix: Missing Systems ──────────────────────────
if (!GetIt.I.isRegistered<BattlePassManager>()) {
GetIt.I.registerSingleton<BattlePassManager>(BattlePassManager());
}
if (!GetIt.I.isRegistered<GachaManager>()) {
GetIt.I.registerSingleton<GachaManager>(GachaManager());
}
runApp(MonsterPartyApp(initialState: initialState));
}
Future<void> _setupDI() async {
final di = GetIt.I;
// Core services
if (!di.isRegistered<AudioManager>()) {
di.registerSingleton<AudioManager>(AudioManager());
}
if (!di.isRegistered<SaveManager>()) {
di.registerSingleton<SaveManager>(SaveManager());
}
// Hub managers
if (!di.isRegistered<MiniGameManager>()) {
di.registerSingleton<MiniGameManager>(MiniGameManager());
}
if (!di.isRegistered<ProgressManager>()) {
di.registerSingleton<ProgressManager>(ProgressManager());
}
if (!di.isRegistered<RewardManager>()) {
di.registerSingleton<RewardManager>(RewardManager());
}
// Upgrade system
if (!di.isRegistered<UpgradeManager>()) {
di.registerSingleton<UpgradeManager>(UpgradeManager());
_registerUpgrades(di.get<UpgradeManager>());
}
// DailyQuest 시스템
if (!GetIt.I.isRegistered<DailyQuestManager>()) {
// Daily Quest V2 - 7 Quest System with Streak Bonuses
if (!GetIt.I.isRegistered<DailyQuestManagerV2>()) {
final questManager = DailyQuestManagerV2();
// Slot 0: Login Quest
questManager.registerQuest(
DailyQuestV2(
id: 'quest_slot_0',
title: 'Daily Login',
description: 'Start your adventure!',
type: QuestType.login,
tier: QuestTier.easy,
targetValue: 1,
baseGoldReward: 50,
baseXpReward: 20,
),
slotIndex: 0,
);
// Slot 1: Play Quest
questManager.registerQuest(
DailyQuestV2(
id: 'quest_slot_1',
title: 'Platform Play',
description: 'Play 5 levels',
type: QuestType.play,
tier: QuestTier.easy,
targetValue: 5,
baseGoldReward: 100,
baseXpReward: 40,
),
slotIndex: 1,
);
// Slot 2: Win Quest
questManager.registerQuest(
DailyQuestV2(
id: 'quest_slot_2',
title: 'Score Chaser',
description: 'Score 500 total points',
type: QuestType.win,
tier: QuestTier.medium,
targetValue: 500,
baseGoldReward: 150,
baseXpReward: 75,
),
slotIndex: 2,
);
// Slot 3: Upgrade Quest
questManager.registerQuest(
DailyQuestV2(
id: 'quest_slot_3',
title: 'Collect Coins',
description: 'Collect 100 coins',
type: QuestType.upgrade,
tier: QuestTier.easy,
targetValue: 100,
baseGoldReward: 120,
baseXpReward: 50,
),
slotIndex: 3,
);
// Slot 4: Social Quest
questManager.registerQuest(
DailyQuestV2(
id: 'quest_slot_4',
title: 'Challenge Friends',
description: 'Challenge 3 friends',
type: QuestType.social,
tier: QuestTier.easy,
targetValue: 3,
baseGoldReward: 100,
baseXpReward: 40,
),
slotIndex: 4,
);
// Slot 5: Achievement Quest
questManager.registerQuest(
DailyQuestV2(
id: 'quest_slot_5',
title: 'Level Complete',
description: 'Complete 3 levels',
type: QuestType.achievement,
tier: QuestTier.medium,
targetValue: 3,
baseGoldReward: 200,
baseXpReward: 80,
),
slotIndex: 5,
);
// Slot 6: Bonus Quest
questManager.registerQuest(
DailyQuestV2(
id: 'quest_slot_6',
title: 'Perfect Level',
description: 'Complete a level without dying',
type: QuestType.bonus,
tier: QuestTier.special,
targetValue: 1,
baseGoldReward: 300,
baseXpReward: 120,
baseGemReward: 10,
),
slotIndex: 6,
);
// Setup streak bonus callbacks
questManager.onStreakMilestoneReached = (streak) {
if (GetIt.I.isRegistered<SettingsManager>()) {
GetIt.I<SettingsManager>().triggerVibration(
intensity: VibrationIntensity.heavy,
);
}
};
if (!GetIt.I.isRegistered<questManager>()) {
    GetIt.I.registerSingleton(questManager);
  };
await questManager.loadQuestData();
await questManager.checkAndResetIfNeeded();
}
//   }
//   // Achievement 시스템
//   if (!GetIt.I.isRegistered<AchievementManager>()) {
//     if (!GetIt.I.isRegistered<AchievementManager(>()) {
    GetIt.I.registerSingleton(AchievementManager());
  });
//   }
// 
//   // Prestige 시스템 (mg_common_game)
  if (!GetIt.I.isRegistered<PrestigeManager>()) {
    final prestigeManager = PrestigeManager();
    if (!GetIt.I.isRegistered<prestigeManager>()) {
    GetIt.I.registerSingleton(prestigeManager);
  };
    _setupPrestige(prestigeManager);
    await prestigeManager.loadPrestigeData();
  }

  // Collection 시스템
  if (!GetIt.I.isRegistered<CollectionManager>()) {
    if (!GetIt.I.isRegistered<CollectionManager(>()) {
    GetIt.I.registerSingleton(CollectionManager());
  });
    _registerCollections();
  }

  // ── Retention Systems for DailyHub ────────────────────────
  //   if (!GetIt.I.isRegistered<LoginRewardsManager>()) {
  //     if (!GetIt.I.isRegistered<LoginRewardsManager(>()) {
    GetIt.I.registerSingleton(LoginRewardsManager());
  });
  //   }
  //   if (!GetIt.I.isRegistered<StreakManager>()) {
  //     if (!GetIt.I.isRegistered<StreakManager(>()) {
    GetIt.I.registerSingleton(StreakManager());
  });
  //   }
  //   if (!GetIt.I.isRegistered<DailyChallengeManager>()) {
  //     if (!GetIt.I.isRegistered<DailyChallengeManager(>()) {
    GetIt.I.registerSingleton(DailyChallengeManager());
  });
  //   }

  //   // ── P3 Engine Systems ─────────────────────────────────────
  //   if (!GetIt.I.isRegistered<GuildWarManager>()) {
  //     if (!GetIt.I.isRegistered<GuildWarManager(>()) {
    GetIt.I.registerSingleton(GuildWarManager());
  });
  //   }
  //   if (!GetIt.I.isRegistered<TournamentManager>()) {
  //     if (!GetIt.I.isRegistered<TournamentManager(>()) {
    GetIt.I.registerSingleton(TournamentManager());
  });
  //   }
  //   if (!GetIt.I.isRegistered<SeasonalContentManager>()) {
  //     if (!GetIt.I.isRegistered<SeasonalContentManager(>()) {
    GetIt.I.registerSingleton(SeasonalContentManager());
  });
  //   }

  _registerAchievements();
  _registerDailyQuests();
}

/// Registers 8 upgrades spanning coin boosts, XP multipliers,
/// ticket capacity, and per-minigame performance buffs.
void _registerUpgrades(UpgradeManager manager) {
  manager.registerUpgrade(Upgrade(
    id: 'coin_boost',
    name: 'Coin Boost',
    description: 'Increases coin rewards from all mini-games',
    maxLevel: 10,
    baseCost: 100,
    costMultiplier: 1.5,
    valuePerLevel: 0.1, // +10% per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'xp_boost',
    name: 'XP Boost',
    description: 'Increases XP rewards from all mini-games',
    maxLevel: 10,
    baseCost: 120,
    costMultiplier: 1.5,
    valuePerLevel: 0.1, // +10% per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'ticket_capacity',
    name: 'Ticket Pouch',
    description: 'Increases maximum ticket capacity',
    maxLevel: 5,
    baseCost: 200,
    costMultiplier: 2.0,
    valuePerLevel: 1.0, // +1 max ticket per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'time_extension',
    name: 'Time Extension',
    description: 'Adds bonus seconds to timed mini-games',
    maxLevel: 5,
    baseCost: 150,
    costMultiplier: 1.8,
    valuePerLevel: 2.0, // +2 seconds per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'score_multiplier',
    name: 'Score Multiplier',
    description: 'Multiplies base score from all games',
    maxLevel: 8,
    baseCost: 250,
    costMultiplier: 1.6,
    valuePerLevel: 0.05, // +5% per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'monster_xp_rate',
    name: 'Monster Training',
    description: 'Increases monster XP gain rate',
    maxLevel: 10,
    baseCost: 80,
    costMultiplier: 1.4,
    valuePerLevel: 0.15, // +15% per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'streak_bonus',
    name: 'Streak Power',
    description: 'Increases daily streak bonus rewards',
    maxLevel: 5,
    baseCost: 300,
    costMultiplier: 1.7,
    valuePerLevel: 0.2, // +20% streak bonus per level
  ));

  manager.registerUpgrade(Upgrade(
    id: 'star_threshold',
    name: 'Star Magnet',
    description: 'Lowers score thresholds for earning stars',
    maxLevel: 5,
    baseCost: 400,
    costMultiplier: 2.0,
    valuePerLevel: 0.05, // -5% threshold per level
  ));
}

/// Applies current upgrade levels to runtime managers.
void _applyUpgradeEffects(UpgradeManager upgradeManager) {
  final rewardManager = GetIt.I<RewardManager>();

  final coinBoost = upgradeManager.getUpgrade('coin_boost');
  if (coinBoost != null) {
    rewardManager.setCoinMultiplier(1.0 + coinBoost.currentValue);
  }

  final xpBoost = upgradeManager.getUpgrade('xp_boost');
  if (xpBoost != null) {
    rewardManager.setXpMultiplier(1.0 + xpBoost.currentValue);
  }
}

class MonsterPartyApp extends StatelessWidget {
  final GameState initialState;

  const MonsterPartyApp({super.key, required this.initialState});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => initialState),
        ChangeNotifierProvider.value(value: GetIt.I<MiniGameManager>()),
        ChangeNotifierProvider.value(value: GetIt.I<ProgressManager>()),
        ChangeNotifierProvider.value(value: GetIt.I<RewardManager>()),
        ChangeNotifierProvider.value(value: GetIt.I<UpgradeManager>()),
      ],
      child: MaterialApp(
        title: 'Monster Party',
      supportedLocales: mgSupportedLocales,
      localizationsDelegates: mgLocalizationDelegates,
                localizationsDelegates: mgLocalizationDelegates,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
        ),
        routes: {
          '/daily-quests': (_) => const DailyQuestScreen(),
          '/achievements': (_) => const AchievementScreen(),
          '/daily_quest': (_) => const DailyQuestScreen(),
          '/achievement': (_) => const AchievementScreen(),
          '/battlepass': (_) => const BattlePassScreen(),
          '/gacha': (_) => const GachaScreen(),
        '/daily-hub': (context) => DailyHubScreen(
          questManager: GetIt.I<DailyQuestManager>(),
          loginRewardsManager: GetIt.I<LoginRewardsManager>(),
          streakManager: GetIt.I<StreakManager>(),
          challengeManager: GetIt.I<DailyChallengeManager>(),
          accentColor: MGColors.primaryAction,
          onClose: () => Navigator.pop(context),
        ),
        
          '/collection': (context) => CollectionScreen(
            collectionManager: GetIt.I<CollectionManager>(),
          ),
          '/guild-war': (context) => GuildWarScreen(
            guildWarManager: GetIt.I<GuildWarManager>(),
            accentColor: MGColors.primaryAction,
            onClose: () => Navigator.pop(context),
            ),
          '/tournament': (context) => TournamentScreen(
            tournamentManager: GetIt.I<TournamentManager>(),
            accentColor: MGColors.primaryAction,
            onClose: () => Navigator.pop(context),
            ),
          '/seasonal-event': (context) => SeasonalEventScreen(
            seasonalContentManager: GetIt.I<SeasonalContentManager>(),
            accentColor: MGColors.primaryAction,
            onClose: () => Navigator.pop(context),
            ),
},
        home: const MainMenuScreen(),
      ),
    );
  }
}


void _registerDailyQuests() {
  final dailyQuest = GetIt.I<DailyQuestManager>();

  dailyQuest.registerQuest(DailyQuest(
    id: 'play_minigames',
    title: '미니게임 플레이',
    description: '미니게임 7회 플레이',
    targetValue: 7,
    goldReward: 500,
    xpReward: 10,
  ));

  dailyQuest.registerQuest(DailyQuest(
    id: 'earn_stars',
    title: '별 획득',
    description: '별 30개 획득',
    targetValue: 30,
    goldReward: 300,
    xpReward: 5,
  ));

  dailyQuest.registerQuest(DailyQuest(
    id: 'high_scores',
    title: '고득점 달성',
    description: '고득점 3회 달성',
    targetValue: 3,
    goldReward: 200,
    xpReward: 3,
  ));
}


void _registerAchievements() {
  final achievement = GetIt.I<AchievementManager>();
  
  achievement.registerAchievement(Achievement(
    id: 'gold_1000',
    title: '골드 1000 달성',
    description: '총 골드 1000을 모으세요',
    iconAsset: 'assets/achievements/gold_1000.png',
  ));
  
  achievement.registerAchievement(Achievement(
    id: 'level_10',
    title: '레벨 10 달성',
    description: '레벨 10에 도달하세요',
    iconAsset: 'assets/achievements/level_10.png',
  ));
  
  achievement.registerAchievement(Achievement(
    id: 'play_100',
    title: '100판 플레이',
    description: '게임을 100판 플레이하세요',
    iconAsset: 'assets/achievements/play_100.png',
  ));
}

void _setupPrestige(PrestigeManager manager) {
  // ── Prestige Upgrades (idle game defaults) ──────────────────
  // Five core upgrades for idle games
  manager.registerPrestigeUpgrade(PrestigeUpgrade(
    id: 'gold_multiplier',
    name: '골드 배수',
    description: '골드 획득량 +10%',
    maxLevel: 50,
    costPerLevel: 1,
    bonusPerLevel: 0.1,
  ));

  manager.registerPrestigeUpgrade(PrestigeUpgrade(
    id: 'xp_boost',
    name: 'XP 부스트',
    description: 'XP 획득량 +15%',
    maxLevel: 40,
    costPerLevel: 2,
    bonusPerLevel: 0.15,
  ));

  manager.registerPrestigeUpgrade(PrestigeUpgrade(
    id: 'production_speed',
    name: '생산 속도',
    description: '생산 속도 +20%',
    maxLevel: 30,
    costPerLevel: 2,
    bonusPerLevel: 0.2,
  ));

  manager.registerPrestigeUpgrade(PrestigeUpgrade(
    id: 'starting_resources',
    name: '초기 자원',
    description: '초기 자원 +5%',
    maxLevel: 60,
    costPerLevel: 1,
    bonusPerLevel: 0.05,
  ));

  manager.registerPrestigeUpgrade(PrestigeUpgrade(
    id: 'offline_income',
    name: '오프라인 수익',
    description: '오프라인 수익 +20%',
    maxLevel: 30,
    costPerLevel: 3,
    bonusPerLevel: 0.2,
  ));

  // ── Prestige Reset Callbacks ────────────────────────────────
  // TODO: Add game-specific reset callbacks:
  // manager.registerResetCallback(() {
  //   if (GetIt.I.isRegistered<ProgressionManager>()) {
  //     GetIt.I<ProgressionManager>().reset();
  //   }
  //   if (GetIt.I.isRegistered<UpgradeManager>()) {
  //     GetIt.I<UpgradeManager>().reset();
  //   }
  // });
}

void _registerCollections() {
  final collection = GetIt.I<CollectionManager>();

  // Characters 컬렉션
  collection.registerCollection(Collection(
    id: 'characters',
    name: '캐릭터',
    description: '모든 캐릭터를 수집하세요',
    items: [
      const CollectionItem(
        id: 'char_warrior',
        name: '전사',
        description: '강인한 근접 전투 캐릭터',
        rarity: CollectionRarity.common,
      ),
      const CollectionItem(
        id: 'char_mage',
        name: '마법사',
        description: '강력한 마법 공격 캐릭터',
        rarity: CollectionRarity.rare,
      ),
      const CollectionItem(
        id: 'char_archer',
        name: '궁수',
        description: '원거리 정밀 공격 캐릭터',
        rarity: CollectionRarity.rare,
      ),
      const CollectionItem(
        id: 'char_assassin',
        name: '암살자',
        description: '치명적인 은신 공격 캐릭터',
        rarity: CollectionRarity.epic,
      ),
      const CollectionItem(
        id: 'char_healer',
        name: '힐러',
        description: '팀을 치유하는 지원 캐릭터',
        rarity: CollectionRarity.legendary,
      ),
    ],
    completionReward: const CollectionReward(type: RewardType.gold, amount: 10000),
    milestoneRewards: {
      25: const CollectionReward(type: RewardType.gold, amount: 1000),
      50: const CollectionReward(type: RewardType.gold, amount: 3000),
      75: const CollectionReward(type: RewardType.gold, amount: 5000),
    },
  ));

  // 아이템 해제 콜백 (햅틱 피드백)
  collection.onItemUnlocked = (collectionId, itemId) {
    // SettingsManager가 등록되어 있으면 햅틱 피드백
    debugPrint('Collection item unlocked: $collectionId / $itemId');
  };
}
