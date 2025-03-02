import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/bar_painter.dart';
import 'package:gcrdeviceconfigurator/usb/usb_data.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ValueBar extends ConsumerWidget {
  final int channelId;

  const ValueBar({super.key, required this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);

    final usbStatus = ref.watch(usbProvider);
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

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: CustomPaint(
                painter: BarPainter(
                    margin: 2,
                    value: calibratedValue,
                    text: calibratedValue != null ? '${(calibratedValue * 100).toStringAsFixed(0)}%': lang.nSlashA),
                child: Container()),
          ),
          SizedBox(
            width: 100,
            child: CustomPaint(
                painter: BarPainter(
                    margin: 2, value: (rawValue ?? 0) / 4096.0, text: '${rawValue != null ? (rawValue * 100 ~/ 4096) : lang.nSlashA}%'),
                child: Container()),
          ),
        ]);
  }
}
