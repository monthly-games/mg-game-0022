import 'package:flutter/material.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';
import 'package:mg_common_game/core/ui/layout/mg_spacing.dart';
import 'package:mg_common_game/core/ui/typography/mg_text_styles.dart';
import 'package:mg_common_game/core/ui/widgets/buttons/mg_icon_button.dart';
import 'package:mg_common_game/core/ui/widgets/progress/mg_linear_progress.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(MGSpacing.sm),
        child: Column(
          children: [
            // 상단 HUD
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 왼쪽: 점수
                _buildScorePanel(),
                SizedBox(width: MGSpacing.sm),
                // 중앙: 타이머
                Expanded(child: _buildTimerPanel()),
                SizedBox(width: MGSpacing.sm),
                // 오른쪽: 일시정지
                if (onPause != null)
                  MGIconButton(
                    icon: Icons.pause,
                    onPressed: onPause!,
                    size: MGIconButtonSize.small,
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
      padding: EdgeInsets.all(MGSpacing.sm),
      decoration: BoxDecoration(
        color: MGColors.surface.withOpacity(0.85),
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
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: MGSpacing.xs),
              Text(
                '$score',
                style: MGTextStyles.h3.copyWith(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: MGSpacing.xxs),
          // 하이스코어
          Text(
            'Best: $highScore',
            style: MGTextStyles.caption.copyWith(
              color: Colors.white70,
            ),
          ),
          // 목표 점수
          if (targetScore != null) ...[
            SizedBox(height: MGSpacing.xxs),
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
      padding: EdgeInsets.all(MGSpacing.sm),
      decoration: BoxDecoration(
        color: MGColors.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(MGSpacing.sm),
        border: Border.all(
          color: isLowTime ? Colors.red : MGColors.border,
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
          SizedBox(height: MGSpacing.xxs),
          // 타이머 바
          MGLinearProgress(
            value: timeRatio,
            height: 12,
            backgroundColor: Colors.grey.withOpacity(0.3),
            progressColor: isLowTime ? Colors.red : Colors.cyan,
          ),
          SizedBox(height: MGSpacing.xxs),
          // 시간 표시
          Text(
            '${timeRemaining.toInt()}s',
            style: MGTextStyles.buttonMedium.copyWith(
              color: isLowTime ? Colors.red : Colors.white,
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
      comboStyle = MGTextStyles.displayLarge;
    } else if (combo >= 10) {
      comboColor = Colors.orangeAccent;
      comboStyle = MGTextStyles.displayMedium;
    } else if (combo >= 5) {
      comboColor = Colors.yellowAccent;
      comboStyle = MGTextStyles.displaySmall;
    } else {
      comboColor = Colors.white;
      comboStyle = MGTextStyles.h3;
    }

    return Padding(
      padding: EdgeInsets.only(top: MGSpacing.sm),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MGSpacing.md,
          vertical: MGSpacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              comboColor.withOpacity(0.8),
              comboColor.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(MGSpacing.md),
          border: Border.all(color: comboColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: comboColor.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department, color: Colors.white, size: 20),
            SizedBox(width: MGSpacing.xs),
            Text(
              '$combo COMBO!',
              style: comboStyle.copyWith(
                color: Colors.white,
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
}
