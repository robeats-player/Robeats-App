class Song {
  String _fileName;
  String identifier;

  Song(String fileName, String identifier) {
    this._fileName = fileName;
    this.identifier = identifier;
  }
}

class Playlist {
  String identifier;

  Playlist(this.identifier);
}