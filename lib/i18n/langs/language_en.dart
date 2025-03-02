import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../languages.dart';

class LanguageEn extends Languages {
  @override
  String get appName => "Pedal Configurator";

  @override
  String get yes => "Yes";

  @override
  String get no => "No";

  @override
  String get error => "Error";

  @override
  String get ok => "Ok";

  @override
  String get info => "Info";

  @override
  String get newProfile => "New Profile";

  @override
  String get profiles => "Profiles";

  // @override
  // String axisTileOptions(ProfileTileAction option) {
  //   switch (option) {
  //     case ProfileTileAction.duplicate:
  //       return "Duplicate";
  //     case ProfileTileAction.export:
  //       return "Export";
  //     case ProfileTileAction.delete:
  //       return "Delete";
  //     default:
  //       return "Undefined";
  //   }
  // }

  @override
  String get addEmptyProfile => "Add empty profile";

  @override
  String get importProfile => "Import profile";

  @override
  String get openFile => "Open file";

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
  String channelUsage(ChannelUsage usage) {
    switch (usage) {
      case ChannelUsage.gas:
        return "Gas";
      case ChannelUsage.brake:
        return "Brake";
      case ChannelUsage.clutch:
        return "Clutch";
      case ChannelUsage.handbrake:
        return "Handbrake";
      case ChannelUsage.other:
        return "Other";
      default:
        return "Not used";
    }
  }

  @override
  String buttonUsage(ButtonUsage usage) {
    switch (usage) {
      case ButtonUsage.hold:
        return "Hold";
      case ButtonUsage.trigger:
        return "Trigger";
      case ButtonUsage.toggle:
        return "Toggle";
      default:
        return "Unused";
    }
  }

  @override
  String get saveFile => "Save File";

  @override
  String fileExistsOverwrite(String filename) {
    return "File $filename exists. Overwrite?";
  }

  @override
  String get overwrite => "Overwrite";

  @override
  String get deleteProfile => "Delete Profile";

  @override
  String get wantToDeleteProfile => "Do you want to delete the profile?";

  @override
  String get uploadProfile => "Activate Profile";

  @override
  String errorUploadProfile(String msg) {
    return "Error activating profile: $msg";
  }

  @override
  String get errorNotConnected => "Not connected to device";

  @override
  String get nSlashA => "N/A";

  @override
  String get on => "On";

  @override
  String get off => "Off";

  @override
  String editProfile(String profile) {
    return "Edit $profile";
  }

  @override
  String get saveProfile => "Save profile";

  @override
  String get wantToSaveProfile => "Do you want to save the profile?";

  @override
  String get saveSettings => "Save settings";

  @override
  String get wantToSaveSettings => "Do you want to save the settings?";

  @override
  String get overwriteProfile => "Overwrite Profile";

  @override
  String get wantToOverwriteProfile => "Do you want to overwrite the profile?";

  @override
  String channel(int index) {
    return "Channel $index";
  }

  @override
  String alreadyInUse(ChannelUsage usage) {
    return "There already exists another channel for ${channelUsage(usage)}";
  }

  @override
  String editChannel(ChannelUsage usage) {
    return "Edit ${channelUsage(usage)}";
  }

  @override
  String get usageLabel => "Usage";

  @override
  String get minValue => "Minimum";

  @override
  String get maxValue => "Maximum";

  @override
  String get currentValue => "Current Value";

  @override
  String get rawValue => "Raw value";

  @override
  String get inverted => "Inverted";

  @override
  String get reset => "Reset";

  @override
  String get index => "Index";

  @override
  String get autoCalibration => "Auto Calibration";

  @override
  String preset(int index)
  {
    return "Preset $index";
  }
}
