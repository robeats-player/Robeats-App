enum DeviceType {
  COMPUTER,
  MOBILE,
  TABLET
}

class Device {
  static final Device localDevice = Device._localDeviceConstructor();
  DeviceType deviceType;
  String chosenIdentifier;

  Device(this.deviceType, this.chosenIdentifier);

  factory Device._localDeviceConstructor() {
    return Device(DeviceType.MOBILE, "(This Device)");
  }
}

class ForeignDevice extends Device {
  ForeignDevice(DeviceType deviceType, String chosenIdentifier)
      : super(deviceType, chosenIdentifier);
}