import 'bluetoothdevice.dart';

class ESenseDevice extends BluetoothDevice {
  ESenseDevice(String name, String address, bool connected)
      : super(name, address, connected);

  bool isESense() {
    if (name.startsWith("esense")) {
      return true;
    }
    return false;
  }
}
