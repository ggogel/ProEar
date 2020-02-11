import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primaryColor: Colors.lightBlue,
    accentColor: Colors.lightBlueAccent,
    hintColor: Colors.white,
    scaffoldBackgroundColor: Color(0xfff7f9f9),
    canvasColor: Colors.lightBlueAccent,
    //iconTheme: IconThemeData(color: Colors.black87),
    primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white70)),
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white70),
        actionsIconTheme: IconThemeData(color: Colors.white70)),
    cardTheme: CardTheme(elevation: 4.0),
  );
}
