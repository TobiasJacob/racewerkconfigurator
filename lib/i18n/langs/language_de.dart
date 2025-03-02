import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../languages.dart';

class LanguageDe extends Languages {
  @override
  String get appName => "Pedal Konfigurator";

  @override
  String get yes => "Ja";

  @override
  String get no => "Nein";

  @override
  String get error => "Fehler";

  @override
  String get ok => "Ok";

  @override
  String get info => "Info";

  @override
  String get newProfile => "Neues Profil";

  @override
  String get profiles => "Profile";

  // @override
  // String axisTileOptions(ProfileTileAction option) {
  //   switch (option) {
  //     case ProfileTileAction.duplicate:
  //       return "Duplizieren";
  //     case ProfileTileAction.export:
  //       return "Exportieren";
  //     case ProfileTileAction.delete:
  //       return "Löschen";
  //     default:
  //       return "Undefined";
  //   }
  // }

  @override
  String get addEmptyProfile => "Leeres Profil hinzufügen";

  @override
  String get importProfile => "Profil importieren";

  @override
  String get openFile => "Datei öffnen";

  @override
  String get settings => "Einstellungen";

  @override
  String get english => "Englisch";

  @override
  String get german => "Deutsch";

  @override
  String get channelSettings => "Kanal";

  @override
  String get languageSettings => "Sprache";

  @override
  String channelUsage(ChannelUsage usage) {
    switch (usage) {
      case ChannelUsage.gas:
        return "Gas";
      case ChannelUsage.brake:
        return "Bremse";
      case ChannelUsage.clutch:
        return "Kupplung";
      case ChannelUsage.handbrake:
        return "Handbremse";
      case ChannelUsage.other:
        return "Sonstiges";
      default:
        return "Unbenutzt";
    }
  }

  @override
  String buttonUsage(ButtonUsage usage) {
    switch (usage) {
      case ButtonUsage.hold:
        return "Halten";
      case ButtonUsage.trigger:
        return "Trigger";
      case ButtonUsage.toggle:
        return "Schalter";
      default:
        return "Unbenutzt";
    }
  }

  @override
  String get saveFile => "Datei speichern";

  @override
  String fileExistsOverwrite(String filename) {
    return "Die Datei $filename existiert bereits. Überschreiben?";
  }

  @override
  String get overwrite => "Überschreiben";

  @override
  String get deleteProfile => "Profil löschen";

  @override
  String get wantToDeleteProfile => "Möchten Sie das Profil löschen?";

  @override
  String get uploadProfile => "Profil aktivieren";

  @override
  String errorUploadProfile(String msg) {
    return "Fehler beim Aktivieren des Profils: $msg";
  }

  @override
  String get errorNotConnected => "Gerät nicht verbunden";

  @override
  String get nSlashA => "N/A";

  @override
  String get on => "An";

  @override
  String get off => "Aus";

  @override
  String get smoothing => "Glättung";

  @override
  String editProfile(String profile) {
    return "Bearbeite $profile";
  }

  @override
  String get saveProfile => "Profil speichern";

  @override
  String get wantToSaveProfile => "Möchten Sie das Profil speichern?";

  @override
  String get saveSettings => "Einstellungen speichern";

  @override
  String get wantToSaveSettings => "Möchten Sie die Einstellungen speichern?";

  @override
  String get overwriteProfile => "Profil überschreiben";

  @override
  String get wantToOverwriteProfile => "Möchten Sie das Profil überschreiben?";

  @override
  String channel(int index) {
    return "Kanal $index";
  }

  @override
  String alreadyInUse(ChannelUsage usage) {
    return "Die Funktion ${channelUsage(usage)} ist schon für einen anderen Kanal eingestellt.";
  }

  @override
  String editChannel(ChannelUsage usage) {
    return "${channelUsage(usage)} bearbeiten";
  }

  @override
  String get usageLabel => "Funktion";

  @override
  String get minValue => "Minimum";

  @override
  String get maxValue => "Maximum";

  @override
  String get currentValue => "Aktueller Wert";

  @override
  String get rawValue => "Rohwert";

  @override
  String get inverted => "Invertiert";

  @override
  String get reset => "Reset";

  @override
  String get index => "Index";

  @override
  String get autoCalibration => "Automatische Kalibrierung";

  @override
  String preset(int index)
  {
    return "Voreinstellung $index";
  }
}
