import 'package:flutter/material.dart';
import 'package:pro_ear/blocs/bluetooth-bloc.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';
import 'package:pro_ear/theme/style.dart';
import 'package:pro_ear/routes.dart';

void main() {
  runApp(ProEarApp());
}

class ProEarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: 'ProEar',
        theme: appTheme(context),
        initialRoute: '/',
        routes: routes,
      );
  }
}
