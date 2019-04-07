import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/data/streams/song_data_controller.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:audioplayers/audioplayers.dart';
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
        ));
  }
}

class _MediaControls extends Container {
  // backward, play/pause, forward.
  static var _mediaLibrary = Robeats.mediaLibrary;
  static var _songStateDataController = MediaLibrary.songDataController;

  _MediaControls() : super(
      child: Row(
        // outer row.
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            iconSize: 60.0,
            icon: Icon(Icons.skip_previous),
            onPressed: () {
              _mediaLibrary.playPrevious();
            },
          ),
          IconButton(
            iconSize: 60.0,
            icon: StreamBuilder(
              stream: _songStateDataController.stateStreamController,
              builder: (_, AsyncSnapshot<AudioPlayerState> snapshot) {
                return Icon(_chooseIcon(snapshot));
              },
            ),
            onPressed: () {
              _mediaLibrary.toggleState();
            },
          ),
          IconButton(
            iconSize: 60.0,
            icon: Icon(Icons.skip_next),
            onPressed: () {
              _mediaLibrary.playNext();
            },
          )
        ],
      ),
      color: RobeatsThemeData.LIGHT);

  static IconData _chooseIcon(AsyncSnapshot<AudioPlayerState> snapshot) {
    IconData data;
    bool playing = snapshot?.data == AudioPlayerState.PLAYING;

    data = playing ? Icons.pause_circle_filled : Icons.play_circle_filled;
    return data;
  }
}

class _MediaDisplay extends StatefulWidget {
  // song name, slider, etc...
  @override
  State<StatefulWidget> createState() {
    return _MediaDisplayState();
  }
}

class _MediaDisplayState extends State<_MediaDisplay> {
  final MediaLibrary mediaLibrary = Robeats.mediaLibrary;
  final SongStateDataController songDataController = MediaLibrary
      .songDataController;

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
                    builder: (_, AsyncSnapshot<double> snapshot) {
                      double value = snapshot.data != null ? snapshot.data : 0;
                      return Slider(
                        value: value,
                        onChanged: (value) {
                          mediaLibrary.seekFraction(value);
                        },
                      );
                    },
                  )),
            )
          ],
        ),
        Row( // currently playing song.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: songDataController.songStreamController,
              builder: (_, AsyncSnapshot<Song> snapshot) {
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
