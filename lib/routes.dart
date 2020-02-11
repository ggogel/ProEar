import 'package:flutter/widgets.dart';
import 'package:pro_ear/screens/deviceselect/deviceselectscreen.dart';
import 'package:pro_ear/screens/home/homescreen.dart';
import 'package:pro_ear/screens/livesensorscreen/livesensorscreen.dart';
import 'package:pro_ear/screens/sensorsetscreen/sensorsetscreen.dart';
import 'package:pro_ear/screens/settings/settingsscreen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => HomeScreen(),
  "/DeviceSelect": (BuildContext context) => DeviceSelectScreen(),
  "/Settings": (BuildContext context) => SettingsScreen(),
  "/SensorSets": (BuildContext context) => SensorSetScreen(),
  "/Live": (BuildContext context) => LiveSensorScreen(),
};