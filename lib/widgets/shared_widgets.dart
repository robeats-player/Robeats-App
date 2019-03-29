import 'package:Robeats/main.dart';
import 'package:Robeats/widgets/local_network_screen.dart';
import 'package:Robeats/widgets/play_screen.dart';
import 'package:Robeats/widgets/playlist_screen.dart';
import 'package:Robeats/widgets/song_list_screen.dart';
import 'package:flutter/material.dart';

class DarkBoxShadow extends BoxDecoration {
  DarkBoxShadow() : super(
    boxShadow: <BoxShadow>[
      BoxShadow(
          spreadRadius: 3.0,
          blurRadius: 2.0
      )
    ],
  );
}

class RobeatsAppBar extends AppBar {
  RobeatsAppBar() : super(
    title: Text(TITLE),
  );
}

class RobeatsDrawer extends Drawer {
  RobeatsDrawer(BuildContext buildContext) : super(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              child: Text("Navigate", style: TextStyle(fontSize: 25.0))
          ),
          ListTile(
            leading: Icon(Icons.book, size: 40.0,),
            title: Text("Song List"),
            onTap: () {
              Navigator.pop(buildContext);
              Navigator.push(buildContext, MaterialPageRoute(
                  builder: (buildContext) => SongListScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.playlist_play, size: 40.0,),
            title: Text("Playlists"),
            onTap: () {
              Navigator.pop(buildContext);
              Navigator.push(buildContext, MaterialPageRoute(
                  builder: (buildContext) => PlaylistScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.play_circle_filled, size: 40.0,),
            title: Text("Now Playing"),
            onTap: () {
              Navigator.pop(buildContext);
              Navigator.push(buildContext,
                  MaterialPageRoute(builder: (buildContext) => PlayScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.devices, size: 40.0,),
            title: Text("Network Devices"),
            onTap: () {
              Navigator.pop(buildContext);
              Navigator.push(buildContext, MaterialPageRoute(
                  builder: (buildContext) => LocalNetworkScreen()));
            },
          )
        ],
      )
  );
}

class DataControllerWidget<T> extends StreamBuilder<T> {
  DataControllerWidget(Function(AsyncSnapshot<T>) function) : super(
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return function(snapshot);
      }
  );
}