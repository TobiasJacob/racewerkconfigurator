import 'dart:math';
import 'dart:typed_data';

import 'package:dartusbhid/enumerate.dart';
import 'package:dartusbhid/open_device.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/usb/firmware_version.dart';

const int vendorId = 1155;
const int productId = 22353;
const int packetSize = 64;
const int serializedConfigLength = 556;

// Should be the same as in gcrdevice/UserCode/usb_hid_comm.h. Note that gcrdevice is in another repo.
enum HidReportIdDeviceToHost {
  currentJoystickValues(01),
  data(03),
  printDebugString(04);

  final int value;
  const HidReportIdDeviceToHost(this.value);
}

enum HidReportIdHostToDevice {
  command(02),
  data(03);

  final int value;
  const HidReportIdHostToDevice(this.value);
}

enum UsbHidCommands {
  ping(00),
  sendRawADCValues(01),
  sendConfigToHost(02),
  receiveConfigFromHost(03),
  sendFirmwareVersion(04);

  final int value;
  const UsbHidCommands(this.value);
}

/// This is the class to interact with the real USB device.
class GcrUsbHidDevice {
  late OpenUSBDevice device;
  bool simulated = true;
  int joystickvalscounter = 0;

  Uint8List simulatedSerializedConfig = Uint8List(0);

  GcrUsbHidDevice();

  Future<void> open() async {
    final devices = await enumerateDevices(productId, vendorId);
    if (devices.isEmpty) {
      throw Exception('No compatible game controller found');
    }
    device = await devices.first.open();
    simulated = false;
  }

  Future<void> close() async {
    if (!simulated) {
      simulated = true;
      await device.close();
    }
  }

  Future<Uint8List> waitForResponse(UsbHidCommands command) async {
    Uint8List response = Uint8List(0);
    int maxTries = 1000;
    while (true) {
      response = await device.readReport(1000);
      // debugPrint('Response: $response');
      if (response.isEmpty) {
        debugPrint('Empty response');
        continue;
      }

      if (response[0] == HidReportIdDeviceToHost.currentJoystickValues.value) {
        // This case is not used in this app. It is just used to tell windows about the current joystick values.
        joystickvalscounter++;
        if (joystickvalscounter % 500 == 0) {
          debugPrint('Current Joystick Values: ${response.sublist(1)}');
        }
      } else if (response[0] == HidReportIdDeviceToHost.data.value) {
        // This case has to be handled by the code calling this function.
        // debugPrint('Data: $response');
        if (response[1] != command.value) {
          debugPrint('Unexpected command: ${response[1]}');
          throw Exception('Unexpected command: ${response[1]}');
        }
        return response.sublist(2);
      } else if (response[0] == HidReportIdDeviceToHost.printDebugString.value) {
        // Print debug string
        debugPrint('Debug String: ${String.fromCharCodes(response.sublist(1))}');
      } else {
        debugPrint('Unknown response: $response');
      }

      maxTries--;
      if (maxTries == 0) {
        debugPrint('No valid response received');
        throw Exception('No valid response received');
      }
    }
  }

  Future<FirmwareData> getFirmwareInformation() async {
    if (simulated) {
      return FirmwareData(DeviceId.unknown, 0, 0, 0);
    }
    const payLoadSize = packetSize - 2;

    final commandWrite = WriteBuffer();
    commandWrite.putUint8(HidReportIdHostToDevice.command.value); // Report ID (Send command)
    commandWrite.putUint8(UsbHidCommands.sendFirmwareVersion.value); // Read Config Command
    for (var j = 0; j < payLoadSize; j++) {
      commandWrite.putUint8(0x00);
    }
    final commandBytes = commandWrite.done();
    final command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);
    assert (command.length == packetSize);
    await device.writeReport(command);


    final response = await waitForResponse(UsbHidCommands.sendFirmwareVersion);
    return FirmwareData.parse(response);
  }

  Future<Uint8List> sendPing(Uint8List payload) async {
    if (simulated) {
      return payload;
    }
    final commandWrite = WriteBuffer();
    commandWrite.putUint8(HidReportIdHostToDevice.command.value); // Report ID (Send command)
    commandWrite.putUint8(UsbHidCommands.ping.value); // Ping Command
    commandWrite.putUint8List(payload.sublist(0, min(payload.length, packetSize - 2))); // Fill with zeros (padding)
    // Fill with 0xDE till length packetSize (padding)
    for (var i = 2 + payload.length; i < packetSize; i++) {
      commandWrite.putUint8(0xDE);
    }

    final commandBytes = commandWrite.done();
    final command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);

    assert (command.length == packetSize);
    await device.writeReport(command);
    Uint8List response = await waitForResponse(UsbHidCommands.ping);
    return response;
  }

  Future<Int16List> receiveRawADCValues() async {
    if (simulated) {
      return Int16List(10);
    }
    final commandWrite = WriteBuffer();
    commandWrite.putUint8(HidReportIdHostToDevice.command.value); // Report ID (Send command)
    commandWrite.putUint8(UsbHidCommands.sendRawADCValues.value); // Ping Command
    // Fill with 0x00 till length packetSize (padding)
    for (var i = 0; i < packetSize - 2; i++) {
      commandWrite.putUint8(0x00);
    }

    final commandBytes = commandWrite.done();
    final command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);

    assert (command.length == packetSize);
    await device.writeReport(command);
    Uint8List response = await waitForResponse(UsbHidCommands.sendRawADCValues);

    // Convert to 16 bit values
    final Int16List adcValues = Int16List(10);
    for (var i = 0; i < 10; i++) {
      adcValues[i] = response[i * 2] + (response[i * 2 + 1] << 8);
    }
    return adcValues;
  }
  
  Future<void> sendSerializedConfig(Uint8List serializedConfig) async {
    assert (serializedConfig.length == serializedConfigLength);
    if (simulated) {
      simulatedSerializedConfig = serializedConfig;
      return;
    }
    const payLoadSize = packetSize - 2;

    // Send command to write config
    final commandWrite = WriteBuffer();
    commandWrite.putUint8(HidReportIdHostToDevice.command.value); // Report ID (Send command)
    commandWrite.putUint8(UsbHidCommands.receiveConfigFromHost.value); // Write Config Command
    for (var j = 0; j < payLoadSize; j++) {
      commandWrite.putUint8(0x00);
    }
    final commandBytes = commandWrite.done();
    final command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);
    assert (command.length == packetSize);
    await device.writeReport(command);

    // Send config
    for (var i = 0; i < serializedConfig.length; i += payLoadSize) {
      final commandWrite = WriteBuffer();
      commandWrite.putUint8(HidReportIdHostToDevice.data.value); // Report ID (Send command)
      commandWrite.putUint8(UsbHidCommands.receiveConfigFromHost.value); // Write Config Command
      final transportedPayloadBytes = min(payLoadSize, serializedConfig.length - i);
      commandWrite.putUint8List(serializedConfig.sublist(i, i + transportedPayloadBytes)); // Fill with zeros (padding)
      // Fill with 0x00 till length packetSize (padding)
      for (var j = transportedPayloadBytes; j < payLoadSize; j++) {
        commandWrite.putUint8(0x00);
      }

      final commandBytes = commandWrite.done();
      final command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);

      assert (command.length == packetSize);
      await device.writeReport(command);
    }
  }

  Future<Uint8List> readSerializedConfig() async {
    if (simulated) {
      return simulatedSerializedConfig;
    }
    const payLoadSize = packetSize - 2;

    final commandWrite = WriteBuffer();
    commandWrite.putUint8(HidReportIdHostToDevice.command.value); // Report ID (Send command)
    commandWrite.putUint8(UsbHidCommands.sendConfigToHost.value); // Read Config Command
    for (var j = 0; j < payLoadSize; j++) {
      commandWrite.putUint8(0x00);
    }
    final commandBytes = commandWrite.done();
    final command = commandBytes.buffer.asUint8List(commandBytes.offsetInBytes, commandBytes.lengthInBytes);
    assert (command.length == packetSize);
    await device.writeReport(command);

    final configBufferWrite = WriteBuffer();
    for (var i = 0; i < serializedConfigLength; i += payLoadSize) {
      final response = await waitForResponse(UsbHidCommands.sendConfigToHost);
      configBufferWrite.putUint8List(response.sublist(0, min(response.length, serializedConfigLength - i)));
    }
    final configBufferBytes = configBufferWrite.done();
    final configBuffer = configBufferBytes.buffer.asUint8List(configBufferBytes.offsetInBytes, configBufferBytes.lengthInBytes);
    assert (configBuffer.length == serializedConfigLength);
    return configBuffer;
  }
}