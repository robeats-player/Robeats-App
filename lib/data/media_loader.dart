import 'dart:io';
import 'dart:math';

import 'package:Robeats/persistence/json/json_manager.dart';
import 'package:Robeats/persistence/json/structures/json_file.dart';
import 'package:Robeats/structures/data_structures/stream_collection/stream_list.dart';
import 'package:Robeats/structures/data_structures/stream_collection/stream_set.dart';
import 'package:Robeats/structures/media.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:path_provider/path_provider.dart';

class MediaLoader {
  JsonManager _jsonManager;
  StreamList<Song> _songList = StreamList();
  StreamSet<Playlist> _playlistSet = StreamSet();

  JsonManager get jsonManager => _jsonManager;

  StreamList<Song> get songList => _songList;

  StreamSet<Playlist> get playlistSet => _playlistSet;

  Song get randomSong {
    return _songList.elementAt(new Random().nextInt(_songList.length));
  }

  /**
   * Get the [Directory] that music is all saved to.
   * If it does not exist, create it.
   * Async, as path_provider dictates.
   */
  static Future<Directory> get directory async {
    Directory appDataDirectory = await getApplicationDocumentsDirectory();
    appDataDirectory = new Directory(appDataDirectory.path + "/" + "music");

    if (!appDataDirectory.existsSync()) {
      appDataDirectory.create(recursive: false);
    }

    return appDataDirectory;
  }

  /**
   * Utility function - returns the file name based on a [FileSystemEntity]'s path.
   * E.g. /a/b/c/song.mp3 would return song.mp3
   */
  static String _getFileName(FileSystemEntity entity) {
    return entity.path
        .split('/')
        .last;
  }

  /**
   * Utility function - returns the ID3 [Tag] based on a song. Depending on
   * the tag type used, either is returned. This could either be ID3v1 or
   * ID3v2.
   */
  static Future<Tag> _metaTags(File file) async {
    TagProcessor tagProcessor = TagProcessor();
    List<Tag> tags = await tagProcessor.getTagsFromByteArray(
      file.readAsBytes(),
    );

    return tags.firstWhere((tag) => tag != null && tag.tags.isNotEmpty, orElse: () => null);
  }

  void _initialiseJsonManager() async {
    List<String> files = <String>[
      "_playlists.json",
    ];

    _jsonManager = JsonManager(await directory, files);
  }

  /**
   * Load all songs & playlists.
   */
  Future<void> load() async {
    await _loadSongs().then((_) => _initialiseJsonManager()).then((_) => _loadPlaylists());
  }

  /**
   * (Recursively) loop through all files of the [Directory]. Any files
   * with type .mp3 will be loaded, tags read, [Song] objects created
   * and added to the [_songList].
   */
  Future<void> _loadSongs() async {
    List<FileSystemEntity> entities = (await directory).listSync(recursive: true);

    for (FileSystemEntity entity in entities) {
      String fileName = _getFileName(entity);

      if (entity is File && fileName.endsWith(".mp3")) {
        Tag metaTags = await _metaTags(entity);
        String songTitle = metaTags?.tags['title'];
        String artist = metaTags?.tags['artist'];
        String hash = md5.convert(entity.readAsBytesSync()).toString();

        _songList.add(Song(fileName, songTitle, hash, artist, null));
      }
    }
  }

  /**
   * Loop through all playlists in the _playlists.json file. Any songs
   * whose hash is in the list 'songs' will be added the the [Playlist].
   * This [Playlist] will be added to [_playlistSet]
   */
  Future<void> _loadPlaylists() async {
    JsonFile playlists = _jsonManager.jsonFiles['_playlists.json'];

    for (MapEntry<String, dynamic> entry in playlists.data.entries) {
      Playlist playlist = Playlist.deserialise(entry.key, entry.value);

      _playlistSet.add(playlist);
    }
  }
}
