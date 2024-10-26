import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import 'gcr_device.dart';

part 'usb_data.freezed.dart';

@freezed
class UsbData with _$UsbData {
  @Assert('currentValues.length == 10')
  factory UsbData.connected({
    required List<int> currentValues,
    required GcrUsbHidDevice device,
  }) = _UsbConnected;

  const factory UsbData.disconnected() = _UsbDisconnected;
  const factory UsbData.uninitialized() = _UsbUninitialized;
}

double parseValue(AppSettings appSettings, List<int> rawValues, int channelId) {
  final channel = appSettings.channelSettings[channelId];
  final val = rawValues[channelId].toDouble();
  final calibratedVal = (val - channel.minValue) / (channel.maxValue - channel.minValue);
  return calibratedVal;
}
