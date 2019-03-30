import 'package:Robeats/main.dart';

class Song {
  String _fileName;
  String identifier;
  String artist;
  Duration duration;

  Song(String fileName, String identifier, String artist, Duration duration) {
    this._fileName = fileName;
    this.identifier = identifier;
    this.artist = artist;
    this.duration = duration;
  }

  Future<String> get directory async {
    String path = (await Robeats.mediaLibrary.directory).path;
    return path + "/$_fileName";
  }
}

class PlayingSong {
  Song song;
  double _time = -1;

  PlayingSong(Song song) {
    this.song = song;
  }

  double get time => _time;

  set time(double time) {
    if (-1 <= time && time <= song.duration.inSeconds) {
      this._time = time;
    }
  }

  bool isPlaying() {
    return song != null && _time > -1;
  }
}

class Playlist {
  String identifier;
  List<Song> songs;

  Playlist(this.identifier, this.songs);
}