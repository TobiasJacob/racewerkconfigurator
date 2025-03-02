import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/activate_settings.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/button.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
// import 'package:gcrdeviceconfigurator/dialogs/ok_dialog.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_item/button_sim_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ButtonItem extends ConsumerStatefulWidget {
  final int buttonId;

  const ButtonItem({super.key, required this.buttonId});

  @override
  ConsumerState<ButtonItem> createState() => _ButtonItemState();
}

class _ButtonItemState extends ConsumerState<ButtonItem> {
  // TextEditingController minController = TextEditingController();
  // TextEditingController maxController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   setState(() {
  //     final button = ref.read(settingsProvider).buttonSettings[widget.buttonId];

  //     // minController.text = button.lowerThreshold.toString();
  //     // maxController.text = button.upperThreshold.toString();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final appSettings = ref.watch(settingsProvider);
    final appSettingsNotifier = ref.watch(settingsProvider.notifier);
    final buttonSettings = appSettings.buttonSettings[widget.buttonId];

    // updateValues(int? lowerThreshold, int? upperThreshold) {
    //   setState(() {
    //     var update = buttonSettings;
    //     if (lowerThreshold != null && upperThreshold != null) {
    //       // Both values are set simultaneously so that the min value is always smaller than the max value
    //       update = buttonSettings.updateBothThreshold(lowerThreshold, upperThreshold);
    //       minController.text = lowerThreshold.toString();
    //       maxController.text = upperThreshold.toString();
    //     } else if (lowerThreshold != null) {
    //       update = buttonSettings.updateLowerThreshold(lowerThreshold);
    //       minController.text = lowerThreshold.toString();
    //     } else if (upperThreshold != null) {
    //       update = buttonSettings.updateUpperThreshold(upperThreshold);
    //       maxController.text = upperThreshold.toString();
    //     }
    //     if (update != buttonSettings) {
    //       appSettingsNotifier.update(
    //         appSettings.updateButton(widget.buttonId, update)
    //       );
    //     }
    //   });
    // }
    return MaterialButton(
      onPressed: () {
      },
      minWidth: 0,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: Text(
                (widget.buttonId + 1 + appSettings.channelSettings.length).toString(),
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
                child: DropdownMenu<ButtonUsage>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                  ),
                  dropdownMenuEntries: [
                    for (var usage in ButtonUsage.values)
                      DropdownMenuEntry(
                        value: usage,
                        label: lang.buttonUsage(usage),
                      )
                  ],
                  onSelected: (ButtonUsage? value) async {
                    if (value != null) {
                      appSettingsNotifier.update(appSettings.updateButton(
                          widget.buttonId, buttonSettings.updateButtonUsage(value)));
                      await activateSettings(context, ref);
                      await appSettingsNotifier.save();
                    }
                  },
                  initialSelection: buttonSettings.usage,
                  requestFocusOnTap: false,
                  enableSearch: false,
                  controller: TextEditingController(text: lang.buttonUsage(buttonSettings.usage)),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: ButtonSimBar(buttonId: widget.buttonId),
            ),
            const SizedBox(
              width: 100,
            ),
            const SizedBox(
              width: 100,
            ),
            // SizedBox(
            //   width: 100,
            //   child: Focus(
            //             onFocusChange: (value) async {
            //               if (value) {
            //                 return;
            //               }
            //               try {
            //                 final valueInt = int.parse(minController.text);
            //                 updateValues(valueInt, null);
            //                 await activateSettings(context, ref);
            //                 appSettingsNotifier.save();
            //               } catch (e) {
            //                 showOkDialog(context, lang.error, "$e");
            //                 updateValues(buttonSettings.lowerThreshold, null); // Reset to previous value
            //               }
            //             },
            //             child: TextField(
            //               controller: minController,
            //             ),
            //           ),
            // ),
            // SizedBox(
            //   width: 100,
            //   child: Focus(
            //             onFocusChange: (value) async {
            //               if (value) {
            //                 return;
            //               }
            //               try {
            //                 final valueInt = int.parse(maxController.text);
            //                 updateValues(null, valueInt);
            //                 await activateSettings(context, ref);
            //                 appSettingsNotifier.save();
            //               } catch (e) {
            //                 showOkDialog(context, lang.error, "$e");
            //                 updateValues(null, buttonSettings.upperThreshold); // Reset to previous value
            //               }
            //             },
            //             child: TextField(
            //               controller: maxController,
            //             ),
            //           ),
            // ),
            SizedBox(
              width: 100,
              child: Checkbox(
                  value: buttonSettings.inverted,
                  onChanged: (value) async {
                    appSettingsNotifier.update(appSettings.updateButton(
                        widget.buttonId,
                        buttonSettings.updateInverted(value ?? false)));
                    await activateSettings(context, ref);
                    await appSettingsNotifier.save();
                  }),
            ),
            const SizedBox(
              width: 100,
            ),
            SizedBox(
              width: 100,
              child: IconButton(
                icon: const Icon(Icons.restore),
                onPressed: () async {
                  final newSettings = appSettings.updateButton(widget.buttonId, Button.empty());
                  appSettingsNotifier.update(newSettings);
                  await activateSettings(context, ref);
                  await appSettingsNotifier.save();
                  // updateValues(newSettings.buttonSettings[widget.buttonId].lowerThreshold, newSettings.buttonSettings[widget.buttonId].upperThreshold);
                },
              ),
            ),
            const SizedBox(
                width: 100,)
          ]),
    );
  }
}
