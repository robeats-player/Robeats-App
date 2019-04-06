import 'package:Robeats/data/media_loader.dart';

class Song {
  String _fileName;
  String title;
  String hash;
  String artist;
  Duration duration;

  Song(String fileName, String title, String hash, String artist,
      Duration duration) {
    this._fileName = fileName;
    this.title = title;
    this.hash = hash;
    this.artist = artist;
    this.duration = duration;
  }

  /// Retrieve the directory of the song.
  Future<String> get directory async {
    String path = (await MediaLoader.directory).path;
    return path + "/$_fileName";
  }
}

class Playlist {
  String identifier;
  List<Song> songs;

  Playlist(this.identifier, this.songs);
}