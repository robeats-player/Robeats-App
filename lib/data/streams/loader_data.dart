import 'package:Robeats/structures/media.dart';
import 'package:rxdart/rxdart.dart';

class LoaderData {
  BehaviorSubject<Set<Song>> _songSetStream = BehaviorSubject();
  BehaviorSubject<Set<Playlist>> _playlistSetStream = BehaviorSubject();

  BehaviorSubject<Set<Playlist>> get playlistSetStream => _playlistSetStream;

  BehaviorSubject<Set<Song>> get songSetStream => _songSetStream;
}
