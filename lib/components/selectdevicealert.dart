import 'package:flutter/material.dart';

import '../blocs/bluetooth-bloc.dart';

class SelectDeviceAlert extends StatelessWidget {
  final BluetoothBloc bluetoothBloc;

  //final Stream<bool> _stream;

  SelectDeviceAlert(this.bluetoothBloc);

  @override
  Widget build(BuildContext context) {
    //return StreamBuilder<bool>(
    //  stream: bluetoothBloc.getBluetoothState(),
    //initialData: false,
    //builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
    //if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    //witch (snapshot.data) {
    //case false:
    if (bluetoothBloc.activeDevice == null) {
      return Center(
          child: Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const ListTile(
          leading: Icon(Icons.bluetooth_disabled),
          title: Text('No device selected.'),
          subtitle: Text('Please select a device.'),
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: const Text('Go to Device Selection'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/DeviceSelect",
                  arguments: bluetoothBloc,
                );
              },
            ),
            /*FlatButton(
                          child: const Text('Dismiss'),
                          onPressed: () {
                            /* ... */
                          },
                        ),*/
          ],
        ),
      ])));
    }
    else{
      return Container(width: 0, height: 0);
    }
    //default:
    // return Container(width: 0, height: 0);
    //}
  }
}
