import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';

class LiveChart extends StatefulWidget {
  final Stream dataStream;
  final double range;

  LiveChart(this.dataStream, this.range);

  @override
  _LiveChartState createState() => _LiveChartState(dataStream, range);
}

class _LiveChartState extends State<LiveChart> {
  Stream dataStream;
  double range;

  _LiveChartState(this.dataStream, this.range);

  List<List<double>> dataArray = new List();

  @override
  initState() {
    super.initState();
    dataStream.listen((event) {
      setState(() {
        //print('$event');
        if (dataArray.length == 0) {
          for (int i = 0; i < event.length; i++) {
            dataArray.add(new List());
          }
        }

        for (int i = 0; i < dataArray.length; i++) {
          dataArray[i].add(event[i].toDouble());
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }



  @override
  Widget build(BuildContext context) {
    // Create A Scope Display

    return Row(
      children: <Widget>[
        for (int i = 0; i < dataArray.length; i++)
            Expanded(
                child: Container(
                    height: 100,
                    child: Oscilloscope(
                      //padding: 20.0,
                      backgroundColor: Colors.white,
                      traceColor: Colors.green,
                      yAxisMax: range,
                      yAxisMin: - range,
                      dataSet: dataArray[i],
                      showYAxis: true,
                      yAxisColor: Colors.black,
                    )))
      ],
    );
  }
}
