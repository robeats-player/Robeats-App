import 'dart:math' as math;

import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/widgets/local_network_screen.dart';
import 'package:Robeats/widgets/play_screen.dart';
import 'package:Robeats/widgets/playing_bottom_sheet.dart';
import 'package:Robeats/widgets/playlist_screen.dart';
import 'package:Robeats/widgets/song_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RobeatsAppBar extends AppBar {
  RobeatsAppBar() : super(title: Text(TITLE));
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

class RobeatsSlideUpPanel extends StatelessWidget {
  final _panelController = PanelController();
  final Widget _body;

  RobeatsSlideUpPanel(this._body);

  @override
  Widget build(BuildContext context) {
    final mediaLibrary = MediaLibrary();

    mediaLibrary.playerStateData.currentSongStream.listen((song) {
      if (song != null) {
        if (!_panelController.isPanelShown()) {
          _panelController.show();
        }
      } else {
        if (_panelController.isPanelShown()) {
          _panelController.hide();
        }
      }
    });

    mediaLibrary.songQueue.behaviorSubject.listen((queue) {
      if (queue.isNotEmpty) {
        if (!_panelController.isPanelShown()) {
          _panelController.show();
        }
      } else {
        if (_panelController.isPanelShown()) {
          _panelController.hide();
        }
      }
    });

    return SlidingUpPanel(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      minHeight: 90,
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(0.0),
      renderPanelSheet: false,
      controller: _panelController,
      maxHeight: MediaQuery.of(context).size.height,
      panel: PlayScreen(),
      collapsed: PlayingBottomSheet(),
      color: Colors.transparent,
      body: _body,
    );
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

class SemiCircleBorder extends CircleBorder {
  MediaQueryData _data;

  SemiCircleBorder(BuildContext context) {
    this._data = MediaQuery.of(context);
  }

  double _calculateRadius(Rect rect) {
    return (rect.shortestSide - side.width) / 2;
  }

  double _calculateWidthFraction(Rect rect) {
    return (_data.size.width / _calculateRadius(rect)) / 2;
  }

  @override
  EdgeInsetsGeometry get dimensions {
    double w = side.width;
    return EdgeInsets.fromLTRB(w, 0, w, w);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    double radius = _calculateRadius(rect);
    double fraction = _calculateWidthFraction(rect);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(radius * fraction, 0),
          radius: rect.shortestSide,
        ),
      );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    double radius = _calculateRadius(rect);
    double fraction = _calculateWidthFraction(rect);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(radius * fraction, 0),
          radius: math.max(0.0, rect.shortestSide - side.width),
        ),
      );
  }
}
