import 'dart:io';
import 'dart:math';

import 'package:Robeats/data/streams/loader_data.dart';
import 'package:Robeats/persistance/json/json_manager.dart';
import 'package:Robeats/structures/media.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:path_provider/path_provider.dart';

class MediaLoader {
  JsonManager _jsonManager;
  LoaderData _loaderData = LoaderData();
  List<Song> _songList = List();
  Set<Playlist> _playlistSet = Set();

  MediaLoader() {
    _initialiseJsonManager();
  }

  JsonManager get jsonManager => _jsonManager;

  LoaderData get loaderData => _loaderData;

  List<Song> get songList => _songList;

  Set<Playlist> get playlistSet => _playlistSet;

  Song get randomSong {
    return _songList.elementAt(new Random().nextInt(_songList.length));
  }

  /// Get the [Directory] that music is all saved to.
  /// If it does not exist, create it.
  /// Async, as path_provider dictates.
  static Future<Directory> get directory async {
    Directory appDataDirectory = await getApplicationDocumentsDirectory();
    appDataDirectory = new Directory(appDataDirectory.path + "/" + "music");

    if (!appDataDirectory.existsSync()) {
      appDataDirectory.create(recursive: false);
    }

    return appDataDirectory;
  }

  /// Utility function - returns the file name based on a [FileSystemEntity]'s path.
  /// E.g. /a/b/c/song.mp3 would return song.mp3
  static String _getFileName(FileSystemEntity entity) {
    return entity.path
        .split('/')
        .last;
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

  void _initialiseJsonManager() async {
    JsonManager jsonManager = JsonManager();
    Directory dir = await directory;

    jsonManager.addFile("playlists", File(dir.path + '/_playlists.json'));

    _jsonManager = jsonManager;
  }

  /// Load all songs & playlists.
  Future<void> load() async {
    await _loadSongs().then((_) => _loadPlaylists());
  }

  /// (Recursively) loop through all files of the [Directory]. Any files
  /// with type .mp3 will be loaded, tags read, [Song] objects created
  /// and added to the [_songList].
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
        _loaderData.songListStream.add(_songList);
      }
    }
  }

  /// Loop through all playlists in the _playlists.json file. Any songs
  /// whose hash is in the list 'songs' will be added the the [Playlist].
  /// This [Playlist] will be added to [_playlistSet]
  Future<void> _loadPlaylists() async {
    Map<String, dynamic> playlists = await _jsonManager.decodeFile("playlists");

    for (MapEntry<String, dynamic> playlist in playlists.entries) {
      Map<String, dynamic> innerMap = playlist.value;
      List<String> songHashes = List<String>.from(innerMap['songs']);

      List<Song> songs = _songList.where((song) => songHashes.contains(song.hash)).toList();

      _playlistSet.add(Playlist(playlist.key, songs));
      _loaderData.playlistSetStream.add(_playlistSet);
    }
  }
}
