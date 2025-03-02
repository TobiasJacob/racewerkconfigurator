import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/activate_settings.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class ChannelMinField extends ConsumerStatefulWidget {
  final int channelId;

  const ChannelMinField({super.key, required this.channelId});

  @override
  ConsumerState<ChannelMinField> createState() => _ChannelMinFieldState();
}

class _ChannelMinFieldState extends ConsumerState<ChannelMinField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final appSettings = ref.read(settingsProvider);
    _controller = TextEditingController(
        text: appSettings.channelSettings[widget.channelId].minValue.toString());
  }

  @override
  void didUpdateWidget(covariant ChannelMinField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final appSettings = ref.read(settingsProvider);
    final newValue = appSettings.channelSettings[widget.channelId].minValue;
    if (_controller.text != newValue.toString()) {
      _controller.text = newValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(settingsProvider);
    final appSettingsNotifier = ref.watch(settingsProvider.notifier);
    final channelSettings = appSettings.channelSettings[widget.channelId];

    return NumberInputWithIncrementDecrement(
      controller: _controller,
      initialValue: channelSettings.minValue,
      onChanged: (value) async {
        if (value >= channelSettings.maxValue - 1) return;
        appSettingsNotifier.update(
          appSettings.updateChannel(
            widget.channelId,
            channelSettings.updateMinValue(value as int),
          ),
        );
        await activateSettings(context, ref);
        await appSettingsNotifier.save();
      },
      onIncrement: (value) async {
        if (value >= channelSettings.maxValue - 1) return;
        appSettingsNotifier.update(
          appSettings.updateChannel(
            widget.channelId,
            channelSettings.updateMinValue((value as int) + 1),
          ),
        );
        await activateSettings(context, ref);
        await appSettingsNotifier.save();
      },
      onDecrement: (value) async {
        if (value <= 0) return;
        appSettingsNotifier.update(
          appSettings.updateChannel(
            widget.channelId,
            channelSettings.updateMinValue((value as int) - 1),
          ),
        );
        await activateSettings(context, ref);
        await appSettingsNotifier.save();
      },
      min: 0,
      max: channelSettings.maxValue - 1,
      widgetContainerDecoration: const BoxDecoration(border: null),
      incIconDecoration: const BoxDecoration(border: null),
      decIconDecoration: const BoxDecoration(border: null),
      separateIcons: false,
    );
  }
}

class ChannelMaxField extends ConsumerStatefulWidget {
  final int channelId;

  const ChannelMaxField({super.key, required this.channelId});

  @override
  ConsumerState<ChannelMaxField> createState() => _ChannelMaxFieldState();
}

class _ChannelMaxFieldState extends ConsumerState<ChannelMaxField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final appSettings = ref.read(settingsProvider);
    _controller = TextEditingController(
        text: appSettings.channelSettings[widget.channelId].maxValue.toString());
  }

  @override
  void didUpdateWidget(covariant ChannelMaxField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final appSettings = ref.read(settingsProvider);
    final newValue = appSettings.channelSettings[widget.channelId].maxValue;
    if (_controller.text != newValue.toString()) {
      _controller.text = newValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(settingsProvider);
    final appSettingsNotifier = ref.watch(settingsProvider.notifier);
    final channelSettings = appSettings.channelSettings[widget.channelId];

    return NumberInputWithIncrementDecrement(
      controller: _controller,
      initialValue: channelSettings.maxValue,
      onChanged: (value) async {
        if (value <= channelSettings.minValue + 1) return;
        appSettingsNotifier.update(
          appSettings.updateChannel(
            widget.channelId,
            channelSettings.updateMaxValue(value as int),
          ),
        );
        await activateSettings(context, ref);
        await appSettingsNotifier.save();
      },
      onIncrement: (value) async {
        if (value >= 100) return;
        appSettingsNotifier.update(
          appSettings.updateChannel(
            widget.channelId,
            channelSettings.updateMaxValue((value as int) + 1),
          ),
        );
        await activateSettings(context, ref);
        await appSettingsNotifier.save();
      },
      onDecrement: (value) async {
        if (value <= channelSettings.minValue + 1) return;
        appSettingsNotifier.update(
          appSettings.updateChannel(
            widget.channelId,
            channelSettings.updateMaxValue((value as int) - 1),
          ),
        );
        await activateSettings(context, ref);
        await appSettingsNotifier.save();
      },
      min: channelSettings.minValue + 1,
      max: 100,
      widgetContainerDecoration: const BoxDecoration(border: null),
      incIconDecoration: const BoxDecoration(border: null),
      decIconDecoration: const BoxDecoration(border: null),
      separateIcons: false,
    );
  }
}
