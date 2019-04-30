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

    return RobeatsSlideUpPanel(
      StreamBuilder<Song>(
        stream: mediaLibrary.playerStateData.currentSongStream,
        builder: (_, currentSongSnapshot) {
          return Scaffold(
            appBar: RobeatsAppBar(),
            drawer: RobeatsDrawer(context),
            body: StreamBuilder(
              stream: mediaLibrary.mediaLoader.loaderData.songListStream,
              builder: (_, AsyncSnapshot<List<Song>> songListSnapshot) {
                return ListView(
                  padding: EdgeInsets.only(top: 5.0),
                  children: _SongListTile.prepareTiles(songListSnapshot.data, currentSongSnapshot.data),
                );
              }
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.queue_music, color: RobeatsThemeData.PRIMARY),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (_) => _QueueBottomSheet());
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          );
        },
      ),
    );
  }
}

class _QueueBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<StreamQueue<Song>>(
        stream: MediaLibrary().playerStateData.songQueueStream,
        builder: (_, s) => ListView(
              padding: EdgeInsets.only(top: 5.0),
              children: _QueueTile.prepareTiles(s.data),
            ),
      ),
    );
  }
}

class _SongListTile extends StatelessWidget {
  final Song _song;
  final bool _current;

  _SongListTile(this._song, this._current);

  @override
  Widget build(BuildContext context) {
    String title = _song?.title ?? "Unreadable";
    String artist = _song?.artist ?? "Unreadble";

    return Container(
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1.5,
          ),
        ],
      ),
      child: ListTile(
        selected: _current,
        leading: Icon(Icons.music_note),
        title: Text("$title"),
        subtitle: Text("$artist"),
        trailing: Container(
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
        ),
      ),
    );
  }

  static List<_SongListTile> prepareTiles(Iterable<Song> iter, Song current) {
    if (iter != null) {
      return iter.map((song) => _SongListTile(song, current == song)).toList();
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
    return Container(
      child: ListTile(
        leading: Icon(Icons.queue_music),
        title: Text("#${++_index} - ${_song.title}"),
        subtitle: Text("${_song.artist}"),
        trailing: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.play_circle_filled),
                onPressed: () {
                  MediaLibrary().playQueue();
                },
              )
            ],
          ),
        ),
      ),
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1.5,
          )
        ],
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
