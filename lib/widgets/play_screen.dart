import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/data/song_data_controller.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/network/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';

class PlayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayScreenState();
  }
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RobeatsAppBar(),
        drawer: RobeatsDrawer(context),
        body: Column(
          children: <Widget>[
            Expanded(child: _MediaDisplay(), flex: 17),
            Expanded(child: _MediaControls(), flex: 3)
          ],
        )
    );
  }
}

class _MediaControls extends Container {
  // backward, play/pause, forward.

  _MediaControls() : super(
      child: Row( // outer row.
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            iconSize: 60.0,
            icon: Icon(Icons.skip_previous),
            onPressed: null,
          ),
          IconButton(
            iconSize: 60.0,
            icon: Icon(Icons.pause_circle_filled),
            onPressed: () {
              Robeats.mediaLibrary.toggleState();
            },
          ),
          IconButton(
            iconSize: 60.0,
            icon: Icon(Icons.skip_next),
            onPressed: null,
          )
        ],
      ),
      color: RobeatsThemeData.LIGHT
  );
}

class _MediaDisplay extends StatefulWidget {
  // song name, slider, etc...
  @override
  State<StatefulWidget> createState() {
    return _MediaDisplayState();
  }
}

class _MediaDisplayState extends State<_MediaDisplay> {
  final SongDataController songDataController = Robeats.songDataController;
  final MediaLibrary mediaLibrary = Robeats.mediaLibrary;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: Row( // this is the image/icon in the square.
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(
                    "assets/compact-disc-image-transparent.png", width: 200,
                    height: 200),
                //todo: placeholder for album cover.
              )
            ],
          ),
        ),
        Row( // slider value.
          children: <Widget>[
            Container(
              child: Flexible(
                  flex: 1,
                  child: StreamBuilder(
                    stream: songDataController.durationStreamController,
                    builder: (BuildContext buildContext,
                        AsyncSnapshot<double> snapshot) {
                      return Slider(
                        value: snapshot.data != null ? snapshot.data : 0,
                        onChanged: (value) {
                          mediaLibrary.seekFraction(value);
                        },
                      );
                    },
                  )
              ),
            )
          ],
        ),
        Row( // currently playing song.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: songDataController.songStreamController,
              builder: (BuildContext context, AsyncSnapshot<Song> snapshot) {
                String text;

                if (snapshot.data == null) {
                  text = "Choose a song!";
                } else {
                  String songName = snapshot.data?.title;
                  String artistName = snapshot.data?.artist;

                  text = "${(artistName ??= "Unreadable")} - ${(
                      songName ??= "Unreadable")}";
                }

                return Text(
                  text,
                  style: TextStyle(color: Colors.white),
                );
              },
            )
          ],
        ),
      ],
    );
  }
}