import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';
import 'package:pro_ear/components/esenseview.dart';
import 'package:pro_ear/models/esensedevice.dart';

import '../blocs/bluetooth-bloc.dart';

class DeviceView extends StatelessWidget {
  final BluetoothBloc bluetoothBloc;
  final ESenseBloc eSenseBloc;

  //final Stream<bool> _stream;

  DeviceView(this.bluetoothBloc, this.eSenseBloc);

  @override
  Widget build(BuildContext context) {
    if (bluetoothBloc.activeDevice != null) {
      return
        Column(
          //scrollDirection: Axis.vertical,
          //shrinkWrap: true,
          children: [
            Card(
              //crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              //children: <Widget>[
              child: ListTile(
                leading: Icon(Icons.headset, size: 50),
                title: Text(
                  bluetoothBloc.activeDevice.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            StreamBuilder<bool>(
              stream: bluetoothBloc.isConnected(bluetoothBloc.activeDevice),
              //stream: bluetoothBloc.getBluetoothState(),
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (snapshot.data) {
                  if (bluetoothBloc.activeDevice is ESenseDevice) {
                    return ESenseView(bluetoothBloc, eSenseBloc);
                    //return Container(width: 0, height: 0);
                  } else {
                    return Container(width: 0, height: 0);
                  }
                } else {
                  return Text("The selected device is not connected.");
                }
              },
            ),
          ],
        );
    } else {
      return Container(width: 0, height: 0);
    }
  }
}
