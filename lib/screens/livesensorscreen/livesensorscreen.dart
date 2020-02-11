import 'package:flutter/material.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';
import 'package:pro_ear/components/livesensorview.dart';
import 'package:pro_ear/components/sensorsetview.dart';

class LiveSensorScreen extends StatefulWidget {
  @override
  _LiveSensorScreenState createState() => _LiveSensorScreenState();
}

class _LiveSensorScreenState extends State<LiveSensorScreen> {
  ESenseBloc eSenseBloc;

  //bool recording  = eSenseBloc.recording;

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
        title: Text("Live Sensor Data"),
      ),
      body: ListView(
        children: <Widget>[
          LiveSensorView(eSenseBloc),
        ],
      ),
      floatingActionButton: !eSenseBloc.recording
          ? FloatingActionButton(
              child: Icon(Icons.fiber_manual_record, color: Colors.white),
              tooltip: 'Start Recording',
              onPressed: () {
                eSenseBloc.startRecording();
                setState(() {});
              },
            )
          : FloatingActionButton(
              child: Icon(Icons.stop, color: Colors.white),
              tooltip: 'Stop Recording',
              onPressed: () {
                eSenseBloc.stopRecording();
                setState(() {});
              },
            ),
    );
  }
}
