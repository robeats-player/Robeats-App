import 'dart:convert';
import 'dart:typed_data';

import 'package:Robeats/structures/device.dart';

class ProtocolRequest {
  static const DEVICE_DISCOVERY = const ProtocolRequest._private(0x01, 'Device Discovery');
  static const DEVICE_DISCOVERY_REPLY = const ProtocolRequest._private(0x11, 'Device Discovery Reply');
  static const REQUEST_SONG_LIST = const ProtocolRequest._private(0x02, 'Request Song List');
  static const REPLY_SONG_LIST = const ProtocolRequest._private(0x12, 'Reply Song List');
  static const SYNC_CONFIRM = const ProtocolRequest._private(0xFF, 'Sync Confirm');

  final int id;
  final String name;

  const ProtocolRequest._private(this.id, this.name);

  factory ProtocolRequest.fromId(int id) {
    switch (id) {
      case 0x01:
        return DEVICE_DISCOVERY;
        break;
      case 0x11:
        return DEVICE_DISCOVERY_REPLY;
        break;
      case 0x02:
        return REQUEST_SONG_LIST;
        break;
      case 0x12:
        return REPLY_SONG_LIST;
        break;
      case 0xFF:
        return SYNC_CONFIRM;
        break;
    }

    return null;
  }
}

/// Implementing the Robeats-State-Protocol
class StateProtocol {
  static const int MULTICAST_PORT = 4567;

  ProtocolRequest _protocolRequest;
  Device _device;

  StateProtocol(this._protocolRequest, this._device);

  /// Reconstruct a [StateProtocol] packet from [ByteData].
  factory StateProtocol.fromBytes(ByteData data) {
    ProtocolRequest protocolRequest = ProtocolRequest.fromId(data.getUint8(0));
    Device device = _fromStateProtocolBytes(data);

    return StateProtocol(protocolRequest, device);
  }

  /// Convert [ByteData] from a [StateProtocol] packet to a [Device].
  /// Starting at byte-offset 1 and going onwards.
  static Device _fromStateProtocolBytes(ByteData data) {
    int deviceId = data.getUint8(1);
    List<int> identifierBytes = [];
    String identifier;

    for (int i = 2; i < data.lengthInBytes; ++i) {
      identifierBytes.add(data.getUint8(i));
    }

    identifier = utf8.decode(identifierBytes);
    return Device(deviceId, identifier);
  }

  /// Convert a [StateProtocol] into [ByteData].
  /// As per the Robeats-State-Protocol, this should be laid out
  /// as follows: (Request ID (1), Device ID (1), Device Name (16)) 18 bytes.
  ByteData toBytes() {
    ByteData data = ByteData(18);

    data.setUint8(0, _protocolRequest.id);
    data.setUint8(1, _device.id);

    int i = 2;
    utf8.encode(_device.chosenIdentifier).forEach((byte) => data.setUint8(i++, byte));

    return data;
  }
}
