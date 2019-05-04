import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaLibrary mediaLibrary = MediaLibrary();

    return RobeatsSlideUpPanel(
      DefaultScaffold(
        StreamBuilder(
          stream: mediaLibrary.mediaLoader.loaderData.playlistSetStream,
          builder: (_, AsyncSnapshot<Set<Playlist>> snapshot) {
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

    if (playlists != null) {
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
    List<Widget> children = <Widget>[
      Expanded(
        flex: 6,
        child: LayoutBuilder(
          builder: (context, constraint) => Icon(Icons.playlist_play, size: constraint.biggest.height),
        ),
      ),
      Expanded(
        flex: 4,
        child: Text(
          _playlist.identifier,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    ];

    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );

    return GridTile(
      child: GestureDetector(
        child: Card(child: column),
        onTap: () {
          MediaLibrary().playPlaylist(_playlist);
        },
      ),
    );
  }
}
