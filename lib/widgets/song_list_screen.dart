import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SongListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaLibrary mediaLibrary = MediaLibrary();
    Observable<List> combined = Observable.combineLatest2(
        mediaLibrary.mediaLoader.songList.behaviorSubject,
        mediaLibrary.playerStateData.currentSongStream,
            (a, b) => [a, b]
    );

    StreamBuilder<List> streamBuilder = StreamBuilder(
      stream: combined,
      builder: (_, AsyncSnapshot<List> snapshot) {
        List<Song> songList = snapshot.data != null ? snapshot.data[0] : [];
        Song currentSong = snapshot.data != null ? snapshot.data[1] : null;

        return ListView(
          padding: EdgeInsets.only(top: 5.0),
          children: _SongListTile.prepareTiles(songList, currentSong),
        );
      },
    );

    return DefaultScaffold(
      streamBuilder,
    );
  }
}

class _SongListTile extends StatelessWidget {
  final Song _song;
  final bool _selected;

  _SongListTile(this._song, this._selected);

  @override
  Widget build(BuildContext context) {
    String title = _song?.title ?? "Unreadable";
    String artist = _song?.artist ?? "Unreadble";

    Decoration decoration = BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.white,
          spreadRadius: 1.5,
        ),
      ],
    );

    Container trailingContainer = Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.queue),
            onPressed: () {
              MediaLibrary().songQueue.add(_song);
            },
          ),
          IconButton(
            icon: Icon(Icons.play_circle_filled),
            onPressed: () {
              MediaLibrary().playSong(_song);
            },
          )
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 5.0),
      decoration: decoration,
      child: ListTile(
        selected: _selected,
        leading: Icon(Icons.music_note),
        title: Text("$title"),
        subtitle: Text("$artist"),
        trailing: trailingContainer,
      ),
    );
  }

  static List<_SongListTile> prepareTiles(Iterable<Song> iter, Song currentSong) {
    if (iter != null) {
      return iter.map((song) => _SongListTile(song, song == currentSong)).toList();
    } else {
      return List();
    }
  }
}
