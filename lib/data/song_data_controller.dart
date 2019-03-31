import 'dart:async';
import 'dart:io';

import 'package:Robeats/network/media.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

class SongDataController {
  BehaviorSubject<Song> _songStreamController = BehaviorSubject<Song>();
  BehaviorSubject<double> _durationStreamController = BehaviorSubject<double>();

  BehaviorSubject<Song> get songStreamController => _songStreamController;

  BehaviorSubject<double> get durationStreamController =>
      _durationStreamController;

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