import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/data/app_settings.dart';
import 'package:racewerkconfigurator/data/settings_provider.dart';
import 'package:racewerkconfigurator/i18n/languages.dart';
import 'package:racewerkconfigurator/pages/home/channel_item/button_painter.dart';
import 'package:racewerkconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ButtonSimBar extends ConsumerStatefulWidget {
  final int buttonId;
  const ButtonSimBar({super.key, required this.buttonId});

  @override
  ConsumerState<ButtonSimBar> createState() => _ButtonSimBarState();
}

class _ButtonSimBarState extends ConsumerState<ButtonSimBar> {
  bool buttonHysteresisState = false;
  int buttonTriggerCounter = 0;
  bool buttonToggleState = false;
  
  @override
  void initState() {
    super.initState();

    setState(() {
      buttonHysteresisState = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
    final rawValue = currentValues?[appSettings.channelSettings.length + widget.buttonId];

    var buttonValue = rawValue;
    if (buttonValue != null && appSettings.buttonSettings[widget.buttonId].inverted) {
      buttonValue = (4096 - buttonValue);
    }
    var newButtonHysteresisState = buttonHysteresisState;
    if (buttonHysteresisState == false && buttonValue != null && buttonValue > appSettings.buttonSettings[widget.buttonId].upperThreshold) {
      newButtonHysteresisState = true;
    } else if (buttonHysteresisState == true && buttonValue != null && buttonValue < appSettings.buttonSettings[widget.buttonId].lowerThreshold) {
      newButtonHysteresisState = false;
    }

    bool buttonPressed;
    switch (appSettings.buttonSettings[widget.buttonId].usage) {
      case ButtonUsage.none:
        buttonPressed = false;
        break;
      case ButtonUsage.hold:
        buttonPressed = newButtonHysteresisState;
        break;
      case ButtonUsage.trigger:
        if (newButtonHysteresisState && !buttonHysteresisState) {
          buttonTriggerCounter = 5;
        }
        if (buttonTriggerCounter > 0) {
          buttonTriggerCounter--;
          buttonPressed = true;
        } else {
          buttonPressed = false;
        }
        break;
      case ButtonUsage.toggle:
        if (newButtonHysteresisState && !buttonHysteresisState) {
          buttonToggleState = !buttonToggleState;
        }
        buttonPressed = buttonToggleState;
        break;
    }
    buttonHysteresisState = newButtonHysteresisState;


    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: CustomPaint(
                painter: ButtonPainter(
                    margin: 2,
                    value: buttonPressed,
                    onText: lang.on,
                    offText: lang.off),
                child: Container()),
          ),
          const SizedBox(
            width: 100
          ),
        ]);
  }
}
