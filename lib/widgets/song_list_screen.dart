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
          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
          children: SongListTile.prepareTiles(songList, currentSong),
        );
      },
    );

    return DefaultScaffold(
      streamBuilder,
    );
  }
}
