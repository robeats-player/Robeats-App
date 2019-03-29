enum DeviceType {
  COMPUTER,
  MOBILE,
  TABLET
}

class Device {
  static final Device localDevice = Device._localDeviceConstructor();
  final String uuid;
  DeviceType deviceType;
  String chosenIdentifier;

  Device(this.uuid, this.deviceType, this.chosenIdentifier);

  factory Device._localDeviceConstructor() {
    return Device("", DeviceType.MOBILE, "(This Device)");
  }
}

class ForeignDevice extends Device {
  ForeignDevice(String uuid, DeviceType deviceType, String chosenIdentifier)
      : super(uuid, deviceType, chosenIdentifier);
}