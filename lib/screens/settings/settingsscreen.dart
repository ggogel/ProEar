import 'package:flutter/material.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';

import '../../blocs/bluetooth-bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //BluetoothBloc bluetoothBloc;
  ESenseBloc eSenseBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map;
    //bluetoothBloc = args["bluetoothBloc"];
    eSenseBloc = args["eSenseBloc"];
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(children: <Widget>[
          Container(
              margin: EdgeInsets.all(40),
              child: Column(
                children: [
                  Text(
                    "Acceleration Scope",
                    textScaleFactor: 1,
                    textAlign: TextAlign.left,
                  ),
                  Slider(
                    value: eSenseBloc.accelerationScope,
                    min: 0.0,
                    max: gRange,
                    divisions: (gRange * 10).round(),
                    label: eSenseBloc.accelerationScope.toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        eSenseBloc.accelerationScope = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Gyro Scope",
                    textScaleFactor: 1,
                    textAlign: TextAlign.left,
                  ),
                  Slider(
                    value: eSenseBloc.gyroScope,
                    min: 0.0,
                    max: degRange,
                    divisions: (degRange).round(),
                    label: eSenseBloc.gyroScope.round().toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        eSenseBloc.gyroScope = newValue;
                      });
                    },
                  ),
                ],
              )),
        ]));
  }
}
