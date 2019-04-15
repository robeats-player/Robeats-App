import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Robeats/data/streams/song_data_controller.dart';
import 'package:Robeats/structures/media.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_tags/dart_tags.dart';

class MediaLoader {
  Set<Song> _songSet = Set();
  Set<Playlist> _playlistSet = Set();

  Set<Song> get songSet => _songSet;

  Set<Playlist> get playlistSet => _playlistSet;

  Song get randomSong {
    return _songSet.elementAt(new Random().nextInt(_songSet.length));
  }

  /// Get the [Directory] that music is all saved to.
  /// Async, as path_provider dictates.
  static Future<Directory> get directory async {
    Directory appDataDirectory = await getMediaDirectory();
    return Directory(appDataDirectory.path + "/" + "music");
  }

  /// Utility function - returns the file name based on a [FileSystemEntity]'s path.
  /// E.g. /a/b/c/song.mp3 would return song.mp3
  static String _getFileName(FileSystemEntity entity) {
    return entity.path.split('/').last;
  }

  /// Utility function - returns the ID3 [Tag] based on a song. Depending on
  /// the tag type used, either is returned. This could either be ID3v1 or
  /// ID3v2.
  static Future<Tag> _metaTags(File file) async {
    TagProcessor tagProcessor = TagProcessor();
    List<Tag> tags = await tagProcessor.getTagsFromByteArray(
      file.readAsBytes(),
    );

    return tags.firstWhere((tag) => tag != null && tag.tags.isNotEmpty, orElse: () => null);
  }

  Future<void> load() async {
    await loadSongs().then((_) => loadPlaylists());
  }

  /// (Recursively) loop through all files of the [Directory]. Any files
  /// with type .mp3 will be loaded, tags read, [Song] objects created
  /// and added to the [_songSet].
  Future<void> loadSongs() async {
    List<FileSystemEntity> entities = (await directory).listSync(recursive: true);

    for (FileSystemEntity entity in entities) {
      String fileName = _getFileName(entity);

      if (entity is File && fileName.endsWith(".mp3")) {
        Tag metaTags = await _metaTags(entity);
        String songTitle = metaTags?.tags['title'];
        String artist = metaTags?.tags['artist'];
        String hash = md5.convert(entity.readAsBytesSync()).toString();

        _songSet.add(Song(fileName, songTitle, hash, artist, null));
      }
    }
  }

  /// Loop through all playlists in the _playlists.json file. Any songs
  /// whose hash is in the list 'songs' will be added the the [Playlist].
  /// This [Playlist] will be added to [_playlistSet]
  Future<void> loadPlaylists() async {
    Directory dir = await directory;
    File file = File(dir.path + "/_playlists.json");

    if (!file.existsSync()) {
      return;
    }

    Map<String, dynamic> json = jsonDecode(file.readAsStringSync());

    for (MapEntry<String, dynamic> playlist in json.entries) {
      Map<String, dynamic> innerMap = playlist.value;
      List<String> songHashes = List<String>.from(innerMap['songs']);

      List<Song> songs = _songSet.where((song) => songHashes.contains(song.hash)).toList();

      _playlistSet.add(Playlist(playlist.key, songs));
    }
  }
}
