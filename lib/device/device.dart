/**
 * An interface representing a Device, this is any device running an instance of Robeats. This can be the desktop
 * software, or an app on Android or iOS.
 */
abstract class Device {
  static const LocalDevice LOCAL_DEVICE = const LocalDevice._private();

  String get chosenIdentifier;
}

/**
 * A class, implementing [Device], representing a foreign (non-local) device running a Robeats instance.
 */
class ForeignDevice implements Device {
  final int id;
  String chosenIdentifier;

  ForeignDevice(this.id, this.chosenIdentifier);
}

/**
 * A class, implementing [Device], representing this local instance of Robeats.
 */
class LocalDevice implements Device {
  const LocalDevice._private();

  @override
  String get chosenIdentifier => "Local Device";
}
