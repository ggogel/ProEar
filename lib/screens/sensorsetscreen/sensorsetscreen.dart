import 'package:flutter/material.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';
import 'package:pro_ear/components/sensorsetview.dart';


class SensorSetScreen extends StatefulWidget {
  @override
  _SensorSetScreenState createState() => _SensorSetScreenState();
}

class _SensorSetScreenState extends State<SensorSetScreen> {
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
    eSenseBloc = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor Sets"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/Settings",
                  arguments: {'eSenseBloc': eSenseBloc},
                );
              })
        ],

      ),
      body: ListView(
        children: <Widget>[
          SensorSetView(eSenseBloc),
        ],

      ),

    );
  }
}
