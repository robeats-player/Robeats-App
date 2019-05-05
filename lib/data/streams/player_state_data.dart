import 'package:Robeats/structures/media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';

class PlayerStateData {
  BehaviorSubject<Song> _currentSongStream = BehaviorSubject();
  BehaviorSubject<double> _songDurationStream = BehaviorSubject();
  BehaviorSubject<AudioPlayerState> _songStateStream = BehaviorSubject();

  BehaviorSubject<Song> get currentSongStream => _currentSongStream;

  BehaviorSubject<double> get songDurationStream => _songDurationStream;

  BehaviorSubject<AudioPlayerState> get songStateStream => _songStateStream;

  PlayerStateData() {
    //Trigger initial update to all listeners
    _currentSongStream.add(null);
  }
}
