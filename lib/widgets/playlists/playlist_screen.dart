import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/playlists/playlist_creation_screen.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaLibrary mediaLibrary = MediaLibrary();

    var button = FloatingActionButton(
      child: Icon(Icons.playlist_add),
      onPressed: () => PlaylistCreation().pushRoute(context),
    );

    return DefaultScaffold(
      StreamBuilder(
        stream: mediaLibrary.mediaLoader.playlistSet.behaviorSubject,
        builder: (_, AsyncSnapshot<Set<Playlist>> snapshot) {
          return GridView.count(crossAxisCount: 2, crossAxisSpacing: 10.0, children: _prepareWidgets(snapshot));
        },
      ),
      floatingActionButton: button,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  List<Widget> _prepareWidgets(AsyncSnapshot<Set<Playlist>> snapshot) {
    Set<Playlist> playlists = snapshot.data;
    List<Widget> widgets;

    if (playlists != null)
      widgets = playlists.map((playlist) => _PlaylistGridTile(playlist)).toList();
    else
      widgets = [];

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
