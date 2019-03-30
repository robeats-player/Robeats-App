import 'dart:async';
import 'dart:io';

import 'package:Robeats/network/media.dart';
import 'package:path_provider/path_provider.dart';

class SongDataController {
  PlayingSong _playingSong;

  var _songStreamController = StreamController<PlayingSong>();

  Stream<PlayingSong> get songStream => _songStreamController.stream;

  Sink<PlayingSong> get songSink => _songStreamController.sink;

  SongDataController() {
    songStream.listen((playingSong) {
      this._playingSong = playingSong;
    });
  }

  void dispose() {
    _songStreamController.close();
  }
}

Future<Directory> getMediaDirectory() async {
  Directory directory = await getApplicationDocumentsDirectory();
  return Directory(directory.path);
}