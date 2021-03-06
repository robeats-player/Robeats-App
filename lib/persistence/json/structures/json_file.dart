import 'dart:convert';
import 'dart:io';

import 'package:Robeats/persistence/json/structures/json_serialisable.dart';

const String EMPTY_OBJECT = "{}";

class JsonFile {
  Map<String, dynamic> data = {};
  final File _file;

  /**
   * Constructor to instantiate a [JsonFile].
   */
  JsonFile(this._file);

  /**
   * Private utility method, if the [File] does not exist, create it. If the parameter write
   * is true, then write an empty object "{}" to the [File] as well. Otherwise, merely create
   * the [File]. Returns true if a new file was created and/or written to.
   */
  Future<bool> _createIfNotExists([bool write = true]) async {
    if (_file != null && !_file.existsSync())
      if (write)
        await _file.writeAsString(EMPTY_OBJECT);
      else
        await _file.create();

    return false;
  }

  /**
   * Create the file if it does not exist, and if it did exist, read its data to the [Map].
   */
  Future<void> reloadFile() async {
    if (!(await _createIfNotExists())) {
      String fileContent = await _file.readAsString();
      data = jsonDecode(fileContent);
    }
  }

  /**
   * Create the file if it does not exist, and serialise the [Map] and write it to the file.
   */
  Future<void> saveFile() async {
    await _createIfNotExists(false);

    String dataContent = jsonEncode(data);
    await _file.writeAsString(dataContent);
  }

  /**
   * Convenience function to write a [JsonSerialisable] object to the [Map].
   */
  void put(String key, JsonSerialisable serialisable) {
    Map<String, dynamic> serialised = serialisable.serialise();
    data[key] = serialised;
  }
}
