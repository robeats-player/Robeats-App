import 'dart:convert' as convert;

abstract class JsonSerialisable {
  /// Turn this [JsonSerialisable] object into a [Map].
  Map<String, dynamic> serialise();

  /// Turn this object into a [Map], and then encode it to JSON.
  String jsonEncode() {
    return convert.jsonEncode(this, toEncodable: (_) => serialise());
  }
}
