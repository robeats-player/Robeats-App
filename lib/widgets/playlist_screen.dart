import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/network/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlaylistScreenState();
  }
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  MediaLibrary mediaLibrary = Robeats.mediaLibrary;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = mediaLibrary.playlistSet.map((playlist) {
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
  _PlaylistGridTile(Playlist playlist) : super(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 6, child: LayoutBuilder(builder: (context, constraint) =>
                IconButton(
                  icon: Icon(
                      Icons.playlist_play, size: constraint.biggest.height),
                  onPressed: () {
                    print(playlist.songs.map((song) => song.title));
                  },
                )
            )),
            Expanded(flex: 4, child: Text(
              playlist.identifier,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ))
          ],
        ),
      )
  );
}