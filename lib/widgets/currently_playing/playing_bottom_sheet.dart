import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaLibrary = MediaLibrary();

    return StreamBuilder(
      stream: mediaLibrary.playerStateData.currentSongStream,
      builder: (_, AsyncSnapshot<Song> snapshot) {
        if (snapshot.data == null && mediaLibrary.songQueue.isEmpty) {
          return Container(height: 0);
        }

        return _PlayingContainer(snapshot.data == null ? mediaLibrary.songQueue.first : snapshot.data);
      },
    );
  }
}

class _PlayingContainer extends StatelessWidget {
  final Song _song;

  _PlayingContainer(this._song);

  @override
  Widget build(BuildContext context) {
    final MediaLibrary mediaLibrary = MediaLibrary();
    String title = _song.title ?? "Unreadable";
    String artist = _song.artist ?? "Unreadable";

    StreamBuilder<AudioPlayerState> streamBuilder = StreamBuilder(
      stream: mediaLibrary.playerStateData.songStateStream,
      builder: (_, AsyncSnapshot<AudioPlayerState> snapshot) {
        return IconButton(
          iconSize: 30.0,
          icon: Icon(_chooseIcon(snapshot.data)),
          onPressed: () => mediaLibrary.toggleState(),
        );
      },
    );

    ListTile listTile = ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.music_note,
            size: 30.0,
          ),
        ],
      ),
      title: Text(title),
      subtitle: Text(artist),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          streamBuilder,
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ],
            ),
            listTile,
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
    );
  }

  IconData _chooseIcon(AudioPlayerState state) {
    return state == AudioPlayerState.PLAYING ? Icons.pause_circle_filled : Icons.play_circle_filled;
  }
}
