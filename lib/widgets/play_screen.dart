import 'package:Robeats/main.dart';
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
            icon: Icon(Icons.play_circle_filled),
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
  double _sliderValue = 0.35;

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
                  child: Slider(
                    value: _sliderValue,
                    onChanged: (value) => setState(() => _sliderValue = value),
                  )
              ),
            )
          ],
        ),
        Row( // currently playing song.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Currenty Playing: some_song_name",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ],
    );
  }
}