import 'package:flutter/material.dart';

import '../blocs/bluetooth-bloc.dart';

class BluetoothAlert extends StatelessWidget {
  final BluetoothBloc bluetoothBloc;
  //final Stream<bool> _stream;

  BluetoothAlert(this.bluetoothBloc);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: bluetoothBloc.getBluetoothState(),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.data) {
            case false:
              return Center(
                  child: Card(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.bluetooth_disabled),
                      title: Text('Bluetooth is disabled.'),
                      subtitle:
                          Text('Please enable Bluetooth.'),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('Enable'),
                          onPressed: () {
                            bluetoothBloc.enableBluetooth();
                          },
                        ),
                      ],
                    ),
                  ])));
            default:
              return Container(width: 0, height: 0);
          }
        });
  }
}
