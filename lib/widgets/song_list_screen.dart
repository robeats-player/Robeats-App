import 'dart:math' as math;

import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/playing_bottom_sheet.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class SongListScreen extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _mediaLibrary.playerStateData.currentSongStream,
        builder: (_, s) {
          return Scaffold(
            appBar: RobeatsAppBar(),
            drawer: RobeatsDrawer(context),
            bottomSheet: MediaLibrary().songQueue.isEmpty && MediaLibrary().currentlyPlayingSong == null
                ? null
                : PlayingBottomSheet(),
            body: ListView(
              padding: EdgeInsets.only(top: 5.0),
              children: _SongListTile.prepareTiles(_mediaLibrary.mediaLoader.songSet, s.data),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.queue_music, color: RobeatsThemeData.PRIMARY),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (_) => _QueueBottomSheet());
              },
            ),
            floatingActionButtonLocation: CustomEndFloatFloatingActionButtonLocation(),
          );
        });
  }
}

class _QueueBottomSheet extends Container {
  _QueueBottomSheet()
      : super(
            child: StreamBuilder<Object>(
                stream: MediaLibrary().playerStateData.songQueueStream,
                builder: (_, s) {
                  return ListView(padding: EdgeInsets.only(top: 5.0), children: _QueueTile.prepareTiles(s.data));
                }));
}

class _SongListTile extends StatelessWidget {
  final Song _song;
  final bool _current;

  _SongListTile(this._song, this._current);

  @override
  Widget build(BuildContext context) {
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
          title: Text("${_song.title}"),
          subtitle: Text("${_song.artist}"),
          trailing: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.queue),
                    onPressed: () {
                      MediaLibrary().songQueue.add(_song);
                    }),
                IconButton(
                    icon: Icon(Icons.play_circle_filled),
                    onPressed: () {
                      MediaLibrary().playSong(_song);
                    })
              ],
            ),
          )),
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

class _QueueTile extends Container {
  static int _index = 0;

  _QueueTile(Song song)
      : super(
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
                          MediaLibrary().playQueue();
                        })
                  ],
                ),
              )),
          margin: EdgeInsets.only(top: 5.0),
          decoration: BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.white,
              spreadRadius: 1.5,
            )
          ]),
        );

  static List<_QueueTile> prepareTiles(Iterable<Song> iterable) {
    _index = 0;

    if (iterable != null) {
      return iterable.map((song) => _QueueTile(song)).toList();
    } else {
      return [];
    }
  }
}

class CustomEndFloatFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Compute the x-axis offset.
    final double fabX = scaffoldGeometry.scaffoldSize.width -
        kFloatingActionButtonMargin -
        scaffoldGeometry.minInsets.right -
        scaffoldGeometry.floatingActionButtonSize.width;

    // Compute the y-axis offset.
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight - kFloatingActionButtonMargin;
    if (snackBarHeight > 0.0)
      fabY = math.min(fabY, contentBottom - snackBarHeight - fabHeight - kFloatingActionButtonMargin);
    if (bottomSheetHeight > 0.0) fabY = math.min(fabY, contentBottom - bottomSheetHeight - fabHeight - 10);

    return Offset(fabX, fabY);
  }
}
