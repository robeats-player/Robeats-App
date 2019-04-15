import 'package:Robeats/structures/data_structures/stream_queue.dart';
import 'package:Robeats/structures/media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';

class PlayerStateData {
  BehaviorSubject<Song> _currentSongStream = BehaviorSubject();
  BehaviorSubject<double> _songDurationStream = BehaviorSubject();
  BehaviorSubject<AudioPlayerState> _songStateStream = BehaviorSubject();
  BehaviorSubject<StreamQueue<Song>> _songQueueStream = BehaviorSubject();

  BehaviorSubject<Song> get currentSongStream => _currentSongStream;

  BehaviorSubject<double> get songDurationStream => _songDurationStream;

  BehaviorSubject<AudioPlayerState> get songStateStream => _songStateStream;

  BehaviorSubject<StreamQueue<Song>> get songQueueStream => _songQueueStream;


}