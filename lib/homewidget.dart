import 'package:flutter/material.dart';
import 'dart:convert'; // Class to convert Json data received from webserver into a Data
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isolate/isolate.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:old/graphContainer.dart';
import './data.dart';

// Data for file
List<String> emailData = new List();

//Convert Http response into a list of "Data" objects
List<Data> parseData(String responseBody) {
  List<Data> myData = new List<Data>();
  List parsedData = json.decode(responseBody.toString());
  for (int i = 0; i < parsedData.length; i++) {
    myData.add(Data.fromJson(parsedData[i]));
  }
  return myData;
}

// Fetch data
Future<List<Data>> fetchData(http.Client client) async {
  final response = await http.get('https://old-backend.herokuapp.com/old/data');

  return parseData(response.body);
}

Future<List<Data>> fetchInBackground(http.Client client) async {
  final runner = await IsolateRunner.spawn();
  return runner.run(fetchData, client).whenComplete(() => runner.close());
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  HomeWidgetState createState() {
    return new HomeWidgetState();
  }
}

class HomeWidgetState extends State<HomeWidget> {
  List<Data> infoData = new List();
  String oxy;
  List<double> oxyData = new List();

  final String sensorName = "Sensor";

  final String sensorValue = "Value";

  final String oxySensor = "Oxygen";

  final String mqSensor = "Mq State";
  bool refreshComplete = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    // Inititializing shared preferences object
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.graphic_eq), onPressed: bottomData)
        ],
        centerTitle: true,
        title: Text(
          "Logs",
          style: TextStyle(fontSize: 22.0),
        ),
      ),
      body: new LiquidPullToRefresh(
          onRefresh: refreshFuture,
          height: 80.0,
          color: Colors.amberAccent,
          backgroundColor: Colors.blueGrey[800],
          showChildOpacityTransition: false,
          child: myHomeScreen(infoData)),
    );
  }

  Future refreshFuture() async {
    final response = await fetchInBackground(http.Client());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.isNotEmpty) {
      Flushbar(
        title: "Refresh Complete",
        message: "Data successfully fetched from database",
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        borderRadius: 25.0,
        backgroundColor: Colors.blueGrey[800],
        duration: Duration(seconds: 3),
      ).show(context);
    }

    setState(() {
      infoData.removeRange(0, infoData.length);
      infoData.addAll(response);
      oxyData.removeRange(0, oxyData.length);
      for (var i = 0; i < infoData.length; i++) {
        oxyData.add(response.elementAt(i).oxyVal);
        print(oxyData[i]);
      }
      for (var i = 0; i < infoData.length; i++) {
        if (response.elementAt(i).oxyVal < 19.5 ||
            response.elementAt(i).oxyVal > 21.5) {
          _notificationAlert();
        }
        emailData.add(response.elementAt(i).oxyVal.toString());
        prefs.setStringList('Oxygen Value ' + i.toString(), emailData);
        print(emailData[i]);
      }
    });
    return infoData;
  }

  Widget myHomeScreen(List<Data> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, position) {
          // Safety Icon handler
          iconHandler() {
            if (data[position].oxyVal < 19.5 || data[position].mqState == 1)
              return Icon(
                Icons.close,
                color: Colors.red,
                size: 35.0,
              );
            else if (data[position].oxyVal > 19.5 ||
                data[position].mqState == 0)
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
                  if (data[position].oxyVal > 19.5 &&
                      data[position].mqState == 0) {
                    return AlertDialog(
                      title: Text(" Details"),
                      content: Text(
                          "The lab atmosphere is good.\nOxygen level and MQ levels are safe"),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Close",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  } else if (data[position].oxyVal < 19.5 &&
                      data[position].mqState == 0) {
                    return AlertDialog(
                      title: Text(" Details"),
                      content: Text(
                          "The lab atmosphere is not good.\nOxygen level is low but MQ levels are safe. Ventilate the room"),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Close",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  } else if (data[position].oxyVal > 19.5 &&
                      data[position].mqState == 1) {
                    return AlertDialog(
                      title: Text(" Details"),
                      content: Text(
                          "The lab atmosphere is not good.\nOxygen level is OK but MQ levels are dangerous. Check source of gas leakage "),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Close",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  } else if (data[position].oxyVal < 19.5 &&
                      data[position].mqState == 1) {
                    return AlertDialog(
                      title: Text(" Details"),
                      content: Text(
                          "The lab atmosphere is not good.\nOxygen and MQ levels are dangerous. Evacuate all students now! "),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Close",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
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
            if (data[position].mqState == 1)
              return Text("False",
                  style: TextStyle(fontWeight: FontWeight.bold));
            else
              return Text("True",
                  style: TextStyle(fontWeight: FontWeight.bold));
          }

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
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Container(
                          padding: EdgeInsets.fromLTRB(2, 8, 2, 2),
                          child: Text(sensorValue,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(95, 10, 2, 2),
                          child: Text("Safety",
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              '${data[position].oxyVal}'.toString(),
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
                    Text('${data[position].now}'.toString())
                  ],
                ),
              ),
            ),
          );
        });
  }

  bottomData() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Wrap(
              children: <Widget>[
                Graph(
                  oxyData: oxyData,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 220.0, top: 30.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    textColor: Colors.white,
                    color: Colors.deepPurple,
                    splashColor: Colors.amberAccent,
                    child: Text("Download",
                        style: TextStyle(
                          fontSize: 15.0,
                        )),
                    onPressed: sendData,
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<dynamic> onSelectNotification(String payload) async {
    showDialog(
        context: context,
        builder: (_) => new SimpleDialog(
              title: Text(
                "Dangerous data recorded",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Your sensors have recorded dangereous data. Take action now!"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(80.0, 15.0, 5.0, 0.0),
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: call,
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            child: Text("Call 193"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          RaisedButton(
                            onPressed: ignore,
                            color: Colors.grey,
                            child: Text("Ignore"),
                            textColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ));
  }

  call() async {
    const url = 'tel: 193';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  ignore() {
    Navigator.pop(context);
  }

  void sendData() {}

  Future _notificationAlert() async {
    final androidNotificationChannel = new AndroidNotificationDetails(
        "channel id", "channelName", "channelDescription",
        importance: Importance.Max, priority: Priority.High);
    final iosNotificationChannel =
        new IOSNotificationDetails(presentAlert: true);
    final platformNotificationDetails = new NotificationDetails(
        androidNotificationChannel, iosNotificationChannel);
    await flutterLocalNotificationsPlugin.show(
        0, "Danger", "Dangerous data recorded", platformNotificationDetails);
  }
}
