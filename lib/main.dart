import 'package:Robeats/data/media_library.dart';
import 'package:Robeats/widgets/play_screen.dart';
import 'package:flutter/material.dart';

const String TITLE = "Robeats Player";

void main() {
  runApp(new RobeatsApp());
}

class Robeats {
  static MediaLibrary mediaLibrary = MediaLibrary();
}

class RobeatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Robeats Player",
        home: PlayScreen(),
        theme: RobeatsThemeData.getThemeData());
  }
}

class RobeatsThemeData {
  static const Color PRIMARY = Color.fromRGBO(47, 45, 46, 1.0);
  static const Color LIGHT = Color.fromRGBO(94, 98, 98, 1.0);
  static const Color DARK = Color.fromRGBO(13, 18, 18, 1.0);
  static const Color ACCENT = Color.fromRGBO(153, 194, 77, 1.0);
  static const Color TEXT_COLOUR = Color.fromRGBO(0, 0, 0, 1.0);
  static const Color TEXT_COLOUR_INVERSE = Color.fromRGBO(255, 255, 255, 1.0);
  static ThemeData _instance;

  /// Cannot be instantiated.
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
              primaryColor: LIGHT,
              primaryColorDark: DARK,
              primaryColorLight: LIGHT,
              valueIndicatorTextStyle: TextStyle(color: Colors.white)));
    }

    return _instance;
  }
}
