import 'package:Robeats/network/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class SongListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SongListScreenState();
  }
}

class _SongListScreenState extends State<SongListScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [ //todo: load from bloc.
      _SongListTile(Song("some_file_name", "Song Name 1", "artist",
          Duration(minutes: 3, seconds: 14))),
    ];

    return Scaffold(
      appBar: RobeatsAppBar(),
      drawer: RobeatsDrawer(context),
      body: ListView(
        padding: EdgeInsets.only(top: 5.0),
        children: widgets,
      ),
    );
  }
}

class _SongListTile extends Container {
  _SongListTile(Song song) : super(
    child: ListTile(
      leading: Icon(Icons.music_note),
      title: Text(song.identifier),
        subtitle: Text("${song.artist}  -  ${_prettyDuration(song.duration)}"),
        trailing: Icon(Icons.play_circle_filled)
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

  static String _prettyDuration(Duration duration) {
    int trailingSeconds = duration.inSeconds -
        (duration.inMinutes.floor() * 60);
    return "${duration.inMinutes}:$trailingSeconds";
  }
}