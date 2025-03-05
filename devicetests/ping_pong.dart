/// This test is used to test the USB communication with the device.
/// Run with `flutter run -t devicetests\ping_pong.dart`
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racewerkconfigurator/data/app_settings.dart';
import 'package:racewerkconfigurator/usb/config_serialize.dart';
import 'package:racewerkconfigurator/usb/gcr_device.dart';

//
void test() async {
    final appSettings = AppSettings.empty();
    final buffer = serializeConfig(appSettings);
    debugPrint("Full config has length ${buffer.length}");
    assert(buffer.length == 864);

    final device = GcrUsbHidDevice();
    await device.open();

    // Create Uint8List with 0xDEADBEEF and length 62
    final data = Uint8List(62);
    data[0] = 0xDE;
    data[1] = 0xAD;
    data[2] = 0xBE;
    data[3] = 0xEF;
    data[4] = 0x00;
    data[5] = 0x01;
    data[6] = 0x02;
    data[7] = 0x03;

    // Send data to device
    debugPrint("Send ping...");
    await device.sendPing(data);

    // Get firmware data
    debugPrint("Get firmware data...");
    final firmwareData = await device.getFirmwareInformation();
    debugPrint("Firmware data: $firmwareData");

    // Receive raw adc values
    debugPrint("Receiving raw adc values...");
    final adcValues = await device.receiveRawADCValues();
    debugPrint("Received raw adc values: $adcValues");

    // Receive config from device
    debugPrint("Receive initial config...");
    final receivedInitialConfig = await device.readSerializedConfig();
    for (int i = 0; i < receivedInitialConfig.length; i++) {
      if (receivedInitialConfig[i] != buffer[i]) {
        debugPrint("Received config differs at index $i");
        debugPrint("Expected: ${buffer.sublist(i, i + 10)}");
        debugPrint("Received: ${receivedInitialConfig.sublist(i, i + 10)}");
        break;
      }
    }

    // Send config to device
    debugPrint("Send config...");
    await device.sendSerializedConfig(buffer);

    // Receive config from device
    debugPrint("Receive config...");
    final receivedConfig = await device.readSerializedConfig();

    assert (receivedConfig.length == buffer.length);
    for (int i = 0; i < receivedConfig.length; i++) {
      assert(receivedConfig[i] == buffer[i]);
    }

    await device.close();
    debugPrint("Done");
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test();

  runApp(const MaterialApp());
}
