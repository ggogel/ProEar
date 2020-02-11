import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';

import '../blocs/bluetooth-bloc.dart';

class ESenseView extends StatelessWidget {
  final BluetoothBloc bluetoothBloc;
  final ESenseBloc eSenseBloc;

  ESenseView(this.bluetoothBloc, this.eSenseBloc);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // eSense Device Info //
      Card(
        child: Column(
          children: [
            Row(children: [
              Icon(Icons.info),
              Spacer(),
            ]),
            StreamBuilder<double>(
                stream: eSenseBloc.getBatteryPercent(),
                initialData: 0.0,
                builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                  return IconRoundedProgressBar(
                    icon: Padding(padding: EdgeInsets.all(8), child: Icon(Icons.battery_std)),
                    theme: RoundedProgressBarTheme.green,
                    margin: EdgeInsets.symmetric(vertical: 16),
                    borderRadius: BorderRadius.circular(6),
                    percent: (snapshot.data),
                  );
                }),
          ],
        ),
      ),
    ]);
  }
}
