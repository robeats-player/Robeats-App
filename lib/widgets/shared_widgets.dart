import 'package:Robeats/main.dart';
import 'package:Robeats/widgets/local_library_screen.dart';
import 'package:Robeats/widgets/local_network_screen.dart';
import 'package:Robeats/widgets/play_screen.dart';
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
            title: Text("Local Library"),
            onTap: () {
              Navigator.pop(buildContext);
              Navigator.push(buildContext, MaterialPageRoute(
                  builder: (buildContext) => LocalLibraryScreen()));
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