import 'package:flutter/material.dart';import 'package:mg_common_game/l10n/localization.dart';
import 'package:mg_common_game/core/localization/localization.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock state for prototype since AudioManager might not expose getters easily
  // In a real app, we'd sync this with AudioManager or SharedPreferences.
  bool _isMusicOn = true;
  bool _isSfxOn = true;

  @override
  void initState() {
    super.initState();
    // TODO: Load from prefs
  }

  void _toggleMusic(bool value) {
    setState(() {
      _isMusicOn = value;
    });
    // AudioManager integration would go here
    // GetIt.I<AudioManager>().setMusicEnabled(value);
  }

  void _toggleSfx(bool value) {
    setState(() {
      _isSfxOn = value;
    });
    // GetIt.I<AudioManager>().setSfxEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings_settings_coming_soon'.tr)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('menu_navigation_background_music'.tr),
            subtitle: Text('settings_enable_or_disable_music'.tr),
            value: _isMusicOn,
            onChanged: _toggleMusic,
            secondary: const Icon(Icons.music_note),
          ),
          SwitchListTile(
            title: Text('settings_sound_effects'.tr),
            subtitle: Text('ui_general_enable_or_disable_effects'.tr),
            value: _isSfxOn,
            onChanged: _toggleSfx,
            secondary: const Icon(Icons.speaker),
          ),
          const Divider(),
          ListTile(
            title: Text('ui_general_version_100'.tr),
            subtitle: Text('ui_general_1001_phase_4'.tr),
          ),
        ],
      ),
    );
  }
}
