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
  static const Color PRIMARY = Color.fromRGBO(39, 39, 75, 1.0);
  static const Color LIGHT = Color.fromRGBO(52, 52, 104, 1.0);
  static const Color DARK = Color.fromRGBO(20, 20, 75, 1.0);
  static const Color ACCENT = Color.fromRGBO(52, 152, 219, 1.0);
  static const Color TEXT_COLOUR = Colors.white;
  static const Color TEXT_COLOUR_INVERSE = Colors.black;
  static ThemeData _instance;

  // Cannot be instantiated.
  RobeatsThemeData._private();

  static ThemeData getThemeData() {
    if (_instance == null) {
      _instance = ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: PRIMARY,
        primaryColorLight: LIGHT,
        primaryColorDark: DARK,
        accentColor: ACCENT,
        textTheme: TextTheme().apply(displayColor: TEXT_COLOUR),
        scaffoldBackgroundColor: PRIMARY,
        bottomAppBarColor: LIGHT,
        cardColor: DARK,
        splashColor: DARK,
        iconTheme: IconThemeData(color: PRIMARY),
        primaryIconTheme: IconThemeData(color: Colors.white),
        accentIconTheme: IconThemeData(color: ACCENT),
        backgroundColor: LIGHT,
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: Colors.white,
          primaryColorDark: DARK,
          primaryColorLight: Colors.white,
          valueIndicatorTextStyle: TextStyle(color: Colors.white),
        ),
      );
    }

    return _instance;
  }
}
