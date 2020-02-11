import 'dart:async';
import 'dart:math';

import 'package:pro_ear/blocs/bloc.dart';
import 'package:esense_flutter/esense.dart';
import 'package:pro_ear/blocs/bluetooth-bloc.dart';
import 'package:pro_ear/models/sensorset.dart';

final double accScaleFactor = 8192.0;
final double gRange = 4.0;
final double gyroScaleFactor = 65.5;
final double degRange = 500.0;
final double batteryMaxVoltage = 4.2;
final double batteryMinVoltage = 3.0;

class ESenseBloc extends Bloc {
  BluetoothBloc bluetoothBloc;
  bool recording = false;
  List<SensorSet> sensorSets = new List();
  double gyroScope = degRange / 10;
  double accelerationScope = gRange / 10;

  ESenseBloc(BluetoothBloc bluetoothBloc) {
    this.bluetoothBloc = bluetoothBloc;
  }

  void connectToESense() async {
    while (true) {
      if (await bluetoothBloc
          .isConnected(bluetoothBloc.activeDevice)
          .first) {
        break;
      }
      await Future.delayed(Duration(seconds: 1));
    }
    if (bluetoothBloc.activeDevice != null && await bluetoothBloc
        .isConnected(bluetoothBloc.activeDevice)
        .first) {
      ESenseManager.connectionEvents.listen((con) {
        print('ESENSE Connection event: $con');
        if (con.type == ConnectionType.connected) {
          _getESenseProperties();
          Timer(Duration(seconds: 5), () async => recognizeSensorSets());
        }
      });
    }
    while (true) {
      if (!ESenseManager.connected) {
        await ESenseManager.connect(bluetoothBloc.activeDevice.name);
      }
      await Future.delayed(Duration(seconds: 10));
    }
  }

  void _getESenseProperties() async {
    /*ESenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');
    });*/

    while (true) {
      await Future.delayed(Duration(seconds: 1));
      if (ESenseManager.connected) {
        await ESenseManager.getBatteryVoltage();
        await Future.delayed(Duration(seconds: 20));
      } else {
        break;
      }
    }

    /*
    Timer.periodic(
        Duration(seconds: 10),
        (timer) async => Timer(Duration(seconds: 1),
            () async => await ESenseManager.getBatteryVoltage()));
   Timer.periodic(
        Duration(seconds: 10),
        (timer) async => Timer(Duration(seconds: 2),
            () async => await ESenseManager.getDeviceName()));
    Timer.periodic(
        Duration(seconds: 10),
        (timer) async => Timer(Duration(seconds: 3),
            () async => await ESenseManager.getAccelerometerOffset()));
    Timer.periodic(
        Duration(seconds: 10),
        (timer) async => Timer(
            Duration(seconds: 4),
            () async =>
                await ESenseManager.getAdvertisementAndConnectionInterval()));
*/
  }

  Stream<dynamic> getEventStream() async* {
    if (ESenseManager.connected) {
      yield* ESenseManager.eSenseEvents.asBroadcastStream();
      /*await for (final event in ESenseManager.eSenseEvents) {
        print('ESENSE event: $event');
        yield event.toString();
      }*/
    }
  }

  Stream<dynamic> getSensorStream() async* {
    //yield* ESenseManager.sensorEvents;
    if (ESenseManager.connected) {
      yield* ESenseManager.sensorEvents.asBroadcastStream();
    }
    /*if (ESenseManager.connected) {
      await for (final event in ESenseManager.sensorEvents) {
        print('SENSOR event: $event');
        yield event;
      }
    }*/
  }

  Stream<List<double>> getAcceleration() async* {
    if (ESenseManager.connected) {
      await for (final event in getSensorStream()) {
        yield toG(event.accel);
      }
    }
  }

  Stream<List<double>> getGyro() async* {
    if (ESenseManager.connected) {
      await for (final event in getSensorStream()) {
        yield toDegPerSec(event.gyro);
      }
    }
  }

  static List<double> toG(List<int> list) {
    return list.map((element) => element / accScaleFactor).toList();
  }

  static List<double> toDegPerSec(List<int> list) {
    return list.map((element) => element / gyroScaleFactor).toList();
  }

  Stream<double> getBatteryPercent() async* {
    if (ESenseManager.connected) {
      await for (final event in ESenseManager.eSenseEvents) {
        if (event.runtimeType == BatteryRead) {
          //print('BATTERY event: $event');
          if ((event as BatteryRead).voltage < batteryMaxVoltage) {
            yield ((event as BatteryRead).voltage - batteryMinVoltage) / (batteryMaxVoltage - batteryMinVoltage) * 100.0;
          } else {
            yield 100.0;
          }
        }
      }
    }
  }

  void startRecording() {
    recording = true;
    recordSensors();
  }

  void stopRecording() {
    recording = false;
  }

  Stream<bool> isRecording() async* {
    yield recording;
  }

  void recordSensors() async {
    SensorSet sensorSet = new SensorSet("New SensorSet", new List(), new List(), true, true, true);
    var accelerationSubscription;
    accelerationSubscription = getAcceleration().listen((event) {
      if (recording) {
        if (sensorSet.accelerationList.length == 0) {
          for (int i = 0; i < event.length; i++) {
            sensorSet.accelerationList.add(new List());
          }
        }
        for (int i = 0; i < event.length; i++) {
          sensorSet.accelerationList[i].add(event[i]);
        }
      } else {
        accelerationSubscription.cancel();
      }
    });
    var gyroSubscription;
    gyroSubscription = getGyro().listen((event) {
      if (recording) {
        if (sensorSet.gyroList.length == 0) {
          for (int i = 0; i < event.length; i++) {
            sensorSet.gyroList.add(new List());
          }
        }
        for (int i = 0; i < event.length; i++) {
          sensorSet.gyroList[i].add(event[i]);
        }
      } else {
        gyroSubscription.cancel();
        sensorSets.add(sensorSet);
      }
    });
  }

  Stream<List<SensorSet>> getSensorSetStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 10));
      yield sensorSets;
    }
  }

  void recognizeSensorSets() async {
    if (ESenseManager.connected) {
      await for (final event in getSensorStream()) {
        for (int i = 0; i < sensorSets.length; i++) {
          if (sensorSets[i].recognizeEnabled) {
            bool skip = false;
            for (int k = sensorSets[i].currentMatches; k < sensorSets[i].gyroList[0].length; k++) {
              int axisMatches = 0;
              for (int j = 0; j < 3; j++) {
                // Acceleration
                if (!sensorSets[i].accelerationEnabled) {
                  axisMatches++;
                } else if (event.accel[j] / accScaleFactor >= sensorSets[i].accelerationList[j][k] - accelerationScope &&
                    event.accel[j] / accScaleFactor <= sensorSets[i].accelerationList[j][k] + accelerationScope) {
                  axisMatches++;
                } else {
                  skip = true;
                  break;
                }
                // Gyroscope
                if (!sensorSets[i].gyroEnabled) {
                  axisMatches++;
                } else if (event.gyro[j] / gyroScaleFactor >= sensorSets[i].gyroList[j][k] - gyroScope &&
                    event.gyro[j] / gyroScaleFactor <= sensorSets[i].gyroList[j][k] + gyroScope) {
                  axisMatches++;
                } else {
                  skip = true;
                  break;
                }
              }
              // Reset Matches
              if (skip) {
                sensorSets[i].currentMatches = 0;
                break;
                // 2 * 3 Axis
              } else if (axisMatches == 6) {
                sensorSets[i].currentMatches++;
                // Full Match
                if (sensorSets[i].currentMatches == sensorSets[i].gyroList[0].length) {
                  sensorSets[i].count++;
                  sensorSets[i].currentMatches = 0;
                }
                break;
              }
            }
          } else {
            sensorSets[i].currentMatches = 0;
          }
        }
      }
    }
  }
}
