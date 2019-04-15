import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/main.dart';
import 'package:Robeats/structures/data_structures/stream_queue.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/shared_widgets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity > 0) Navigator.of(context).pop();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(flex: 80, child: _MediaDisplay()),
              Expanded(flex: 45, child: _MediaControls()),
              Expanded(flex: 75, child: _NextQueueSong())
            ],
          )),
    );
  }
}

class _MediaDisplay extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    TextStyle songStyle = TextStyle(color: Colors.white, fontSize: 25.0);
    TextStyle artistStyle = TextStyle(color: Colors.white, fontSize: 15.0);

    return Container(
        width: data.size.width * 0.85,
        height: data.size.height * 0.85,
        child: StreamBuilder(
            stream: _mediaLibrary.songDataController.songStreamController,
            builder: (_, AsyncSnapshot<Song> snapshot) {
              String title = snapshot.data?.title;
              String artist = snapshot.data?.artist;
              artist ??= "";

              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${title ??= "Choose a song!"}", style: songStyle),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("$artist", style: artistStyle),
                    ],
                  )
                ],
              );
            }),
        decoration: ShapeDecoration(
            shape: SemiCircleBorder(context),
            color: RobeatsThemeData.LIGHT,
            shadows: <BoxShadow>[BoxShadow(color: RobeatsThemeData.DARK, blurRadius: 5, spreadRadius: 1)]));
  }
}

class _MediaControls extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
                flex: 1,
                child: StreamBuilder(
                  stream: _mediaLibrary.songDataController.durationStreamController,
                  builder: (_, AsyncSnapshot<double> snapshot) {
                    double value = snapshot?.data;

                    return Slider(
                      value: (value ??= 0),
                      onChanged: (value) => _mediaLibrary.seekFraction(value),
                    );
                  },
                ))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.skip_previous, color: Colors.white),
              onPressed: () => _mediaLibrary.playPrevious(),
            ),
            StreamBuilder(
                stream: _mediaLibrary.songDataController.stateStreamController,
                builder: (_, AsyncSnapshot<AudioPlayerState> snapshot) {
                  return IconButton(
                    iconSize: 60.0,
                    icon: Icon(_chooseIcon(snapshot.data), color: Colors.white),
                    onPressed: () => _mediaLibrary.toggleState(),
                  );
                }),
            IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.skip_next, color: Colors.white),
              onPressed: () => _mediaLibrary.playNext(),
            ),
          ],
        )
      ],
    );
  }

  IconData _chooseIcon(AudioPlayerState state) {
    return state == AudioPlayerState.PLAYING ? Icons.pause_circle_filled : Icons.play_circle_filled;
  }
}

class _NextQueueSong extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: StreamBuilder(
                stream: _mediaLibrary.queueDataController.queueStreamController,
                builder: (_, AsyncSnapshot<StreamQueue<Song>> snapshot) {
                  StreamQueue<Song> queue = snapshot.data;
                  Song song = queue != null && !queue.isEmpty ? queue.first : null;
                  String title = song?.title;
                  String artist = song?.artist;

                  return ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text("${title ??= "No upcoming"}"),
                      subtitle: Text("${artist ??= "Songs"}"),
                      trailing: Text("Up next"));
                }),
          ),
        )
      ],
    );
  }
}
