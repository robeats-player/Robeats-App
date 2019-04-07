import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/data/media_loader.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class SongListScreen extends StatelessWidget {
  final MediaLoader mediaLoader = MediaLibrary.mediaLoader;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RobeatsAppBar(),
      drawer: RobeatsDrawer(context),
      body: ListView(
        padding: EdgeInsets.only(top: 5.0),
        children: _SongListTile.prepareTiles(mediaLoader.songSet),
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
}

class _QueueBottomSheet extends Container {
  _QueueBottomSheet() : super(
      child: StreamBuilder<Object>(
          stream: MediaLibrary.queueDataController.queueStreamController,
          builder: (_, snapshot) {
            return ListView(
              padding: EdgeInsets.only(top: 5.0),
              children: _QueueTile.prepareTiles(snapshot?.data),
            );
          }
      )
  );
}

class _SongListTile extends Container {
  _SongListTile(Song song) : super(
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
                    Robeats.mediaLibrary.songQueue.add(song);
                  }
              ),
              IconButton(
                  icon: Icon(Icons.play_circle_filled),
                  onPressed: () {
                    Robeats.mediaLibrary.playSong(song);
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
            color: Colors.white,
            spreadRadius: 1.5,
          )
        ]
    ),
  );

  static List<_SongListTile> prepareTiles(Iterable<Song> iterable) {
    if (iterable != null) {
      return iterable.map((song) => _SongListTile(song)).toList();
    } else {
      return List();
    }
  }
}

class _QueueTile extends Container {
  static int _index = 0;

  _QueueTile(Song song) : super(
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
                    Robeats.mediaLibrary.playSong(song);
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
            color: Colors.white,
            spreadRadius: 1.5,
          )
        ]
    ),
  );

  static List<_QueueTile> prepareTiles(Iterable<Song> iterable) {
    _index = 0;

    if (iterable != null) {
      return iterable?.map((song) => _QueueTile(song))?.toList();
    } else {
      return [];
    }
  }
}