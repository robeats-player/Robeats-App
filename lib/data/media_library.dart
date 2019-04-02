import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:Robeats/data/song_data_controller.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/network/media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_tags/dart_tags.dart';

class MediaLibrary {
  AudioPlayer _audioPlayer;
  Song _currentlyPlayingSong;
  SongDataController _songDataController = Robeats.songDataController;
  Set<Song> _songSet = Set();
  Set<Playlist> _playlistSet = Set();
  Queue _songQueue = Queue();

  MediaLibrary() {
    _loadAudioPlayer();
    loadSongs().then((_) => loadPlaylists());
  }

  Set<Song> get songSet => _songSet;

  Set<Playlist> get playlistSet => _playlistSet;

  Queue<Song> get songQueue => _songQueue;

  /// Get the [Directory] that music is all saved to.
  /// Async, as path_provider dictates.
  Future<Directory> get directory async {
    Directory appDataDirectory = await getMediaDirectory();
    return Directory(appDataDirectory.path + "/" + "music");
  }

  /// Initialise the [AudioPlayer] for the app, and listen to the stream
  /// for duration changes, and send it to the sink of the [SongDataController]
  /// to update the UI.
  void _loadAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _audioPlayer.onAudioPositionChanged.listen((duration) {
      double durationFraction = 0;

      if (_currentlyPlayingSong.duration != null) {
        durationFraction =
        (duration.inSeconds / _currentlyPlayingSong.duration.inSeconds);
      }

      _songDataController.durationStreamController.add(durationFraction);
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      stop();
    });
  }

  /// (Recursively) loop through all files of the [Directory]. Any files
  /// with type .mp3 will be loaded, tags read, [Song] objects created
  /// and added to the [_songSet].
  Future<void> loadSongs() async {
    List<FileSystemEntity> entities = (await this.directory).listSync(
        recursive: true);

    for (FileSystemEntity entity in entities) {
      String fileName = _getFileName(entity);

      if (entity is File && fileName.endsWith(".mp3")) {
        Tag metaTags = await _metaTags(entity);
        String songTitle = metaTags?.tags['title'];
        String artist = metaTags?.tags['artist'];
        String hash = md5.convert(entity.readAsBytesSync()).toString();

        _songSet.add(Song(
            fileName, songTitle, hash, artist, null
        ));
      }
    }
  }

  /// Loop through all playlists in the _playlists.json file. Any songs
  /// whose hash is in the list 'songs' will be added the the [Playlist].
  /// This [Playlist] will be added to [_playlistSet]
  Future<void> loadPlaylists() async {
    Directory directory = await this.directory;
    File file = File(directory.path + "/_playlists.json");

    if (!file.existsSync()) {
      return;
    }

    Map<String, dynamic> json = jsonDecode(file.readAsStringSync());

    for (MapEntry<String, dynamic> playlist in json.entries) {
      Map<String, dynamic> innerMap = playlist.value;
      List<String> songHashes = List<String>.from(innerMap['songs']);
      List<Song> songs = _songSet.where((song) =>
          songHashes.contains(song.hash)).toList();

      _playlistSet.add(Playlist(
          playlist.key, songs
      ));
    }
  }

  /// This loads the URL of the [Song], by getting its [Directory].
  /// The current song, if any, is stopped, and this one is played.
  /// Once the song is played, the [_currentlyPlayingSong] is set to it,
  /// and added to the [SongDataController]'s sink.
  ///
  /// Furthermore, the [Song]'s [Duration] has now been by audioplayers and can
  /// be set.
  void playSong(Song song) async {
    String url = await song.directory;

    stop();
    _audioPlayer.play(url, volume: 0.35);

    _currentlyPlayingSong = song;
    _songDataController.songStreamController.add(song);

    song.duration ??= await _audioPlayer.onDurationChanged.first;
  }

  void playQueue() {
    //todo implement.
  }

  /// Get all songs from a [Playlist] and add them to the [_songQueue].
  void playPlaylist(Playlist playlist) {
    _songQueue.clear();
    _songQueue.addAll(playlist.songs);

    playQueue();
  }

  /// 'state' refers to the [AudioPlayer]'s current [AudioPlayerState].
  /// This could describe a song either: Stopped, Playing, Paused, or
  /// Completed.
  ///
  /// If the state is PLAYING, then this pauses the song. If the song is
  /// PAUSED, then it must be resumed.
  void toggleState() {
    AudioPlayerState state = _audioPlayer.state;

    switch (state) {
      case AudioPlayerState.PLAYING:
        _audioPlayer.pause();
        break;
      case AudioPlayerState.PAUSED: //paused.
        _audioPlayer.resume();
        break;
      default:
        break;
    }
  }

  /// This stops the song. It call's [AudioPlayer]'s pause stop method,
  /// and releases its resources, in case that no other songs will be played.
  ///
  /// Furthermore, the variable [_currentlyPlayingSong] and the sink in
  /// [SongDataController] are returned to their original state: null.
  void stop() {
    _audioPlayer.stop();
    _audioPlayer.release();

    _songDataController.songStreamController.add(null);
    _songDataController.durationStreamController.add(0);
    _currentlyPlayingSong = null;
  }

  void shuffle() {
    //todo: implement.
  }

  void loop(Song song) {
    //todo: implement.
  }

  /// Seeks the current position in the song (i.e. the cursor) to a fraction
  /// of the total duration.
  /// Null checks must be done on totalDuration, as if no song is playing, or
  /// it's not loaded - due to it being async, it will return null. If it is
  /// null no seeking will be done.
  void seekFraction(double fraction) async {
    Duration totalDuration = _currentlyPlayingSong?.duration;

    if (totalDuration != null) {
      Duration duration = totalDuration * fraction;
      seekTime(duration);
    }
  }

  /// Seeks the current position in the song (i.e. the cursor) to a specific
  /// [Duration].
  ///
  /// All checks for time extending the song's length are done
  /// by audioplayers.
  void seekTime(Duration duration) {
    _audioPlayer.seek(duration);
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

    return tags.firstWhere(
            (tag) => tag != null && tag.tags.isNotEmpty,
        orElse: () => null
    );
  }
}