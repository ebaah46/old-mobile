import 'package:flutter/material.dart';

import './data.dart';

class ListScreen extends StatefulWidget {
  final List<Data> myData;
  final DateTime dateTime;
  ListScreen({Key key, this.myData, this.dateTime}) : super(key: key);
  ListScreen.alertConstructor(this.dateTime, this.myData);

  @override
  ListScreenState createState() {
    return new ListScreenState();
  }
}

class ListScreenState extends State<ListScreen> {
  final String sensorName = "Sensor";

  final String sensorValue = "Value";

  final String oxySensor = "Oxygen";

  final String mqSensor = "Mq State";

  List _myFilteredData = new List();

  @override
  void initState() {
    super.initState();
    //print(widget.myData);
    _myFilteredData.addAll(widget.myData);
    print(_myFilteredData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _myFilteredData.length,
            itemBuilder: (context, position) {
              // Safety Icon handler
              iconHandler() {
                if (_myFilteredData[position].oxyVal < 19.5 ||
                    _myFilteredData[position].mqState == 1)
                  return Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 35.0,
                  );
                else if (_myFilteredData[position].oxyVal > 19.5 ||
                    _myFilteredData[position].mqState == 0)
                  return Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 35.0,
                  );
              }

              //Item tap handler
              onItemTap() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (_myFilteredData[position].oxyVal > 19.5 &&
                          _myFilteredData[position].mqState == 0) {
                        return AlertDialog(
                          title: Text(" Details"),
                          content: Text(
                              "The lab atmosphere is good.\nOxygen level and MQ levels are safe"),
                          actions: <Widget>[
                            RaisedButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      } else if (_myFilteredData[position].oxyVal < 19.5 &&
                          _myFilteredData[position].mqState == 0) {
                        return AlertDialog(
                          title: Text(" Details"),
                          content: Text(
                              "The lab atmosphere is not good.\nOxygen level is low but MQ levels are safe. Ventilate the room"),
                          actions: <Widget>[
                            RaisedButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      } else if (_myFilteredData[position].oxyVal > 19.5 &&
                          _myFilteredData[position].mqState == 1) {
                        return AlertDialog(
                          title: Text(" Details"),
                          content: Text(
                              "The lab atmosphere is not good.\nOxygen level is OK but MQ levels are dangerous. Check source of gas leakage "),
                          actions: <Widget>[
                            RaisedButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      } else if (_myFilteredData[position].oxyVal < 19.5 &&
                          _myFilteredData[position].mqState == 1) {
                        return AlertDialog(
                          title: Text(" Details"),
                          content: Text(
                              "The lab atmosphere is not good.\nOxygen and MQ levels are dangerous. Evacuate all students now! "),
                          actions: <Widget>[
                            RaisedButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      }
                    });
              }

              //MQ State handler

              mqHandler() {
                if (_myFilteredData[position].mqState == 1)
                  return Text("False",
                      style: TextStyle(fontWeight: FontWeight.bold));
                else
                  return Text("True",
                      style: TextStyle(fontWeight: FontWeight.bold));
              }

              //final check = dateTime.toString().split(' ');
              // String checkedDate = check[0];
              // if (myData[position].now == checkedDate) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black38))),
                child: GestureDetector(
                  onTap: onItemTap,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 100, 2),
                                child: Text(sensorName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Container(
                              padding: EdgeInsets.fromLTRB(2, 8, 2, 2),
                              child: Text(sensorValue,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(95, 10, 2, 2),
                              child: Text("Safety",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 100, 2),
                                child: Text(oxySensor)),
                            Container(
                                padding: EdgeInsets.fromLTRB(2, 5, 100, 2),
                                child: Text(
                                  '${_myFilteredData[position].oxyVal}'
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                              child: iconHandler(),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 100, 2),
                                child: Text(mqSensor)),
                            Container(
                                padding: EdgeInsets.fromLTRB(1, 5, 100, 2),
                                child: mqHandler())
                          ],
                        ),
                        Text('${_myFilteredData[position].now}'.toString())
                      ],
                    ),
                  ),
                ),
              );
              //} else {}
            }
            // }
            ));
  }
}
