import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pro_ear/blocs/esense-bloc.dart';
import 'package:pro_ear/components/cutdialog.dart';
import 'package:pro_ear/components/staticchart.dart';
import 'package:pro_ear/models/sensorset.dart';

class SensorSetView extends StatelessWidget {
  final ESenseBloc eSenseBloc;

  SensorSetView(this.eSenseBloc);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<SensorSet>>(
            stream: eSenseBloc.getSensorSetStream(),
            builder: (BuildContext context, AsyncSnapshot<List<SensorSet>> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return snapshot.data == null
                  ? Container()
                  : Column(children: [
                      for (int i = 0; i < snapshot.data.length; i++)
                        Card(
                            child: ExpandableNotifier(
                                initialExpanded: false,
                                child: ScrollOnExpand(
                                    scrollOnExpand: true,
                                    scrollOnCollapse: true,
                                    child: ExpandablePanel(
                                      header: Row(children: [
                                        Container(
                                            margin: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
                                            child: Text(
                                              snapshot.data[i].name,
                                              textScaleFactor: 1.5,
                                            )),
                                        Spacer(),
                                        Switch(
                                          value: snapshot.data[i].recognizeEnabled,
                                          onChanged: (value) {
                                            snapshot.data[i].recognizeEnabled = value;
                                          },
                                        ),
                                        Text(
                                          snapshot.data[i].count.toString(),
                                          textScaleFactor: 1.5,
                                        )
                                      ]),
                                      expanded: Column(
                                        children: <Widget>[
                                          // Acceleration
                                          Switch(
                                            value: snapshot.data[i].accelerationEnabled,
                                            onChanged: (value) {
                                              snapshot.data[i].accelerationEnabled = value;
                                            },
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 50.0, right: 50, bottom: 10.0),
                                            child: StaticChart(snapshot.data[i].accelerationList, "Acceleration",
                                                snapshot.data[i].accelerationEnabled && snapshot.data[i].recognizeEnabled ? snapshot.data[i].currentMatches.toDouble() : 0.0),
                                          ),
                                          // Gyroscope
                                          Switch(
                                            value: snapshot.data[i].gyroEnabled,
                                            onChanged: (value) {
                                              snapshot.data[i].gyroEnabled = value;
                                            },
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 50.0, right: 50, bottom: 10.0),
                                            child: StaticChart(snapshot.data[i].gyroList, "Gyroscope",
                                                snapshot.data[i].gyroEnabled && snapshot.data[i].recognizeEnabled ? snapshot.data[i].currentMatches.toDouble() : 0.0),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Spacer(),
                                              IconButton(
                                                  icon: Icon(Icons.content_cut),
                                                  tooltip: "Cut length",
                                                  padding: EdgeInsets.only(left: 15, right: 15),
                                                  onPressed: () {
                                                    showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                          snapshot.data[i].recognizeEnabled = false;
                                                          return CutDialog(snapshot.data[i]);
                                                        });
                                                  }),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                tooltip: "Edit name",
                                                padding: EdgeInsets.only(left: 15, right: 15),
                                                onPressed: () {
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return SimpleDialog(
                                                        title: Text('Edit name'),
                                                        children: <Widget>[
                                                          Container(
                                                            child: TextFormField(
                                                              decoration: InputDecoration(labelText: 'Enter the new name'),
                                                              initialValue: eSenseBloc.sensorSets[i].name,
                                                              onChanged: (text) {
                                                                eSenseBloc.sensorSets[i].name = text;
                                                              },
                                                            ),
                                                            padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                                                          ),
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
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                tooltip: "Delete",
                                                padding: EdgeInsets.only(left: 15, right: 30),
                                                onPressed: () {
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Delete ' + snapshot.data[i].name),
                                                        content: SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              Text('Are you sure you want to permanently delete ' + snapshot.data[i].name + '?'),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('No'),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: Text('Yes'),
                                                            onPressed: () {
                                                              eSenseBloc.sensorSets.removeAt(i);
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ))))
                    ]);
            })
      ],
    );
  }
}
