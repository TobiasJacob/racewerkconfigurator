import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/i18n/languages.dart';
import 'package:racewerkconfigurator/pages/settings/settings_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/settings_provider.dart';

class LanguageSettingTile extends ConsumerWidget {
  const LanguageSettingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final String languageCode = ref.watch(settingsProvider.select((value) => value.languageCode));
    final appSettingsNotifier = ref.read(settingsProvider.notifier);

    return SettingsTile(
        title: lang.languageSettings,
        child: DropdownButton<String>(
          onChanged: (value) {
            final String languageCode = value!;
            var countryCode = "US";
            if (value == "de") {
              countryCode = "DE";
            }
            final appSettings = ref.watch(settingsProvider);
            appSettingsNotifier.update(appSettings.updateLanguage(languageCode, countryCode));
          },
          value: languageCode,
          items: [
            DropdownMenuItem(
              value: "en",
              child: Text(lang.english),
            ),
            DropdownMenuItem(
              value: "de",
              child: Text(lang.german),
            ),
          ],
        ));
  }
}
