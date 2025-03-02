import 'dart:typed_data';

enum DeviceId {
  unknown, // 0
  gcrboard1; // 1
}


class FirmwareData {
  final DeviceId deviceId;
  final int revision;
  final int major;
  final int minor;

  FirmwareData(this.deviceId, this.revision, this.major, this.minor);

  static FirmwareData parse(Uint8List data) {
    final deviceId = DeviceId.values[data[0]];
    final revision = data[1];
    final major = data[2];
    final minor = data[3];
    return FirmwareData(deviceId, revision, major, minor);
  }

  @override
  String toString() {
    return "DeviceId: $deviceId, Revision: $revision, FirmwareVersion: $major.$minor";
  }
}
