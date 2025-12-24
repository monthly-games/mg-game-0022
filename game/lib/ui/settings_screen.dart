import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Background Music'),
            subtitle: const Text('Enable or disable music'),
            value: _isMusicOn,
            onChanged: _toggleMusic,
            secondary: const Icon(Icons.music_note),
          ),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Enable or disable effects'),
            value: _isSfxOn,
            onChanged: _toggleSfx,
            secondary: const Icon(Icons.speaker),
          ),
          const Divider(),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0+1 (Phase 4)'),
          ),
        ],
      ),
    );
  }
}
