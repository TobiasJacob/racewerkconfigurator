import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/pages/settings/language_settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(child: LanguageSettingTile()),
    );
  }
}
