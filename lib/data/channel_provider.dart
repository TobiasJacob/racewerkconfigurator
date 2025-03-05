
import 'package:racewerkconfigurator/data/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final channelIdProvider = StateProvider((ref) => 0);

final channelProvider = Provider((ref) {
  final channelId = ref.watch(channelIdProvider);
  final settings = ref.watch(settingsProvider);
  return settings.channelSettings[channelId];
});