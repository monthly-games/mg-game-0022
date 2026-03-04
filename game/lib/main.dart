import 'package:flutter/material.dart';
import 'package:mg_common_game/systems/progression/achievement_manager.dart';
import 'package:mg_common_game/systems/quests/daily_quest.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'package:mg_common_game/systems/progression/upgrade_manager.dart';
import 'core/game_state.dart';
import 'core/managers/save_manager.dart';
import 'core/managers/mini_game_manager.dart';
import 'core/managers/progress_manager.dart';
import 'core/managers/reward_manager.dart';
import 'ui/main_menu_screen.dart';

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
  // DailyQuest 시스템
  GetIt.I.registerSingleton(DailyQuestManager());
  // Achievement 시스템
  GetIt.I.registerSingleton(AchievementManager());
  _registerAchievements();
  _registerDailyQuests();
    _registerUpgrades(di.get<UpgradeManager>());
  }
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
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
        ),
        home: const MainMenuScreen(),
      ),
    );
  }
}


void _registerDailyQuests() {
  final dailyQuest = GetIt.I<DailyQuestManager>();
  
  dailyQuest.registerQuest(DailyQuest(
    id: 'collect_gold',
    title: '골드 모으기',
    description: '골드 1000 획득',
    targetValue: 1000,
    goldReward: 500,
    xpReward: 10,
  ));
  
  dailyQuest.registerQuest(DailyQuest(
    id: 'play_games',
    title: '게임 플레이',
    description: '게임 5판 플레이',
    targetValue: 5,
    goldReward: 300,
    xpReward: 5,
  ));
  
  dailyQuest.registerQuest(DailyQuest(
    id: 'level_up',
    title: '레벨업',
    description: '레벨 1 상승',
    targetValue: 1,
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
