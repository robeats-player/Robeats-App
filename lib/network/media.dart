import 'package:Robeats/main.dart';

class Song {
  String _fileName;
  String title;
  String artist;
  Duration duration;

  Song(String fileName, String title, String artist, Duration duration) {
    this._fileName = fileName;
    this.title = title;
    this.artist = artist;
    this.duration = duration;
  }

  /// Retrieve the directory of the song.
  Future<String> get directory async {
    String path = (await Robeats.mediaLibrary.directory).path;
    return path + "/$_fileName";
  }
}

class Playlist {
  String identifier;
  List<Song> songs;

  Playlist(this.identifier, this.songs);
}