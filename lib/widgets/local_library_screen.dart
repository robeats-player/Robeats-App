import 'package:Robeats/main.dart';
import 'package:Robeats/network/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class LocalLibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocalLibraryState();
  }
}

class _LocalLibraryState extends State<LocalLibraryScreen> {
  static int pageIndex = 0;

  // all songs = 0
  // playlist = 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RobeatsAppBar(),
      drawer: RobeatsDrawer(context),
      bottomNavigationBar: _LibraryBottomNavigationBar(this),
      body: _LibraryPageBuilder(pageIndex),
    );
  }
}

class _LibraryPageBuilder extends StatelessWidget {
  final int _pageIndex;

  _LibraryPageBuilder(this._pageIndex);

  @override
  Widget build(BuildContext context) {
    switch (_pageIndex) {
      case 0:
        return _createSongsListView();
        break;
      default:
        return _createPlaylistView();
    }
  }

  static ListView _createSongsListView() {
    List<Widget> widgets = [ //todo: load from bloc.
      _SongListTile(Song("test", "song_name"))
    ];

    return ListView(children: widgets);
  }

  static GridView _createPlaylistView() {
    List<Widget> widgets = [
      _PlaylistGridTile(Playlist("playlist_name"))
    ]; //todo: load from bloc.

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      children: widgets,
    );
  }
}

class _LibraryBottomNavigationBar extends BottomNavigationBar {
  _LibraryBottomNavigationBar(_LocalLibraryState state) : super(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.library_music), title: Text("Songs")),
      BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play), title: Text("Playlists")),
    ],
    currentIndex: _LocalLibraryState.pageIndex,
    fixedColor: Colors.blue,
    onTap: (index) {
      state.setState(() {
        _LocalLibraryState.pageIndex = index;
      });
    },
  );
}

class _SongListTile extends Container {
  _SongListTile(Song song) : super(
    child: ListTile(
      leading: Icon(Icons.music_note),
      title: Text(song.identifier),
    ),
    margin: EdgeInsets.only(top: 5.0),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1.5,
          )
        ]
    ),
  );
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