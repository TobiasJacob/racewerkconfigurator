import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/button_item.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/channel_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelList extends ConsumerWidget {
  const ChannelList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(settingsProvider);
    final lang = Languages.of(context);

    const headerStyle = TextStyle(
        color: Color.fromRGBO(80, 254, 0, 1),
        fontWeight: FontWeight.bold,
        fontSize: 16);

    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 60,
              child: Text(
                lang.index,
                textAlign: TextAlign.center,
                style: headerStyle,
              ),
            ),
            SizedBox(
              width: 200,
              height: 60,
              child: Text(
                lang.usageLabel,
                textAlign: TextAlign.center,
                style: headerStyle,
              ),
            ),
            SizedBox(
              width: 200,
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 60,
                    child: Text(
                      lang.currentValue,
                      style: headerStyle,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 60,
                    child: Text(
                      lang.rawValue,
                      style: headerStyle,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 100,
              height: 60,
              child: Text(
                lang.minValue,
                style: headerStyle,
              ),
            ),
            SizedBox(
              width: 100,
              height: 60,
              child: Text(
                lang.maxValue,
                style: headerStyle,
              ),
            ),
            SizedBox(
                width: 100,
                height: 60,
                child: Text(
                  lang.inverted,
                  style: headerStyle,
                )),
            SizedBox(
                width: 100,
                height: 60,
                child: Text(
                  lang.reset,
                  style: headerStyle,
                )),
            SizedBox(
                width: 100,
                height: 60,
                child: Text(
                  lang.profiles,
                  style: headerStyle,
                )),
          ]),
      for (var i = 0; i < appSettings.channelSettings.length; i++)
        ChannelItem(
          channelId: i,
        ),
      for (var i = 0; i < appSettings.buttonSettings.length; i++)
        ButtonItem(
          buttonId: i,
        ),
    ]);
  }
}
