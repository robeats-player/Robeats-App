import 'dart:async';
import 'dart:io';

import 'package:Robeats/structures/media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

class SongStateDataController {
  BehaviorSubject<Song> songStreamController = BehaviorSubject();
  BehaviorSubject<double> durationStreamController = BehaviorSubject();
  BehaviorSubject<AudioPlayerState> stateStreamController = BehaviorSubject();

  SongStateDataController();

  /// Close all resources to reduce memory leaks.
  void dispose() {
    songStreamController.close();
    durationStreamController.close();
    stateStreamController.close();
  }
}

/// Return the directory used by the OS (iOS or Android) that the app
/// can save music to.
Future<Directory> getMediaDirectory() async {
  Directory directory = await getApplicationDocumentsDirectory();
  return Directory(directory.path);
}