import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaLibrary mediaLibrary = MediaLibrary();

    return RobeatsSlideUpPanel(
      Scaffold(
        appBar: RobeatsAppBar(),
        drawer: RobeatsDrawer(context),
        body: StreamBuilder(
          stream: mediaLibrary.mediaLoader.loaderData.playlistSetStream,
          builder: (_, AsyncSnapshot<Set<Playlist>> snapshot) {
            Set<Playlist> playlists = snapshot.data;

            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              children: _prepareWidgets(snapshot),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _prepareWidgets(AsyncSnapshot<Set<Playlist>> snapshot) {
    Set<Playlist> playlists = snapshot.data;
    List<Widget> widgets = [];

    if(playlists != null) {
      widgets = playlists.map((playlist) => _PlaylistGridTile(playlist)).toList();
    }

    return widgets;
  }
}

class _PlaylistGridTile extends StatelessWidget {
  final Playlist _playlist;

  _PlaylistGridTile(this._playlist);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: LayoutBuilder(
                    builder: (context, constraint) => Icon(Icons.playlist_play, size: constraint.biggest.height)),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  _playlist.identifier,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              )
            ],
          ),
        ),
        onTap: () {
          MediaLibrary().playPlaylist(_playlist);
        },
      ),
    );
  }
}
