import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as fbs;
import 'package:pro_ear/models/bluetoothdevice.dart';
import 'package:pro_ear/blocs/bloc.dart';
import 'package:pro_ear/models/esensedevice.dart';

class BluetoothBloc extends Bloc {
  fbs.FlutterBluetoothSerial flutterBluetoothSerial;
  BluetoothDevice activeDevice;

  BluetoothBloc() {
    flutterBluetoothSerial = fbs.FlutterBluetoothSerial.instance;
  }

  void enableBluetooth() {
    flutterBluetoothSerial.requestEnable();
  }

  Future<bool> getBluetoothEnabled() {
    return flutterBluetoothSerial.isEnabled;
  }

  Stream<bool> getBluetoothState() async* {
    while (true) {
      yield await getBluetoothEnabled();
    }
  }

  Stream<List<BluetoothDevice>> discoverBluetoothDevices() async* {
    while (true) {
      try {
        List<BluetoothDevice> deviceList = new List();
        List<fbs.BluetoothDevice> deviceListFbs =
            await flutterBluetoothSerial.getBondedDevices();
        for (var bd in deviceListFbs) {
          switch (deviceIDs[bd.address.substring(0, 8)]) {
            case "eSense":
              deviceList
                  .add(new ESenseDevice(bd.name, bd.address, bd.isConnected));
              break;
            default:
              deviceList.add(
                  new BluetoothDevice(bd.name, bd.address, bd.isConnected));
          }
        }
        yield deviceList;
      } on Exception {
        print("Error");
      }
    }
  }

//isConnected doesn't work on inherited BluetoothDevice object. Get original objects again.
  Stream<bool> isConnected(BluetoothDevice bluetoothDevice) async* {
    while (true) {
      List<fbs.BluetoothDevice> deviceListFbs =
          await flutterBluetoothSerial.getBondedDevices();
      for (var bd in deviceListFbs) {
        if (bd.address == bluetoothDevice.address) {
          yield bd.isConnected;
        }
      }
      //sleep(new Duration(seconds: 10));
    }
  }
}
