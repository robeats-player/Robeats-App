import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:audioplayers/audioplayers.dart';
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
          return Container(
            height: 0,
          );
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

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text(title),
            subtitle: Text(artist),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                StreamBuilder(
                    stream: mediaLibrary.playerStateData.songStateStream,
                    builder: (_, AsyncSnapshot<AudioPlayerState> snapshot) {
                      return IconButton(
                        iconSize: 30.0,
                        icon: Icon(_chooseIcon(snapshot.data)),
                        onPressed: () => mediaLibrary.toggleState(),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _chooseIcon(AudioPlayerState state) {
    return state == AudioPlayerState.PLAYING ? Icons.pause_circle_filled : Icons.play_circle_filled;
  }
}
