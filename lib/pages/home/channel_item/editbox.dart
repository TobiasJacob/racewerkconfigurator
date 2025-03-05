import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/data/activate_settings.dart';
import 'package:racewerkconfigurator/data/settings_provider.dart';
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
  late int lastValue;

  @override
  void initState() {
    super.initState();
    final appSettings = ref.read(settingsProvider);
    _controller = TextEditingController(
        text: appSettings.channelSettings[widget.channelId].minValue.toString());
    lastValue = appSettings.channelSettings[widget.channelId].minValue;
  }

  @override
  void didUpdateWidget(covariant ChannelMinField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final appSettings = ref.read(settingsProvider);
    final newValue = appSettings.channelSettings[widget.channelId].minValue;
    if (lastValue != newValue) {
      lastValue = newValue;
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
            channelSettings.updateMinValue((value as int) ),
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
            channelSettings.updateMinValue((value as int)),
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
  late int lastValue;

  @override
  void initState() {
    super.initState();
    final appSettings = ref.read(settingsProvider);
    _controller = TextEditingController(
        text: appSettings.channelSettings[widget.channelId].maxValue.toString());
    lastValue = appSettings.channelSettings[widget.channelId].maxValue;
  }

  @override
  void didUpdateWidget(covariant ChannelMaxField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final appSettings = ref.read(settingsProvider);
    final newValue = appSettings.channelSettings[widget.channelId].maxValue;
    if (lastValue != newValue) {
      lastValue = newValue;
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
            channelSettings.updateMaxValue((value as int)),
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
            channelSettings.updateMaxValue((value as int)),
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

class ChannelSmoothing extends ConsumerStatefulWidget {
  final int channelId;

  const ChannelSmoothing({super.key, required this.channelId});

  @override
  ConsumerState<ChannelSmoothing> createState() => _ChannelSmoothingState();
}

class _ChannelSmoothingState extends ConsumerState<ChannelSmoothing> {
  late TextEditingController _controller;
  late int lastValue;

  @override
  void initState() {
    super.initState();
    final appSettings = ref.read(settingsProvider);
    _controller = TextEditingController(
        text: appSettings.channelSettings[widget.channelId].smoothing.toString());
    lastValue = appSettings.channelSettings[widget.channelId].smoothing;
  }

  @override
  void didUpdateWidget(covariant ChannelSmoothing oldWidget) {
    super.didUpdateWidget(oldWidget);
    final appSettings = ref.read(settingsProvider);
    final newValue = appSettings.channelSettings[widget.channelId].smoothing;
    if (lastValue != newValue) {
      lastValue = newValue;
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
      initialValue: channelSettings.smoothing,
      onChanged: (value) async {
        if (value <= 0) return;
        appSettingsNotifier.update(
          appSettings.updateChannel(
            widget.channelId,
            channelSettings.updateSmoothing(value as int),
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
            channelSettings.updateSmoothing((value as int)),
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
            channelSettings.updateSmoothing((value as int)),
          ),
        );
        await activateSettings(context, ref);
        await appSettingsNotifier.save();
      },
      min: 0,
      max: 100,
      widgetContainerDecoration: const BoxDecoration(border: null),
      incIconDecoration: const BoxDecoration(border: null),
      decIconDecoration: const BoxDecoration(border: null),
      separateIcons: false,
    );
  }
}

