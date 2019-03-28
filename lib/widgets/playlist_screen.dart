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
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [ //todo: load from bloc as well.
      _PlaylistGridTile(Playlist("playlist_1"))
    ];

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
            Expanded(flex: 6, child: Icon(Icons.playlist_play)),
            Expanded(flex: 4, child: Text(
              playlist.identifier,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ))
          ],
        ),
      )
  );
}