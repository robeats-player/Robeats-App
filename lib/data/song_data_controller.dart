import 'dart:async';
import 'dart:io';

import 'package:Robeats/network/media.dart';
import 'package:path_provider/path_provider.dart';

class SongDataController {
  var _songStreamController = StreamController<Song>();
  var _durationStreamController = StreamController<double>();

  Stream<Song> get songStream => _songStreamController.stream;

  Sink<Song> get songSink => _songStreamController.sink;

  Stream<double> get durationStream => _durationStreamController.stream;

  Sink<double> get durationSink => _durationStreamController.sink;

  SongDataController();

  void dispose() {
    _songStreamController.close();
    _durationStreamController.close();
  }
}

Future<Directory> getMediaDirectory() async {
  Directory directory = await getApplicationDocumentsDirectory();
  return Directory(directory.path);
}