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

  PlayingSong playSong() {
    //todo: more implementation.
    return PlayingSong(this, 0);
  }
}

class PlayingSong {
  Song song;
  double _time = -1;

  PlayingSong(Song song, double time) {
    this.song = song;
    this.time = time;
  }

  double get time => _time;

  set time(double time) {
    if (-1 <= time && time <= song.duration.inSeconds) {
      this._time = time;
    }
  }

  void clearSong() {
    song = null;
    time = -1;
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