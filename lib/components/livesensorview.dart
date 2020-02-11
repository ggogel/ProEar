import 'dart:math';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';
import 'package:spider_chart/spider_chart.dart';

import 'livechart.dart';

class LiveSensorView extends StatelessWidget {
  final ESenseBloc eSenseBloc;

  LiveSensorView(this.eSenseBloc);

  static double round(double val, double places) {
    return ((val * pow(10.0, places)).round().toDouble() / pow(10.0, places));
  }

  @override
  Widget build(BuildContext context) {
    // eSense Live Data //
    return Column(children: [
      Card(
          child: Column(children: [
        SizedBox(height: 10),
        Text(
          'Accelerometer',
          textScaleFactor: 1.5,
        ),
        SizedBox(height: 5),
        StreamBuilder<dynamic>(
            stream: eSenseBloc.getAcceleration(),
            initialData: [0.0,0.0,0.0],
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');

              return Row(
                children: <Widget>[
                  Spacer(),
                  Text('X: ' + round(snapshot.data[0], 3).toString()),
                  Spacer(),
                  Text('Y: ' + round(snapshot.data[1], 3).toString()),
                  Spacer(),
                  Text('Z: ' + round(snapshot.data[2], 3).toString()),
                  Spacer()
                ],
              );
            }),
        if (ESenseManager.connected) LiveChart(eSenseBloc.getAcceleration(), gRange),
        StreamBuilder<List<double>>(
          stream: eSenseBloc.getAcceleration(),
          builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');

            return snapshot.data == null
                ? Container(width: 0, height: 0)
                : Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.all(30),
                    child: SpiderChart(
                      labels: ["X", "Y", "Z"],
                      data: [
                        snapshot.data[0].toDouble(),
                        snapshot.data[1].toDouble(),
                        snapshot.data[2].toDouble(),
                      ],
                      maxValue: gRange / 2,
                      colors: <Color>[
                        Colors.red,
                        Colors.green,
                        Colors.blue,
                      ],
                    ),
                  );
          },
        ),
      ])),
      Card(
          child: Column(children: [
        Text(
          'Gyroscope',
          textScaleFactor: 1.5,
        ),
        SizedBox(height: 10),
        StreamBuilder<dynamic>(
          stream: eSenseBloc.getGyro(),
          initialData: [0.0,0.0,0.0],
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');

            return Row(
              children: <Widget>[
                Spacer(),
                Text('X: ' + round(snapshot.data[0], 3).toString()),
                Spacer(),
                Text('Y: ' + round(snapshot.data[1], 3).toString()),
                Spacer(),
                Text('Z: ' + round(snapshot.data[2], 3).toString()),
                Spacer()
              ],
            );
          },
        ),
        if (ESenseManager.connected) LiveChart(eSenseBloc.getGyro(), degRange),
        StreamBuilder<List<double>>(
            stream: eSenseBloc.getGyro(),
            builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');

              return snapshot.data == null
                  ? Container()
                  : Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.all(30),
                      child: SpiderChart(
                        labels: ["X", "Y", "Z"],
                        data: [
                          snapshot.data[0].toDouble(),
                          snapshot.data[1].toDouble(),
                          snapshot.data[2].toDouble(),
                        ],
                        maxValue: degRange / 2,
                        colors: <Color>[
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                        ],
                      ),
                    );
            }),
      ])),
    ]);
  }
}
