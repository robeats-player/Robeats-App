import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/playing_bottom_sheet.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = _mediaLibrary.mediaLoader.playlistSet.map((playlist) {
      return _PlaylistGridTile(playlist);
    }).toList();

    return Scaffold(
        appBar: RobeatsAppBar(),
        drawer: RobeatsDrawer(context),
        bottomSheet: MediaLibrary().songQueue.isEmpty && MediaLibrary().currentlyPlayingSong == null
            ? null
            : PlayingBottomSheet(),
        body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          children: widgets,
        ));
  }
}

class _PlaylistGridTile extends GridTile {
  _PlaylistGridTile(Playlist playlist)
      : super(
            child: GestureDetector(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: LayoutBuilder(
                        builder: (context, constraint) => Icon(Icons.playlist_play, size: constraint.biggest.height))),
                Expanded(
                    flex: 4,
                    child: Text(
                      playlist.identifier,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ))
              ],
            ),
          ),
          onTap: () {
            MediaLibrary().playPlaylist(playlist);
          },
        ));
}
