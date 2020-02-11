import 'package:flutter/material.dart';
import 'package:pro_ear/models/bluetoothdevice.dart';

import '../blocs/bluetooth-bloc.dart';

class BluetoothList extends StatelessWidget {
  final BluetoothBloc bluetoothBloc;

  BluetoothList(this.bluetoothBloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BluetoothDevice>>(
        stream: bluetoothBloc.discoverBluetoothDevices(),
        builder: (BuildContext context, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Icon(Icons.bluetooth_searching);
            default:
              return Flexible(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                          title: Row(children: <Widget>[
                            snapshot.data[index].isSupported() ? Text('${snapshot.data[index].name}') : Text('${snapshot.data[index].name}', style: TextStyle(color: Colors.grey)),
                            Spacer(),
                            snapshot.data[index].connected ? Icon(Icons.bluetooth_connected) : Icon(Icons.bluetooth_disabled, color: Colors.grey),
                            Icon(Icons.link),
                          ]),
                          subtitle: Text('${snapshot.data[index].address}'),
                          onTap: () {
                            if (snapshot.data[index].isSupported()) {
                              bluetoothBloc.activeDevice = snapshot.data[index];
                              Navigator.pop(context);
                            } else {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Device Not Supported'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Please choose another device.'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ));
                      }));
          }
        });
  }
}
