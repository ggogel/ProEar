import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StaticChart extends StatelessWidget {
  final List<Color> gradientColors = [Colors.red, Colors.green, Colors.blue];
  final List dataArray;
  final String name;
  final double horizontalLine;

  StaticChart(this.dataArray, this.name, this.horizontalLine);

  static List<FlSpot> toFlSpotList(List list) {
    List<FlSpot> flList = new List();
    for (int i = 0; i < list.length; i++) {
      flList.add(FlSpot(i.toDouble(),  ((list[i] * pow(10.0, 3)).round().toDouble() / pow(10.0, 3))));
    }
    return flList;
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(tooltipBottomMargin: 0, tooltipBgColor: Colors.white70)),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          interval: dataArray[0].length < 10 ? 1.0 : dataArray[0].length.toDouble() / 10,
          getTitles: (value) {
            return value.toInt().toString();
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: (getMinOfDataArray(dataArray).abs() + getMaxOfDataArray(dataArray).abs()) / 5.0,
          getTitles: (value) {
            return ((value * pow(10.0, 2)).round().toDouble() / pow(10.0, 2)).toString();
          },
        ),
      ),
      borderData: FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: dataArray[0].length.toDouble() - 1,
      extraLinesData: ExtraLinesData(showHorizontalLines: true, horizontalLines: [HorizontalLine(x: horizontalLine)]),
      lineBarsData: [
        for (int i = 0; i < dataArray.length; i++)
          LineChartBarData(
              spots: toFlSpotList(dataArray[i]),
              colors: [gradientColors[i]],
              isCurved: true,
              dotData: FlDotData(
                show: false,
              )),
      ],
    );
  }

  static double getMaxOfDataArray(List<List<double>> dataArray) {
    double max = (-pow(2, 53)).toDouble();
    for (int i = 0; i < dataArray.length; i++) {
      for (int j = 0; j < dataArray[i].length; j++) {
        if (dataArray[i][j] > max) {
          max = dataArray[i][j];
        }
      }
    }
    return max;
  }

  static double getMinOfDataArray(List<List<double>> dataArray) {
    double min = (pow(2, 53)).toDouble();
    for (int i = 0; i < dataArray.length; i++) {
      for (int j = 0; j < dataArray[i].length; j++) {
        if (dataArray[i][j] < min) {
          min = dataArray[i][j];
        }
      }
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
            //borderRadius: const BorderRadius.all(Radius.circular(18)),
            gradient: LinearGradient(
          colors: const [
            Color(0xffffffff),
            Color(0xffffffff),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                /* Text(
                  'Unfold Shop 2018',
                  style: TextStyle(
                    color: const Color(0xff827daa),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),*/
                Text(
                  name,
                  textScaleFactor: 1.5,
                  //style: TextStyle(
                  //color: Colors.black,
                  ////letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                      child: LineChart(
                        mainData(),
                        swapAnimationDuration: Duration(milliseconds: 250),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
