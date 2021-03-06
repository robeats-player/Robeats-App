import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/currently_playing/slide_up_panel.dart';
import 'package:Robeats/widgets/local_network_screen.dart';
import 'package:Robeats/widgets/playlists/playlist_screen.dart';
import 'package:Robeats/widgets/song_list_screen.dart';
import 'package:flutter/material.dart';

class RobeatsAppBar extends AppBar {
  RobeatsAppBar() : super(title: Text(TITLE), iconTheme: IconThemeData(color: Colors.white));
}

class RobeatsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    ListTile songListListTile = ListTile(
      leading: Icon(
        Icons.book,
        size: 40.0,
      ),
      title: Text("Song List"),
      onTap: () {
        Navigator.pushReplacement(
          buildContext,
          MaterialPageRoute(builder: (buildContext) => SongListScreen()),
        );
      },
    );

    ListTile playlistsListTile = ListTile(
      leading: Icon(
        Icons.playlist_play,
        size: 40.0,
      ),
      title: Text("Playlists"),
      onTap: () {
        Navigator.pushReplacement(
          buildContext,
          MaterialPageRoute(builder: (buildContext) => PlaylistScreen()),
        );
      },
    );

    ListTile networkDevicesListTile = ListTile(
      leading: Icon(
        Icons.devices,
        size: 40.0,
      ),
      title: Text("Network Devices"),
      onTap: () {
        Navigator.pushReplacement(
          buildContext,
          MaterialPageRoute(builder: (buildContext) => LocalNetworkScreen()),
        );
      },
    );

    List<Widget> children = <Widget>[
      DrawerHeader(child: Text("Navigate", style: TextStyle(fontSize: 25.0))),
      songListListTile,
      playlistsListTile,
      networkDevicesListTile,
    ];

    return Drawer(child: ListView(children: children));
  }
}

class DefaultScaffold extends StatelessWidget {
  final Widget body;
  final AppBar appBar;
  final Drawer drawer;
  final FloatingActionButton floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  DefaultScaffold(this.body, {this.appBar, this.drawer, this.floatingActionButton, this.floatingActionButtonLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? RobeatsAppBar(),
      drawer: drawer ?? RobeatsDrawer(),
      body: RobeatsSlideUpPanel(this.body),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class SongListTile extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();
  final Song _song;
  final Color _colour;
  final IconData _icon;
  final bool _selected;

  SongListTile(this._song, [this._colour, this._icon, this._selected = false]);

  static List<Widget> prepareTiles(Iterable<Song> iterable, [Song currentSong, Color colour, IconData icon]) {
    if (iterable != null) {
      return iterable.map((song) => SongListTile(song, colour, icon, song == currentSong)).toList(growable: false);
    } else {
      return [];
    }
  }

  Container createTrailingContainer(Song song) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.queue),
            onPressed: () {
              _mediaLibrary.addToQueue(_song);
            },
          ),
          IconButton(
            icon: Icon(Icons.play_circle_filled),
            onPressed: () {
              _mediaLibrary.playSong(_song);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = _song?.title ?? "Unreadable";
    String artist = _song?.artist ?? "Unreadble";

    Decoration decoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: _colour ?? Colors.white,
          spreadRadius: 1.5,
        ),
      ],
    );

    return Container(
      margin: EdgeInsets.only(top: 5.0),
      decoration: decoration,
      child: ListTile(
        dense: true,
        selected: _selected,
        leading: Icon(_icon ?? Icons.music_note),
        title: Text("$title"),
        subtitle: Text("$artist"),
        trailing: createTrailingContainer(_song),
      ),
    );
  }
}

class RaisedIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final double elevation;
  final double highlightElevation;
  final double disabledElevation;
  final Color backgroundColour;

  RaisedIconButton({@required this.icon,
    @required this.onPressed,
    this.elevation = 6.0,
    this.highlightElevation = 12.0,
    this.disabledElevation = 0.0,
    this.backgroundColour = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: elevation,
      highlightElevation: highlightElevation,
      disabledElevation: disabledElevation,
      backgroundColor: backgroundColour,
      onPressed: onPressed,
      child: icon,
    );
  }
}
