import 'dart:io';

import 'package:Robeats/persistence/json/structures/json_file.dart';

class JsonManager {
  final Map<String, JsonFile> _jsonFiles = {};
  final List<File> _fileList = [];

  JsonManager(Directory directory, List<String> fileNames) {
    for (String path in fileNames) {
      _fileList.add(File(directory.path + '/' + path));
    }

    loadAll();
  }

  Map<String, JsonFile> get jsonFiles => _jsonFiles;

  /**
   * Load all [File]s, if they're a Json file, and add them to the [List].
   */
  void loadAll() {
    for (File file in _fileList) {
      String fileName = file.path.split('/').last;

      if (_jsonFiles.containsKey(fileName)) {
        _jsonFiles[fileName].reloadFile();
      } else {
        _jsonFiles[fileName] = JsonFile(file);
      }
    }
  }
}
