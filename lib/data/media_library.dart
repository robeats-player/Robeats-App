import 'dart:collection';
import 'dart:io';

import 'package:Robeats/data/media_loader.dart';
import 'package:Robeats/data/song_data_controller.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/network/media.dart';
import 'package:audioplayers/audioplayers.dart';

class MediaLibrary {
  static final MediaLoader _mediaLoader = MediaLoader();

  AudioPlayer _audioPlayer = AudioPlayer();
  Song _currentlyPlayingSong;
  Queue<Song> _songQueue = Queue();
  SongDataController _songDataController = Robeats.songDataController;

  MediaLibrary() {
    _initialiseAudioEvents();
  }

  static MediaLoader get mediaLoader => _mediaLoader;

  Queue<Song> get songQueue => _songQueue;

  /// Listens to the stream for duration changes, and send it to the sink of
  /// the [SongDataController] to update the UI.
  void _initialiseAudioEvents() {
    _audioPlayer.onAudioPositionChanged.listen((duration) {
      double durationFraction = 0;

      if (_currentlyPlayingSong.duration != null) {
        durationFraction =
        (duration.inSeconds / _currentlyPlayingSong.duration.inSeconds);
      }

      _songDataController.durationStreamController.add(durationFraction);
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      if (_songQueue.isNotEmpty) {
        playQueue();
      } else {
        stop();
      }
    });
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

  /// Play all songs in the [Queue]. The queue can be added to from the songs
  /// list screen.
  void playQueue() {
    if (_songQueue.isNotEmpty) {
      Song song = _songQueue.removeFirst();
      playSong(song);
    }
  }

  /// Clear the [Queue] and add all songs from a [Playlist] to the
  /// [_songQueue].
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
      case AudioPlayerState.PAUSED:
        _audioPlayer.resume();
        break;
      default:
        if (_songQueue.isNotEmpty)
          playQueue();

        break;
    }
  }

  /// This stops the song. It calls [AudioPlayer]'s pause stop method,
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
}