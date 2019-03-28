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
}

class Playlist {
  String identifier;

  Playlist(this.identifier);
}