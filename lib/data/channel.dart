import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';

import 'app_settings.dart';

part 'channel.freezed.dart';
part 'channel.g.dart';

@freezed
class Channel with _$Channel {
  const Channel._();

  @Assert('minValue >= 0')
  @Assert('minValue <= 100')
  @Assert('maxValue >= 0')
  @Assert('maxValue <= 100')
  @Assert('minValue < maxValue')
  @Assert('smoothing >= 0')
  @Assert('smoothing <= 100')
  factory Channel({
    required ChannelUsage usage,
    required int minValue,
    required int maxValue,
    required int smoothing,
    required ProfileAxis profileAxis,
    required bool inverted
  }) = _Channel;

  factory Channel.empty() => Channel(usage: ChannelUsage.none, minValue: 0, maxValue: 100, smoothing: 0, profileAxis: ProfileAxis.empty(), inverted: false);

  factory Channel.fromJson(Map<String, Object?> json)
      => _$ChannelFromJson(json);

  Channel updateChannelUsage(ChannelUsage usage) {
    return copyWith(usage: usage);
  }

  Channel updateMinValue(int minValue) {
    return copyWith(minValue: minValue);
  }

  Channel updateMaxValue(int maxValue) {
    return copyWith(maxValue: maxValue);
  }

  Channel updateMinMaxValue(int minValue, int maxValue) {
    return copyWith(minValue: minValue, maxValue: maxValue);
  }

  Channel updateSmoothing(int smoothing) {
    return copyWith(smoothing: smoothing);
  }

  Channel updateProfileAxis(ProfileAxis profileAxis) {
    return copyWith(profileAxis: profileAxis);
  }

  Channel updateInverted(bool inverted) {
    return copyWith(inverted: inverted);
  }
}
