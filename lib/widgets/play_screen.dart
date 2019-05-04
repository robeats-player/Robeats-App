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
    List<Widget> children = <Widget>[
      Expanded(flex: 80, child: _MediaDisplay()),
      Expanded(flex: 45, child: _MediaControls()),
      Expanded(flex: 75, child: _NextQueueSong()),
    ];

    return DefaultScaffold(Column(children: children), appBar: _prepareAppBar());
  }

  AppBar _prepareAppBar() {
    Icon icon = Icon(Icons.keyboard_arrow_down, size: 30.0, color: Colors.white);
    return AppBar(leading: icon);
  }
}

class _MediaDisplay extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();
  final TextStyle _songStyle = TextStyle(color: Colors.white, fontSize: 25.0);
  final TextStyle _artistStyle = TextStyle(color: Colors.white, fontSize: 15.0);

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);

    StreamBuilder<Song> streamBuilder = StreamBuilder(
      stream: _mediaLibrary.playerStateData.currentSongStream,
      builder: _prepareWidgetBuilder(),
    );

    ShapeDecoration decoration = ShapeDecoration(
      shape: SemiCircleBorder(context),
      color: RobeatsThemeData.LIGHT,
      shadows: <BoxShadow>[
        BoxShadow(color: RobeatsThemeData.DARK, blurRadius: 5, spreadRadius: 1),
      ],
    );

    return Container(
      width: data.size.width * 0.85,
      height: data.size.height * 0.85,
      child: streamBuilder,
      decoration: decoration,
    );
  }

  AsyncWidgetBuilder<Song> _prepareWidgetBuilder() {
    return (_, AsyncSnapshot<Song> snapshot) {
      String title = snapshot.data == null ? "Choose a song!" : snapshot.data.title ?? "Unreadable";
      String artist = snapshot.data?.artist ?? "";

      Row titleRow = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("$title", style: _songStyle)],
      );

      Row artistRow = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("$artist", style: _artistStyle)],
      );

      List<Widget> children = <Widget>[Padding(padding: EdgeInsets.only(top: 25.0), child: titleRow), artistRow];
      return Column(children: children);
    };
  }
}

class _MediaControls extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[_durationRow(), _controlsRow()];

    return Column(children: children);
  }

  Row _durationRow() {
    StreamBuilder<double> streamBuilder = StreamBuilder(
      stream: _mediaLibrary.playerStateData.songDurationStream,
      builder: (_, AsyncSnapshot<double> snapshot) {
        double value = snapshot?.data;

        return Slider(value: (value ??= 0), onChanged: (value) => _mediaLibrary.seekFraction(value));
      },
    );

    List<Widget> children = [Flexible(flex: 1, child: streamBuilder)];
    return Row(children: children);
  }

  Row _controlsRow() {
    StreamBuilder<AudioPlayerState> songStateStreamBuilder = StreamBuilder(
      stream: _mediaLibrary.playerStateData.songStateStream,
      builder: (_, AsyncSnapshot<AudioPlayerState> snapshot) {
        return IconButton(
          iconSize: 60.0,
          icon: Icon(_chooseIcon(snapshot.data), color: Colors.white),
          onPressed: () => _mediaLibrary.toggleState(),
        );
      },
    );

    List<Widget> children = <Widget>[
      IconButton(
        iconSize: 40.0,
        icon: Icon(Icons.skip_previous, color: Colors.white),
        onPressed: () => _mediaLibrary.playPrevious(),
      ),
      songStateStreamBuilder,
      IconButton(
        iconSize: 40.0,
        icon: Icon(Icons.skip_next, color: Colors.white),
        onPressed: () => _mediaLibrary.playNext(),
      ),
    ];

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  IconData _chooseIcon(AudioPlayerState state) {
    return state == AudioPlayerState.PLAYING ? Icons.pause_circle_filled : Icons.play_circle_filled;
  }
}

class _NextQueueSong extends StatelessWidget {
  final MediaLibrary _mediaLibrary = MediaLibrary();

  @override
  Widget build(BuildContext context) {
    StreamBuilder<StreamQueue<Song>> streamBuilder = StreamBuilder(
      stream: _mediaLibrary.playerStateData.songQueueStream,
      builder: (_, AsyncSnapshot<StreamQueue<Song>> snapshot) {
        StreamQueue<Song> queue = snapshot.data;
        Song song = queue != null && queue.isNotEmpty ? queue.first : null;
        String title = song?.title;
        String artist = song?.artist;

        return ListTile(
          leading: Icon(Icons.music_note),
          title: Text("${title ??= "No upcoming"}"),
          subtitle: Text("${artist ??= "Songs"}"),
          trailing: Text("Up next"),
        );
      },
    );

    List<Widget> children = <Widget>[Flexible(flex: 1, child: Container(color: Colors.white, child: streamBuilder))];
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: children);
  }
}
