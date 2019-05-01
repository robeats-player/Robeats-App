import 'dart:collection';
import 'dart:io';

import 'package:Robeats/data/media_loader.dart';
import 'package:Robeats/data/streams/player_state_data.dart';
import 'package:Robeats/structures/data_structures/stack.dart';
import 'package:Robeats/structures/data_structures/stream_queue.dart';
import 'package:Robeats/structures/media.dart';
import 'package:audioplayers/audioplayers.dart';

class MediaLibrary {
  static final MediaLibrary _instance = MediaLibrary._private();
  final MediaLoader _mediaLoader = MediaLoader();

  PlayerStateData _playerStateData = PlayerStateData();
  AudioPlayer _audioPlayer = AudioPlayer();
  Stack<Song> _songStack = Stack();
  StreamQueue<Song> _songQueue;

  MediaLibrary._private() {
    _songQueue = StreamQueue(_playerStateData.songQueueStream);

    _initialiseAudioEvents();
  }

  factory MediaLibrary() {
    return _instance;
  }

  MediaLoader get mediaLoader => _mediaLoader;

  PlayerStateData get playerStateData => _playerStateData;

  StreamQueue<Song> get songQueue => _songQueue;

  Song get currentlyPlayingSong => _playerStateData.currentSongStream.value;

  /**
   * Listens to the stream for duration changes, and send it to the sink of
   * the [SongStateDataController] to update the UI.
   */
  void _initialiseAudioEvents() {
    _audioPlayer.onAudioPositionChanged.listen((duration) {
      double durationFraction = 0;

      if (currentlyPlayingSong.duration != null) {
        durationFraction = (duration.inSeconds / currentlyPlayingSong.duration.inSeconds);
      }

      _playerStateData.songDurationStream.add(durationFraction);
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      if (_songQueue.isNotEmpty) {
        playQueue();
      } else {
        stop();
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerStateData.songStateStream.add(state);
    });
  }

  /**
   * This loads the URL of the [Song], by getting its [Directory].
   * Once the song is played, the [_currentlyPlayingSong] is set to it,
   * and added to the [SongStateDataController]'s sink.
   *
   * The song is added to the stack, so when the previous button is pressed,
   * the top of the stack can simply be popped. The optional parameter stack
   * describes whether it should be pushed or not - the notable case where
   * it wouldn't, is where we are playing the previous song; to avoid a loop.
   *
   * Furthermore, the [Song]'s [Duration] has now been by audioplayers and can
   * be set.
   */
  void playSong(Song song, [bool stack = true]) async {
    String url = await song.directory;

    if (stack && currentlyPlayingSong != null) {
      _songStack.push(currentlyPlayingSong);
    }

    _audioPlayer.play(url, volume: 0.35);
    _playerStateData.currentSongStream.add(song);

    song.duration ??= await _audioPlayer.onDurationChanged.first;
  }

  /**
   * Play all songs in the [Queue]. The queue can be added to from the songs
   * list screen.
   */
  void playQueue() {
    if (_songQueue.isNotEmpty) {
      Song song = _songQueue.removeFirst();
      playSong(song);
    }
  }

  /**
   * Clear the [Queue] and add all songs from a [Playlist] to the
   * [_songQueue].
   */
  void playPlaylist(Playlist playlist) {
    _songQueue.clear();
    _songQueue.addAll(playlist.songs);

    playQueue();
  }

  /**
   * 'state' refers to the [AudioPlayer]'s current [AudioPlayerState].
   * This could describe a song either: Stopped, Playing, Paused, or
   * Completed.
   *
   * If the state is PLAYING, then this pauses the song. If the song is
   * PAUSED, then it must be resumed.
   */
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
        if (_songQueue.isNotEmpty) playQueue();

        break;
    }
  }

  /**
   * This stops the song. It calls [AudioPlayer]'s pause stop method,
   * and releases its resources, in case that no other songs will be played.
   *
   * Furthermore, the variable [_currentlyPlayingSong] and the sink in
   * [SongStateDataController] are returned to their original state: null.
   */
  void stop() {
    _audioPlayer.stop();
    _audioPlayer.release();

    _playerStateData.currentSongStream.add(null);
    _playerStateData.songDurationStream.add(0);
  }

  /**
   * Pop the last element from the stack, and if it's not null, play it.
   */
  void playPrevious() {
    Song song = _songStack.pop();

    if (song != null) {
      playSong(song, false);
    }
  }

  /**
   * If the [Queue] is not empty, play the next song. If it is empty and
   * the user is currently playing another song, play the next one. If
   * they are not currently playing a song, play a random song.
   */
  void playNext() {
    if (_songQueue.isNotEmpty) {
      playQueue();
      return;
    }

    Song song;

    if (currentlyPlayingSong != null) {
      int index = _mediaLoader.songList.indexOf(currentlyPlayingSong) + 1;
      index %= _mediaLoader.songList.length;

      song = _mediaLoader.songList[index];
    } else {
      song = _mediaLoader.randomSong;
    }

    playSong(song);
  }

  /**
   * Seeks the current position in the song (i.e. the cursor) to a fraction
   * of the total duration.
   * Null checks must be done on totalDuration, as if no song is playing, or
   * it's not loaded - due to it being async, it will return null. If it is
   * null no seeking will be done.
   */
  void seekFraction(double fraction) async {
    Duration totalDuration = currentlyPlayingSong?.duration;

    if (totalDuration != null) {
      Duration duration = totalDuration * fraction;
      seekTime(duration);
    }
  }

  /**
   * Seeks the current position in the song (i.e. the cursor) to a specific
   * [Duration].
   *
   * All checks for time extending the song's length are done
   * by audioplayers.
   */
  void seekTime(Duration duration) {
    _audioPlayer.seek(duration);
  }
}
