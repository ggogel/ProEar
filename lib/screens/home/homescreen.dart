import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';
import 'package:pro_ear/components/bluetoothalert.dart';
import 'package:pro_ear/components/deviceview.dart';
import 'package:pro_ear/components/selectdevicealert.dart';
import 'package:pro_ear/models/esensedevice.dart';

import '../../blocs/bluetooth-bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BluetoothBloc bluetoothBloc;
  ESenseBloc eSenseBloc;

  @override
  void initState() {
    super.initState();
    bluetoothBloc = BluetoothBloc();
    eSenseBloc = ESenseBloc(bluetoothBloc);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (bluetoothBloc.activeDevice != null && bluetoothBloc.activeDevice is ESenseDevice && !ESenseManager.connected) {
      eSenseBloc.connectToESense();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("ProEar"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/Settings",
                  arguments: {'bluetoothBloc': bluetoothBloc, 'eSenseBloc': eSenseBloc},
                );
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'ProEar',
                style: TextStyle(color: Colors.white70),
                textScaleFactor: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            /*ListTile(
              title: Text('Home', style: TextStyle(color: Colors.white70)),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/",
                  //arguments: {'bluetoothBloc': bluetoothBloc, 'eSenseBloc': eSenseBloc},
                );
              },
            ),*/
            //Container(height: 500),
            ListTile(
              title: Text(
                'Live Sensor Data',
                //style: TextStyle(color: Colors.white70)
              ),
              leading: Icon(Icons.live_tv),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/Live",
                  arguments: eSenseBloc,
                );
              },
            ),
            ListTile(
              title: Text(
                'Sensor Sets',
                //style: TextStyle(color: Colors.white70)
              ),
              leading: Icon(Icons.multiline_chart),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/SensorSets",
                  arguments: eSenseBloc,
                );
              },
            ),
            ListTile(
              title: Text(
                'Device Selection',
                //style: TextStyle(color: Colors.white70)
              ),
              leading: Icon(Icons.developer_mode),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/DeviceSelect",
                  arguments: bluetoothBloc,
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          BluetoothAlert(bluetoothBloc),
          SelectDeviceAlert(bluetoothBloc),
          DeviceView(bluetoothBloc, eSenseBloc),
        ],
      ),
    );
  }
}
