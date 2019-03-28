final Device globalLocalDevice = new Device(DeviceType.MOBILE, "Local Device");

enum DeviceType {
  COMPUTER,
  MOBILE,
  TABLET
}

class Device {
  DeviceType deviceType;
  String chosenIdentifier;

  Device(this.deviceType, this.chosenIdentifier);
}

class ForeignDevice extends Device {
  ForeignDevice(DeviceType deviceType, String chosenIdentifier)
      : super(deviceType, chosenIdentifier);
}