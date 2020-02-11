import 'dart:io';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as fbs;

final List<String> supportedDevices = ["eSense"];

final Map deviceIDs = {
  "00:04:79":"eSense" //ESense (Radius)
};

class BluetoothDevice extends fbs.BluetoothDevice {
  String name;
  String address;
  bool connected;

  BluetoothDevice(this.name, this.address, this.connected);

  bool isSupported() {
    if(deviceIDs.containsKey(this.address.substring(0,8))){
      return true;
    }
    else{
      return false;
    }
  }



}
