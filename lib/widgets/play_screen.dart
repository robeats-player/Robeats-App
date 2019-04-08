import 'package:Robeats/main.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayScreen extends StatelessWidget {
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
  static var _mediaLibrary = Robeats.mediaLibrary;
  static var _songDataController = _mediaLibrary.songDataController;

  _MediaControls() : super(
      child: Row(
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
              stream: _songDataController.stateStreamController,
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

class _MediaDisplay extends StatelessWidget {
  var _mediaLibrary = Robeats.mediaLibrary;
  var _songDataController;

  _MediaDisplay() {
    _songDataController = _mediaLibrary.songDataController;
  }

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
                    stream: _songDataController.durationStreamController,
                    builder: (_, AsyncSnapshot<double> snapshot) {
                      double value = snapshot.data != null ? snapshot.data : 0;
                      return Slider(
                        value: value,
                        onChanged: (value) {
                          _mediaLibrary.seekFraction(value);
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
              stream: _songDataController.songStreamController,
              builder: (_, AsyncSnapshot<Song> snapshot) {
                return Text(
                  _songTitleArtist(snapshot.data),
                  style: TextStyle(color: Colors.white),
                );
              },
            )
          ],
        ),
      ],
    );
  }

  static String _songTitleArtist(Song song) {
    String text;

    if (song == null) {
      text = "Choose a song!";
    } else {
      String songName = song.title;
      String artistName = song.artist;

      text = "${(artistName ??= "Unreadable")} - ${(
          songName ??= "Unreadable")}";
    }

    return text;
  }
}
