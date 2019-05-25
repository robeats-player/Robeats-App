import 'dart:async';
import 'dart:collection';

import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/structures/media.dart';
import 'package:Robeats/widgets/currently_playing/play_screen.dart';
import 'package:Robeats/widgets/currently_playing/playing_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RobeatsSlideUpPanel extends StatefulWidget {
  final Widget _body;

  RobeatsSlideUpPanel(this._body);

  @override
  State<StatefulWidget> createState() {
    return _SlideUpPanelState(_body);
  }
}

class _SlideUpPanelState extends State<RobeatsSlideUpPanel> {
  final _panelController = PanelController();
  final Widget _body;
  StreamSubscription _streamSubscription;

  _SlideUpPanelState(this._body);

  @override
  Widget build(BuildContext context) {
    _initiateSubscription();

    return SlidingUpPanel(
      minHeight: 90,
      backdropEnabled: true,
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(0.0),
      renderPanelSheet: false,
      controller: _panelController,
      panel: PlayScreen(),
      collapsed: PlayingBottomSheet(),
      color: Colors.transparent,
      body: _body,
    );
  }

  void _initiateSubscription() {
    MediaLibrary mediaLibrary = MediaLibrary();
    Observable<List> observable = Observable.combineLatest2(
      mediaLibrary.playerStateData.currentSongStream,
      mediaLibrary.songQueue.behaviorSubject,
      (a, b) => [a, b],
    );

    _streamSubscription?.cancel();
    _streamSubscription = observable.listen(
      (streams) {
        Song currentSong = streams[0];
        Queue<Song> queue = streams[1];

        if (currentSong == null && queue.isEmpty)
          _panelController.hide();
        else
          _panelController.show();
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
