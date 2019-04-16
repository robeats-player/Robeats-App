/// The type that a [Device] could be.
enum DeviceType { COMPUTER, MOBILE, TABLET }

/// Refers to a Device running a Robeats instance - whether that be the
/// Desktop app, or a mobile app on iOS or Android (this includes the local
/// device).
class Device {
  static final Device localDevice = Device._localDeviceConstructor();

  final String uuid;
  DeviceType deviceType;
  String chosenIdentifier;

  Device(this.uuid, this.deviceType, this.chosenIdentifier);

  /// Constructor used, once, to create an instance of the local device.
  factory Device._localDeviceConstructor() {
    return Device("", DeviceType.MOBILE, "(This Device)");
  }
}

/// A [Device] that is not local, and can - therefore, be synced to.
class ForeignDevice extends Device {
  ForeignDevice(String uuid, DeviceType deviceType, String chosenIdentifier)
      : super(uuid, deviceType, chosenIdentifier);
}
