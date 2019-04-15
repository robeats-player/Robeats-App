import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/play_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayingBottomSheet extends StatelessWidget {
  final _mediaLibrary = MediaLibrary();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _mediaLibrary.playerStateData.currentSongStream,
      builder: (_, AsyncSnapshot<Song> snapshot) {
        String title = snapshot.data?.title;
        String artist = snapshot.data?.artist;
        artist ??= "";
        if (title == null)
          return Container(
            height: 0,
          );

        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext c) => PlayScreen())),
                leading: Icon(Icons.music_note),
                title: Text(title ?? "title"),
                subtitle: Text(artist ?? "artist"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StreamBuilder(
                        stream: _mediaLibrary.playerStateData.songStateStream,
                        builder: (_, AsyncSnapshot<AudioPlayerState> snapshot) {
                          if (snapshot.data == null) return Container();
                          return IconButton(
                            iconSize: 40.0,
                            icon: Icon(
                              snapshot.data == AudioPlayerState.PLAYING
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                            ),
                            onPressed: () => _mediaLibrary.toggleState(),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
