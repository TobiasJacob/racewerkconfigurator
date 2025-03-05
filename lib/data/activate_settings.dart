import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'settings_provider.dart';
import '../dialogs/ok_dialog.dart';
import '../i18n/languages.dart';
import '../usb/config_serialize.dart';

Future<void> activateSettings(BuildContext context, WidgetRef ref) async {
  final lang = Languages.of(context);
  final usbStatus = ref.read(usbProvider);
 usbStatus.maybeWhen(
    data: (data) async {
      data.maybeMap(
        connected: (usbConn) async {
          try {
            final config = serializeConfig(ref.read(settingsProvider));
            await usbConn.device.sendSerializedConfig(config);
            print('Config sent');
            // showOkDialog(
            //     context, lang.info, lang.ok);
          } catch (e) {
            showOkDialog(
                context, lang.error, lang.errorUploadProfile(e.toString()));
          }
        },
        orElse: () => showOkDialog(context, lang.error, lang.errorNotConnected),
      );
    },
    orElse: () => showOkDialog(context, lang.error, lang.errorNotConnected),
  );
}
