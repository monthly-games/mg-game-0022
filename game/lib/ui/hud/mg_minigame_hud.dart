import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';
import 'package:mg_common_game/core/ui/layout/mg_spacing.dart';
import 'package:mg_common_game/core/ui/typography/mg_text_styles.dart';
import 'package:mg_common_game/core/ui/widgets/buttons/mg_button.dart';
import 'package:mg_common_game/core/ui/widgets/progress/mg_progress.dart';

/// MG-0022 Monster Party Minigame HUD
/// 미니게임용 HUD - 점수, 시간, 콤보, 목표 표시
class MGMinigameHud extends StatelessWidget {
  final int score;
  final int highScore;
  final double timeRemaining;
  final double totalTime;
  final int combo;
  final int? targetScore;
  final String? gameTitle;
  final VoidCallback? onPause;
  final VoidCallback? onDailyHub;
  final VoidCallback? onGuildWar;
  final VoidCallback? onTournament;
  final VoidCallback? onSeasonalEvent;

  const MGMinigameHud({
    super.key,
    required this.score,
    required this.highScore,
    required this.timeRemaining,
    required this.totalTime,
    this.combo = 0,
    this.targetScore,
    this.gameTitle,
    this.onPause,
    this.onDailyHub,
    this.onGuildWar,
    this.onTournament,
    this.onSeasonalEvent,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(MGSpacing.sm),
        child: Column(
          children: [
            // 상단 HUD
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 왼쪽: 점수
                _buildScorePanel(),
                const SizedBox(width: MGSpacing.sm),
                // 중앙: 타이머
                Expanded(child: _buildTimerPanel()),
                const SizedBox(width: MGSpacing.sm),
                // 오른쪽: 일시정지
                if (onGuildWar != null)
                  MGIconButton(
                    icon: Icons.shield,
                    onPressed: onGuildWar!,
                    buttonSize: MGIconButtonSize.small,
                  ),
                const SizedBox(width: MGSpacing.xs),
                if (onTournament != null)
                  MGIconButton(
                    icon: Icons.emoji_events,
                    onPressed: onTournament!,
                    buttonSize: MGIconButtonSize.small,
                  ),
                const SizedBox(width: MGSpacing.xs),
                if (onSeasonalEvent != null)
                  MGIconButton(
                    icon: Icons.celebration,
                    onPressed: onSeasonalEvent!,
                    buttonSize: MGIconButtonSize.small,
                  ),
                const SizedBox(width: MGSpacing.xs),
                if (onDailyHub != null)
                  MGIconButton(
                    icon: Icons.calendar_today,
                    onPressed: onDailyHub!,
                    buttonSize: MGIconButtonSize.small,
                  ),
                const SizedBox(width: MGSpacing.xs),
                if (onPause != null)
                  MGIconButton(
                    icon: Icons.pause,
                    onPressed: onPause!,
                    buttonSize: MGIconButtonSize.small,
                  ),
              ],
            ),
            // 콤보 표시
            if (combo > 1) _buildComboDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildScorePanel() {
    return Container(
      padding: const EdgeInsets.all(MGSpacing.sm),
      decoration: BoxDecoration(
        color: MGColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(MGSpacing.sm),
        border: Border.all(color: MGColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 현재 점수
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: MGSpacing.xs),
              Text(
                '$score',
                style: MGTextStyles.h3.copyWith(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: MGSpacing.xxs),
          // 하이스코어
          Text(
            'Best: $highScore',
            style: MGTextStyles.caption.copyWith(
              color: Colors.white70,
            ),
          ),
          // 목표 점수
          if (targetScore != null) ...[
            const SizedBox(height: MGSpacing.xxs),
            Text(
              'Goal: $targetScore',
              style: MGTextStyles.caption.copyWith(
                color: score >= targetScore!
                    ? Colors.greenAccent
                    : Colors.white54,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimerPanel() {
    final double timeRatio = totalTime > 0 ? timeRemaining / totalTime : 0;
    final bool isLowTime = timeRatio < 0.25;

    return Container(
      padding: const EdgeInsets.all(MGSpacing.sm),
      decoration: BoxDecoration(
        color: MGColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(MGSpacing.sm),
        border: Border.all(
          color: isLowTime ? MGColors.error : MGColors.border,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (gameTitle != null)
            Text(
              gameTitle!,
              style: MGTextStyles.buttonSmall.copyWith(
                color: Colors.white70,
              ),
            ),
          const SizedBox(height: MGSpacing.xxs),
          // 타이머 바
          MGLinearProgress(
            value: timeRatio,
            height: 12,
            backgroundColor: MGColors.common.withValues(alpha: 0.3),
            valueColor: isLowTime ? MGColors.error : Colors.cyan,
          ),
          const SizedBox(height: MGSpacing.xxs),
          // 시간 표시
          Text(
            '${timeRemaining.toInt()}s',
            style: MGTextStyles.buttonMedium.copyWith(
              color: isLowTime ? MGColors.error : MGColors.textHighEmphasis,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboDisplay() {
    Color comboColor;
    TextStyle comboStyle;

    if (combo >= 20) {
      comboColor = Colors.purpleAccent;
      comboStyle = MGTextStyles.display;
    } else if (combo >= 10) {
      comboColor = Colors.orangeAccent;
      comboStyle = MGTextStyles.display;
    } else if (combo >= 5) {
      comboColor = Colors.yellowAccent;
      comboStyle = MGTextStyles.display;
    } else {
      comboColor = MGColors.textHighEmphasis;
      comboStyle = MGTextStyles.h3;
    }

    return Padding(
      padding: const EdgeInsets.only(top: MGSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: MGSpacing.md,
          vertical: MGSpacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              comboColor.withValues(alpha: 0.8),
              comboColor.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(MGSpacing.md),
          border: Border.all(color: comboColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: comboColor.withValues(alpha: 0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department, color: MGColors.textHighEmphasis, size: 20),
            const SizedBox(width: MGSpacing.xs),
            Text(
              '$combo COMBO!',
              style: comboStyle.copyWith(
                color: MGColors.textHighEmphasis,
                fontWeight: FontWeight.bold,
                shadows: [
                  const Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSpineCharacter() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.lightGreen.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.lightGreen.withAlpha(150), width: 2),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 24, color: Colors.white),
            SizedBox(height: 2),
            Text(
              'Zombie Hunter',
              style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

}
