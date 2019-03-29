import 'dart:async';

import 'package:Robeats/network/media.dart';

class SongDataController {
  static SongDataController _instance;
  PlayingSong _playingSong;

  var _songStreamController = StreamController<PlayingSong>();

  Stream<PlayingSong> get songStream => _songStreamController.stream;

  Sink<PlayingSong> get songSink => _songStreamController.sink;

  factory SongDataController() {
    return (_instance ??= SongDataController._privateConstructor());
  }

  SongDataController._privateConstructor() {
    songStream.listen((playingSong) {
      this._playingSong = playingSong;
    });
  }

  void dispose() {
    _songStreamController.close();
  }
}