import 'package:Robeats/structures/media.dart';
import 'package:rxdart/rxdart.dart';

class LoaderData {
  BehaviorSubject<List<Song>> _songListStream = BehaviorSubject();
  BehaviorSubject<Set<Playlist>> _playlistSetStream = BehaviorSubject();

  BehaviorSubject<Set<Playlist>> get playlistSetStream => _playlistSetStream;

  BehaviorSubject<List<Song>> get songListStream => _songListStream;
}
