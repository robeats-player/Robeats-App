import 'dart:convert';
import 'dart:io';

import 'package:Robeats/persistance/json/json_serialisable.dart';

class JsonManager {
  Map<String, File> _jsonFiles = {};

  /// Load a [File], i.e. if it does not exist, create it and write '{}' to it.
  /// This is valid JSON syntax for an empty object.
  void _loadFile(File file) async {
    if (!(await file.exists())) {
      file.writeAsString("{}");
    }
  }

  /// Add a file to the manager, to keep track of, with the key `key`.
  /// It also loads the file.
  void addFile(String key, File file) {
    _jsonFiles[key] = file;
    _loadFile(file);
  }

  /// This saves a [File] updating its content to a newly serialised
  /// json object.
  void saveFile(String key, Map<String, dynamic> serialised) {
    File file = _jsonFiles[key];
    file.writeAsString(jsonEncode(serialised));
  }

  /// Save an entire [JsonSerialisable] object to a [File].
  /// A convenience method, equal to saveFile(key, serialisable.serialise())
  void saveJsonSerialisable(String key, JsonSerialisable serialisable) {
    saveFile(key, serialisable.serialise());
  }

  File getFile(String key) {
    return _jsonFiles[key];
  }

  Future<Map<String, dynamic>> decodeFile(String key) async {
    return jsonDecode(await _jsonFiles[key].readAsString());
  }
}
