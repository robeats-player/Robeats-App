import 'dart:collection';
import 'dart:io';

import 'package:Robeats/data/song_data_controller.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/network/media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_tags/dart_tags.dart';

class MediaLibrary {
  AudioPlayer _audioPlayer;
  Song _currentlyPlayingSong;
  SongDataController _songDataController = Robeats.songDataController;
  Set<Song> _songSet = Set();
  Queue _songQueue = Queue();

  MediaLibrary() {
    _loadAudioPlayer();
    loadSongs();
  }

  Set<Song> get songSet => _songSet;

  Queue<Song> get songQueue => _songQueue;

  Future<Directory> get directory async {
    Directory appDataDirectory = await getMediaDirectory();
    return Directory(appDataDirectory.path + "/" + "music");
  }

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

  void loadSongs() async {
    List<FileSystemEntity> entities = (await this.directory).listSync(
        recursive: true);

    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        Tag metaTags = await _metaTags(entity);
        String fileName = _getFileName(entity);
        String songTitle = metaTags?.tags['title'];
        String artist = metaTags?.tags['artist'];

        _songSet.add(Song(
            fileName, songTitle, artist, null
        ));
      }
    }
  }

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

  void playPlaylist(Playlist playlist) {
    _songQueue.clear();
    _songQueue.addAll(playlist.songs);

    playQueue();
  }

  void toggleState() {
    AudioPlayerState state = _audioPlayer.state;

    switch (state) {
      case AudioPlayerState.PLAYING:
        _audioPlayer.pause();
        break;
      default: //paused.
        _audioPlayer.resume();
        break;
    }
  }

  void stop() {
    _audioPlayer.stop();
    _audioPlayer.release();

    _songDataController.songStreamController.add(null);
    _currentlyPlayingSong = null;
  }

  void shuffle() {
    //todo: implement.
  }

  void loop(Song song) {
    //todo: implement.
  }

  void seekFraction(double fraction) async {
    Duration totalDuration = _currentlyPlayingSong?.duration;

    if (totalDuration != null) {
      Duration duration = totalDuration * fraction;
      seekTime(duration);
    }
  }

  void seekTime(Duration duration) {
    _audioPlayer.seek(duration);
  }

  static String _getFileName(FileSystemEntity entity) {
    return entity.path
        .split('/')
        .last;
  }

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