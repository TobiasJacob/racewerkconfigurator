import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/activate_settings.dart';
import 'package:gcrdeviceconfigurator/data/channel_provider.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/yes_no_dialog.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/editbox.dart';
import 'package:gcrdeviceconfigurator/pages/home/channels/chart/chart.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';
import 'package:gcrdeviceconfigurator/usb/usb_data.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../i18n/languages.dart';

class ChannelPage extends ConsumerStatefulWidget {
  const ChannelPage({super.key});

  @override
  ConsumerState<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends ConsumerState<ChannelPage> {
  bool autoUpdate = false;

  @override
  void initState() {
    super.initState();

    // setState(() {
    // });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final channelId = ref.watch(channelIdProvider);
    final channel = ref.watch(channelProvider);
    final usbStatus = ref.watch(usbProvider);
    final settingsNotifier = ref.watch(settingsProvider.notifier);

    final appSettings = ref.watch(settingsProvider);
    final currentValues = usbStatus.maybeWhen(
      data: (data) => data.maybeMap(
        connected: (usbStatus) => usbStatus.currentValues,
        orElse: () => null,
      ),
      orElse: () => null,
    );
    final rawValue = currentValues?[channelId];
    final calibratedValueX = currentValues != null
        ? parseValue(appSettings, currentValues, channelId)
        : null;
    final calibratedValue = calibratedValueX != null
        ? appSettings.channelSettings[channelId].profileAxis
            .getY(calibratedValueX)
        : null;

    final rawValueConverted =
        rawValue != null ? (rawValue * 100 ~/ 4096) : null;

    if (autoUpdate) {
      if (rawValueConverted != null &&
          rawValueConverted + 1 < channel.minValue) {
        Future(() {
          settingsNotifier.update(appSettings.updateChannel(
              channelId, channel.updateMinValue(rawValueConverted + 1)));
        });
      }
      if (rawValueConverted != null &&
          rawValueConverted - 1 > channel.maxValue) {
        Future(() {
          settingsNotifier.update(appSettings.updateChannel(
              channelId, channel.updateMaxValue(rawValueConverted - 1)));
        });
      }
    }

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          final navigator = Navigator.of(context);
          navigator.pop();
          await willPop(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(lang.editChannel(channel.usage)),
          ),
          body: Column(
            children: [
              Column(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          SettingsTile(
                            title: lang.rawValue,
                            child: SizedBox(
                              child: Text(
                                  "${(rawValue != null ? rawValue * 100 ~/ 4096 : lang.nSlashA).toString()}%"),
                            ),
                          ),
                          SettingsTile(
                              title: lang.minValue,
                              child: ChannelMinField(channelId: channelId)),
                          SettingsTile(
                              title: lang.maxValue,
                              child: ChannelMaxField(channelId: channelId)),
                          SettingsTile(
                              title: lang.inverted,
                              child: Checkbox(
                                  value: channel.inverted,
                                  onChanged: (value) {
                                    // updateValues(null, null);
                                    settingsNotifier.updateChannel(
                                        channel.updateInverted(value ?? false));
                                  })),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          SettingsTile(
                            title: lang.currentValue,
                            child: SizedBox(
                              child: Text(
                                  "${(calibratedValue != null ? (calibratedValue * 100).round() : lang.nSlashA).toString()}%"),
                            ),
                          ),
                          SettingsTile(
                            title: lang.autoCalibration,
                            child: Checkbox(
                                value: autoUpdate,
                                onChanged: (value) {
                                  if (value == true) {
                                    settingsNotifier.update(
                                        appSettings.updateChannel(
                                            channelId,
                                            channel.updateMinMaxValue(
                                                ((rawValue ?? 2048) *
                                                            100 ~/
                                                            4096 -
                                                        1)
                                                    .clamp(0, 100),
                                                ((rawValue ?? 2048) *
                                                            100 ~/
                                                            4096 +
                                                        1)
                                                    .clamp(0, 100))));
                                  }
                                  setState(() {
                                    autoUpdate = value!;
                                  });
                                }),
                          ),
                          SettingsTile(
                              title: lang.smoothing,
                              child: ChannelSmoothing(channelId: channelId)),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
              const VerticalDivider(),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(flex: 1, child: Chart()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          for (var i = 0; i < 6; i++)
                            Expanded(
                                flex: 1,
                                child: MaterialButton(
                                  onPressed: () async {
                                    // Alert dialog to confirm the change
                                    final yes = await showYesNoDialog(
                                        context,
                                        lang.overwriteProfile,
                                        lang.wantToOverwriteProfile);
                                    if (yes != true) {
                                      return;
                                    }
                                    settingsNotifier.updateChannel(
                                        channel.updateProfileAxis(
                                            ProfileAxis.preset(i)));
                                  },
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'images/preset${i + 1}.png'),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20)
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<bool> willPop(BuildContext context) async {
    final notif = ref.read(settingsProvider.notifier);
    activateSettings(context, ref);
    notif.save();
    return true;
  }
}
