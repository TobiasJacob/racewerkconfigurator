import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:racewerkconfigurator/data/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../i18n/app_localization_delegate.dart';

class AppData extends ConsumerWidget {
  final Widget home;

  const AppData({super.key, required this.home});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = "Pedal Config";
    final languageCode =
        ref.watch(settingsProvider.select((value) => value.languageCode));
    final countryCode =
        ref.watch(settingsProvider.select((value) => value.countryCode));

    return MaterialApp(
      darkTheme: ThemeData(
        primaryColor: const Color.fromRGBO(185, 101, 254, 1),
        secondaryHeaderColor: const Color.fromRGBO(80, 254, 0, 1),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromRGBO(24, 24, 24, 1),
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      title: title,
      debugShowCheckedModeBanner: true,
      locale: Locale(languageCode, countryCode),
      home: home,
      supportedLocales: const [Locale('en', 'EN'), Locale('de', 'DE')],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
