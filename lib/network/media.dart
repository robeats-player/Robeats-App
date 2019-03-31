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

class Playlist {
  String identifier;
  List<Song> songs;

  Playlist(this.identifier, this.songs);
}