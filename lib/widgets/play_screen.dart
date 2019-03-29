import 'package:Robeats/data/song_controller.dart';
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
  final SongDataController songDataController = SongDataController();

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
            icon: DataControllerWidget((AsyncSnapshot<PlayingSong> snapshot) {
              bool playing = snapshot.data != null
                  ? snapshot.data.isPlaying()
                  : false;

              return Icon(
                  playing ? Icons.pause_circle_filled : Icons.play_circle_filled
              );
            }),
            onPressed: null,
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
  SongDataController songDataController = SongDataController();

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
                  child: DataControllerWidget((
                      AsyncSnapshot<PlayingSong> snapshot) {
                    return Slider(
                      value: snapshot.data != null ? snapshot.data.time : 0,
                      onChanged: (value) => (snapshot.data)?.time = value,
                    );
                  })
              ),
            )
          ],
        ),
        Row( // currently playing song.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DataControllerWidget((AsyncSnapshot<PlayingSong> snapshot) {
              String songName = (snapshot.data)?.song?.identifier;

              return Text(
                songName != null
                    ? "Currently Playing: $songName"
                    : "Choose a song!",
                style: TextStyle(color: Colors.white),
              );
            })
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    /* call the data controller's dispose function. */
    songDataController.dispose();
  }


}