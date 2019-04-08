import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class SongListScreen extends StatelessWidget {
  var _mediaLibrary = Robeats.mediaLibrary;
  var _mediaLoader;

  SongListScreen() {
    _mediaLoader = _mediaLibrary.mediaLoader;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _mediaLibrary.songDataController.songStreamController,
        builder: (_, s) {
          return Scaffold(
            appBar: RobeatsAppBar(),
            drawer: RobeatsDrawer(context),
            body: ListView(
              padding: EdgeInsets.only(top: 5.0),
              children: _SongListTile.prepareTiles(
                  _mediaLoader.songSet, s.data),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.queue_music, color: RobeatsThemeData.PRIMARY),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) => _QueueBottomSheet()
                );
              },
            ),
          );
        }
    );
  }
}

class _QueueBottomSheet extends Container {
  static var _mediaLibrary = Robeats.mediaLibrary;
  static var _mediaLoader = _mediaLibrary.mediaLoader;

  _QueueBottomSheet() : super(
      child: StreamBuilder<Object>(
          stream: _mediaLibrary.songDataController.songStreamController,
          builder: (_, s) {
            return ListView(
                padding: EdgeInsets.only(top: 5.0),
                children: _QueueTile.prepareTiles(_mediaLoader.songSet, s.data)
            );
          }
      )
  );
}

class _SongListTile extends Container {
  static var _mediaLibrary = Robeats.mediaLibrary;

  _SongListTile(Song song, bool current) : super(
    child: ListTile(
        leading: Icon(Icons.music_note),
        title: Text("${song.title}"),
        subtitle: Text("${song.artist}"),
        trailing: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.queue),
                  onPressed: () {
                    _mediaLibrary.songQueue.add(song);
                  }
              ),
              IconButton(
                  icon: Icon(Icons.play_circle_filled),
                  onPressed: () {
                    _mediaLibrary.playSong(song);
                  }
              )
            ],
          ),
        )
    ),
    margin: EdgeInsets.only(top: 5.0),
    decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: current ? Colors.white : Colors.grey,
            spreadRadius: 1.5,
          )
        ]
    ),
  );

  static List<_SongListTile> prepareTiles(Iterable<Song> iter, Song current) {
    if (iter != null) {
      return iter.map((song) => _SongListTile(song, current == song)).toList();
    } else {
      return List();
    }
  }
}

class _QueueTile extends Container {
  static var _mediaLibrary = Robeats.mediaLibrary;
  static int _index = 0;

  _QueueTile(Song song, bool current) : super(
    child: ListTile(
        leading: Icon(Icons.queue_music),
        title: Text("#${++_index} - ${song.title}"),
        subtitle: Text("${song.artist}"),
        trailing: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.play_circle_filled),
                  onPressed: () {
                    _mediaLibrary.playSong(song);
                  }
              )
            ],
          ),
        )
    ),
    margin: EdgeInsets.only(top: 5.0),
    decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: current ? Colors.white : Colors.grey,
            spreadRadius: 1.5,
          )
        ]
    ),
  );

  static List<_QueueTile> prepareTiles(Iterable<Song> iterable, Song current) {
    _index = 0;

    if (iterable != null) {
      return iterable.map((song) => _QueueTile(song, song == current)).toList();
    } else {
      return [];
    }
  }
}