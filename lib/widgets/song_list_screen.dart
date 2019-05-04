import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/structures/data_structures/stream_queue.dart';
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
            padding: EdgeInsets.only(top: 5.0), children: _SongListTile.prepareTiles(songListSnapshot.data));
      },
    );

    FloatingActionButton floatingActionButton = FloatingActionButton(
      child: Icon(Icons.queue_music, color: RobeatsThemeData.PRIMARY),
      onPressed: () {
        showModalBottomSheet(context: context, builder: (_) => _QueueBottomSheet());
      },
    );

    return RobeatsSlideUpPanel(
      DefaultScaffold(
        streamBuilder,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }
}

class _QueueBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StreamBuilder<StreamQueue<Song>> streamBuilder = StreamBuilder(
      stream: MediaLibrary().playerStateData.songQueueStream,
      builder: (_, s) {
        return ListView(
          padding: EdgeInsets.only(top: 5.0),
          children: _QueueTile.prepareTiles(s.data),
        );
      },
    );

    return Container(child: streamBuilder);
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

class _QueueTile extends StatelessWidget {
  static int _index = 0;
  final Song _song;

  _QueueTile(this._song);

  @override
  Widget build(BuildContext context) {
    Decoration decoration = BoxDecoration(
      boxShadow: <BoxShadow>[BoxShadow(color: Colors.white, spreadRadius: 1.5)],
    );

    Container trailingContainer = Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.play_circle_filled),
            onPressed: () {
              MediaLibrary().playQueue();
            },
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 5.0),
      decoration: decoration,
      child: ListTile(
        leading: Icon(Icons.queue_music),
        title: Text("#${++_index} - ${_song.title}"),
        subtitle: Text("${_song.artist}"),
        trailing: trailingContainer,
      ),
    );
  }

  static List<_QueueTile> prepareTiles(Iterable<Song> iterable) {
    _index = 0;

    if (iterable != null) {
      return iterable.map((song) => _QueueTile(song)).toList();
    } else {
      return [];
    }
  }
}
