import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class SongListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaLibrary mediaLibrary = MediaLibrary();

    StreamBuilder<List<Song>> streamBuilder = StreamBuilder(
      stream: mediaLibrary.mediaLoader.loaderData.songListStream,
      builder: (_, AsyncSnapshot<List<Song>> songListSnapshot) {
        return ListView(
          padding: EdgeInsets.only(top: 5.0),
          children: _SongListTile.prepareTiles(songListSnapshot.data),
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

  _SongListTile(this._song);

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
        leading: Icon(Icons.music_note),
        title: Text("$title"),
        subtitle: Text("$artist"),
        trailing: trailingContainer,
      ),
    );
  }

  static List<_SongListTile> prepareTiles(Iterable<Song> iter) {
    if (iter != null) {
      return iter.map((song) => _SongListTile(song)).toList();
    } else {
      return List();
    }
  }
}
