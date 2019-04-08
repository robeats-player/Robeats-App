import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  var _mediaLibrary = Robeats.mediaLibrary;
  var _mediaLoader;

  PlaylistScreen() {
    _mediaLoader = _mediaLibrary.mediaLoader;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = _mediaLoader.playlistSet.map((playlist) {
      return _PlaylistGridTile(playlist);
    }).toList();

    return Scaffold(
        appBar: RobeatsAppBar(),
        drawer: RobeatsDrawer(context),
        body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          children: widgets,
        )
    );
  }
}

class _PlaylistGridTile extends GridTile {
  static var _mediaLibrary = Robeats.mediaLibrary;

  _PlaylistGridTile(Playlist playlist) : super(
      child: GestureDetector(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child: LayoutBuilder(builder: (context, constraint) =>
                      Icon(Icons.playlist_play, size: constraint.biggest.height)
                  )),
              Expanded(flex: 4, child: Text(
                playlist.identifier,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ))
            ],
          ),
        ),
        onTap: () {
          _mediaLibrary.playPlaylist(playlist);
        },
      )
  );
}