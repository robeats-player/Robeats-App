import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/widgets/song_list_screen.dart';
import 'package:flutter/material.dart';

const String TITLE = "Robeats Player";

void main() async {
  await MediaLibrary().mediaLoader.load();
  runApp(new RobeatsApp());
}

class RobeatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Robeats Player",
      home: SongListScreen(),
      theme: RobeatsThemeData.getThemeData(),
    );
  }
}

class RobeatsThemeData {
  static const Color PRIMARY = Color.fromRGBO(63, 81, 181, 1.0);
  static const Color LIGHT = Color.fromRGBO(92, 107, 192, 1.0);
  static const Color DARK = Color.fromRGBO(92, 107, 192, 1.0);
  static const Color ACCENT = Color.fromRGBO(255, 193, 7, 1.0);
  static const Color TEXT_COLOUR = Colors.black;
  static const Color TEXT_COLOUR_INVERSE = Colors.white;
  static ThemeData _instance;

  // Cannot be instantiated.
  RobeatsThemeData._private();

  static ThemeData getThemeData() {
    if (_instance == null) {
      _instance = ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: PRIMARY,
        primaryColorLight: LIGHT,
        primaryColorDark: DARK,
        accentColor: ACCENT,
        textTheme: TextTheme().apply(displayColor: TEXT_COLOUR),
        iconTheme: IconThemeData(color: PRIMARY),
        primaryIconTheme: IconThemeData(color: Colors.black),
        accentIconTheme: IconThemeData(color: ACCENT),
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: PRIMARY,
          primaryColorDark: DARK,
          primaryColorLight: LIGHT,
          valueIndicatorTextStyle: TextStyle(color: Colors.white),
        ).copyWith(trackHeight: 2.0),
      );
    }

    return _instance;
  }
}
