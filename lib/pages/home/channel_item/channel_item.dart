import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/data/activate_settings.dart';
import 'package:racewerkconfigurator/data/app_settings.dart';
import 'package:racewerkconfigurator/data/channel.dart';
import 'package:racewerkconfigurator/data/channel_provider.dart';
import 'package:racewerkconfigurator/data/settings_provider.dart';
import 'package:racewerkconfigurator/i18n/languages.dart';
import 'package:racewerkconfigurator/pages/home/channel_item/editbox.dart';
import 'package:racewerkconfigurator/pages/home/channel_item/value_bar.dart';
import 'package:racewerkconfigurator/pages/home/channels/channel_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelItem extends ConsumerStatefulWidget {
  final int channelId;

  const ChannelItem({super.key, required this.channelId});

  @override
  ConsumerState<ChannelItem> createState() => _ChannelItemState();
}

class _ChannelItemState extends ConsumerState<ChannelItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);
    final appSettingsNotifier = ref.watch(settingsProvider.notifier);
    final channelSettings = appSettings.channelSettings[widget.channelId];

    return MaterialButton(
      onPressed: () {
        ref.read(channelIdProvider.notifier).state = widget.channelId;

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ChannelPage()));
      },
      minWidth: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: Text(
                (widget.channelId + 1).toString(),
              ),
            ),
            SizedBox(
              width: 200,
              child: Container(
                decoration: const BoxDecoration(
                  // background image
                  image: DecorationImage(
                    image: AssetImage('images/dropdown_button.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownMenu<ChannelUsage>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  dropdownMenuEntries: [
                    for (var usage in ChannelUsage.values)
                      DropdownMenuEntry(
                        value: usage,
                        label: lang.channelUsage(usage),
                      )
                  ],
                  onSelected: (ChannelUsage? value) async {
                    if (value != null) {
                      appSettingsNotifier.update(appSettings.updateChannel(
                          widget.channelId, channelSettings.updateChannelUsage(value)));
                      await activateSettings(context, ref);
                      await appSettingsNotifier.save();
                    }
                  },
                  initialSelection: channelSettings.usage,
                  requestFocusOnTap: false,
                  enableSearch: false,
                  controller: TextEditingController(text: lang.channelUsage(channelSettings.usage)),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: ValueBar(channelId: widget.channelId),
            ),
            SizedBox(
              width: 100,
              child: ChannelMinField(channelId: widget.channelId,),
            ),
            SizedBox(
              width: 100,
              child: ChannelMaxField(channelId: widget.channelId),
            ),
            SizedBox(
              width: 100,
              child: Checkbox(
                  value: channelSettings.inverted,
                  onChanged: (value) async {
                    appSettingsNotifier.update(appSettings.updateChannel(
                        widget.channelId,
                        channelSettings.updateInverted(value ?? false)));
                    await activateSettings(context, ref);
                    await appSettingsNotifier.save();
                  }),
            ),
            SizedBox(
              width: 100,
              child: ChannelSmoothing(channelId: widget.channelId),
            ),
            SizedBox(
              width: 100,
              child: IconButton(
                icon: const Icon(Icons.restore),
                onPressed: () async {
                  appSettingsNotifier.update(
                      appSettings.updateChannel(widget.channelId, Channel.empty()));
                  await activateSettings(context, ref);
                  await appSettingsNotifier.save();
                },
              ),
            ),
            const SizedBox(
                width: 100,
                child: Icon(
                  Icons.arrow_right_rounded,
                ))
          ]),
    );
  }
}