import 'dart:math';

import 'package:Robeats/main.dart';
import 'package:Robeats/widgets/local_network_screen.dart';
import 'package:Robeats/widgets/playlist_screen.dart';
import 'package:Robeats/widgets/song_list_screen.dart';
import 'package:flutter/material.dart';

class RobeatsAppBar extends AppBar {
  RobeatsAppBar()
      : super(
          title: Text(TITLE),
        );
}

class RobeatsDrawer extends Drawer {
  RobeatsDrawer(BuildContext buildContext)
      : super(
            child: ListView(
          children: <Widget>[
            DrawerHeader(child: Text("Navigate", style: TextStyle(fontSize: 25.0))),
            ListTile(
              leading: Icon(
                Icons.book,
                size: 40.0,
              ),
              title: Text("Song List"),
              onTap: () {
                Navigator.pushReplacement(buildContext, MaterialPageRoute(builder: (buildContext) => SongListScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.playlist_play,
                size: 40.0,
              ),
              title: Text("Playlists"),
              onTap: () {
                Navigator.pushReplacement(buildContext, MaterialPageRoute(builder: (buildContext) => PlaylistScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.devices,
                size: 40.0,
              ),
              title: Text("Network Devices"),
              onTap: () {
                Navigator.pushReplacement(
                    buildContext, MaterialPageRoute(builder: (buildContext) => LocalNetworkScreen()));
              },
            )
          ],
        ));
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
      ..addOval(Rect.fromCircle(
        center: Offset(radius * fraction, 0),
        radius: rect.shortestSide,
      ));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    double radius = _calculateRadius(rect);
    double fraction = _calculateWidthFraction(rect);

    return Path()
      ..addOval(Rect.fromCircle(
        center: Offset(radius * fraction, 0),
        radius: max(0.0, rect.shortestSide - side.width),
      ));
  }
}
