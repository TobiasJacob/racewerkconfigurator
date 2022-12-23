import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../languages.dart';

class LanguageEn extends Languages {
  @override
  String get appName => "Pedal Configurator";

  @override
  String axisTileOptions(String option) {
    switch (option) {
      case "Export":
        return "Export";
      case "Delete":
        return "Delete";
      default:
        return "Undefined";
    }
  }

  @override
  String get settings => "Settings";

  @override
  String get english => "English";

  @override
  String get german => "German";

  @override
  String get channelSettings => "Channels";

  @override
  String get languageSettings => "Language";

  @override
  String usage(Usage usage) {
    switch (usage) {
      case Usage.gas:
        return "Gas";
      case Usage.brake:
        return "Brake";
      case Usage.clutch:
        return "Clutch";
      case Usage.handbrake:
        return "Handbrake";
      default:
        return "Not used";
    }
  }
}
