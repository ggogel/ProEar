import 'package:flutter/material.dart';
import 'package:pro_ear/models/sensorset.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

class CutDialog extends StatefulWidget {
  final SensorSet _sensorSet;

  CutDialog(this._sensorSet);

  @override
  _CutDialogState createState() => _CutDialogState(_sensorSet);
}

class _CutDialogState extends State<CutDialog> {
  SensorSet _sensorSet;
  RangeValues _values;
  double _lowerValue;
  double _upperValue;

  _CutDialogState(this._sensorSet);

  @override
  void initState() {
    //_values = RangeValues(0.0, _sensorSet.gyroList[0].length.toDouble() - 1);
    _lowerValue = 0.0;
    _upperValue = _sensorSet.gyroList[0].length.toDouble() - 1;
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Cut ' + _sensorSet.name),
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: frs.RangeSlider(
                min: 0,
                max: _sensorSet.gyroList[0].length.toDouble() - 1,
                lowerValue: _lowerValue,
                upperValue: _upperValue,
                divisions: _sensorSet.gyroList[0].length - 1,
                showValueIndicator: true,
                valueIndicatorMaxDecimals: 0,
                onChanged: (double newLowerValue, double newUpperValue) {
                  setState(() {
                    _lowerValue = newLowerValue;
                    _upperValue = newUpperValue;
                  });
                })),
        Row(children: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Spacer(),
          FlatButton(
            child: Text('Confirm'),
            onPressed: () {
              for (int i = 0; i < _sensorSet.gyroList.length; i++) {
                _sensorSet.gyroList[i].removeRange(_upperValue.toInt(), _sensorSet.gyroList[i].length - 1);
                _sensorSet.gyroList[i].removeRange(0, _lowerValue.toInt());
                _sensorSet.accelerationList[i].removeRange(_upperValue.toInt(), _sensorSet.accelerationList[i].length - 1);
                _sensorSet.accelerationList[i].removeRange(0, _lowerValue.toInt());
              }
              _sensorSet.recognizeEnabled = true;
              Navigator.of(context).pop();
            },
          ),
        ])
      ],
    );
  }
}
