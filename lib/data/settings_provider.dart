import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/channel.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:localstorage/localstorage.dart';

final settingsProvider =
    StateNotifierProvider<SettingsProvider, AppSettings>((ref) {
  return SettingsProvider(ref);
});

class SettingsProvider extends StateNotifier<AppSettings> {
  final Ref ref;
  
  SettingsProvider(this.ref) : super(AppSettings.empty());

  Future<void> load() async {
    final storage = LocalStorage('data.json');
    await storage.ready;

    final jsonSettings = await storage.getItem("settings");
    state = AppSettings.fromJson(jsonSettings);
  }

  Future<void> save() async {
    final storage = LocalStorage('data.json');
    await storage.ready;

    await storage.setItem("settings", state.toJson());
  }

  Future<void> resetToFactory() async {
    state = AppSettings.empty();
    await save();
  }

  void update(AppSettings settings) {
    state = settings;
  }

  void updateChannel(Channel channel) {
    final index = ref.read(channelIdProvider);
    state = state.updateChannel(index, channel);
  }

  void updateProfile(Profile profile) {
    final profileId = ref.read(profileIdProvier);
    state = state.updateProfile(profileId, profile);
  }

  void updateAxis(ProfileAxis updateChartDataPoint) {
    final profileId = ref.read(profileIdProvier);
    final index = ref.read(axisIdProvider);
    state = state.updateProfile(profileId, state.profiles[profileId]!.updateAxis(index, updateChartDataPoint));
  }
}
