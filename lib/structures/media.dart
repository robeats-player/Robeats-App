import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/data/media_loader.dart';
import 'package:Robeats/persistence/json/structures/json_file.dart';
import 'package:Robeats/persistence/json/structures/json_serialisable.dart';

class Song {
  String _fileName;
  String title;
  String hash;
  String artist;
  Duration duration;

  Song(String fileName, String title, String hash, String artist, Duration duration) {
    this._fileName = fileName;
    this.title = title;
    this.hash = hash;
    this.artist = artist;
    this.duration = duration;
  }

  /**
   * Retrieve the directory of the song.
   */
  Future<String> get directory async {
    String path = (await MediaLoader.directory).path;
    return path + "/$_fileName";
  }

  /**
   * Override of the equals operator. This works by checking that the hash
   * of the song's mp3 file is equal.
   */
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Song && runtimeType == other.runtimeType && hash == other.hash;

  @override
  int get hashCode => hash.hashCode;
}

class Playlist extends JsonSerialisable {
  String identifier;
  List<Song> songs;

  Playlist(this.identifier, this.songs);

  /**
   * Deserialise  a [Playlist] from its Json [Map].
   */
  factory Playlist.deserialise(String identifier, Map<String, dynamic> serialised) {
    MediaLoader mediaLoader = MediaLibrary().mediaLoader;
    List<String> hashes = serialised['songs'];

    List<Song> songs = mediaLoader.songList.where((song) => hashes.contains(song.hash));
    return Playlist(identifier, songs);
  }

  factory Playlist.create(String identifier) {
    return Playlist(identifier, [])
      ..save();
  }

  /**
   * Serialise a [Playlist] into a Json string.
   */
  Map<String, dynamic> serialise() {
    return <String, dynamic>{
      "songs": songs.map((s) => s.hash).toList(growable: false),
    };
  }

  void save() async {
    MediaLoader mediaLoader = MediaLibrary().mediaLoader;
    JsonFile file = mediaLoader.jsonManager.jsonFiles['_playlists.json'];

    mediaLoader.playlistSet.add(this);
    file.put(identifier, this);
    file.saveFile();
  }

  /**
   * Override of the equals operator. This works by checking the identifier
   * (name) of the playlist, and the data structure holding all its [Song]s.
   */
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Playlist && runtimeType == other.runtimeType && identifier == other.identifier && songs == other.songs;
  }

  @override
  int get hashCode {
    return identifier.hashCode ^ songs.hashCode;
  }
}
