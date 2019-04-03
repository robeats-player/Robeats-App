import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/main.dart';
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
  MediaLibrary mediaLibrary = Robeats.mediaLibrary;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = mediaLibrary.songSet.map((song) {
      return _SongListTile(song);
    }).toList();

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
        title: Text("${song.title}"),
        subtitle: Text("${song.artist}"),
        trailing: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.queue),
                  onPressed: () {
                    Robeats.mediaLibrary.songQueue.add(song);
                    print(Robeats.mediaLibrary.songQueue);
                  }
              ),
              IconButton(
                  icon: Icon(Icons.play_circle_filled),
                  onPressed: () {
                    Robeats.mediaLibrary.playSong(song);
                  }
              )
            ],
          ),
        )
    ),
    margin: EdgeInsets.only(top: 5.0),
    decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1.5,
          )
        ]
    ),
  );
}