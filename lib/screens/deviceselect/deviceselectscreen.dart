import 'package:flutter/material.dart';
import 'package:pro_ear/components/bluetoothalert.dart';
import 'package:pro_ear/components/bluetoothlist.dart';

import '../../blocs/bluetooth-bloc.dart';

class DeviceSelectScreen extends StatefulWidget {
  @override
  _DeviceSelectScreenState createState() => _DeviceSelectScreenState();
}

class _DeviceSelectScreenState extends State<DeviceSelectScreen> {
  BluetoothBloc bluetoothBloc;

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
    bluetoothBloc = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Selection"),
      ),
      body: Column(
        children: <Widget>[
          BluetoothAlert(bluetoothBloc),
          BluetoothList(bluetoothBloc)
        ],
      ),
    );
  }
}
