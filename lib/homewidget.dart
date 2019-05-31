import 'package:flutter/material.dart';
import 'dart:convert'; // Class to convert Json data received from webserver into a Data
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isolate/isolate.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:email_validator/email_validator.dart';
// import 'package:permission/permission.dart';

import 'package:old/graphContainer.dart';
import './data.dart';

// Data Storage

class DataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> _writeData(String data, FileMode mode) async {
    final file = await _localFile;
    return file.writeAsString(
      data + ',',
      mode: mode,
    );
  }

  Future<String> _readData() async {
    final file = await _localFile;
    var contents = file.readAsString();
    return contents;
  }
}

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
  HomeWidget({
    Key key,
  }) : super(key: key);

  @override
  HomeWidgetState createState() {
    return new HomeWidgetState();
  }
}

class HomeWidgetState extends State<HomeWidget> {
  final DataStorage storage = DataStorage();
  List<Data> infoData = new List();
  String oxy;
  // Variable for holding data that would be attached to the email
  String data;
  List<double> oxyData = new List();

  final String sensorName = "Sensor";

  final String sensorValue = "Value";

  final String oxySensor = "Oxygen";

  final String mqSensor = "Mq State";
  bool refreshComplete = false;
  String file = '';
  File myFile;
// Send Data button variables
  var reccpientMail;
  String response = 'Email sent to technician';
  bool buttonState = false;
  bool emailState = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

    if (response.isNotEmpty) {
      final snackbar = SnackBar(
        content: Text("Data successfully loaded..",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "Roboto",
            )),
        action: SnackBarAction(
          onPressed: () {},
          label: "Ok",
          textColor: Colors.blueAccent,
        ),
      );
      Scaffold.of(context).showSnackBar(snackbar);
    }

    setState(() {
      infoData.removeRange(0, infoData.length);
      infoData.addAll(response.reversed);
      oxyData.removeRange(0, oxyData.length);
      for (var i = 0; i < infoData.length; i++) {
        oxyData.add(response.elementAt(i).oxyVal);
        print(oxyData[i]);
      }
      for (var i = 0; i < infoData.length; i++) {
        if (response.elementAt(i).oxyVal < 19.5 ||
            response.elementAt(i).oxyVal > 21.5 ||
            response.elementAt(i).mqState == 1) {
          _notificationAlert();
        }

        storage
            ._writeData(
                response.elementAt(i).oxyVal.toString(), FileMode.append)
            .then((onValue) {
          myFile = onValue;
          print('Data written to file');
        });
        storage._readData().then((onValue) {
          data = onValue;
          print(data);
        });
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(
                        " Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                          "The lab atmosphere is good.\nOxygen level and MQ levels are safe"),
                      actions: <Widget>[
                        RaisedButton(
                          color: Colors.deepPurple,
                          child: Text(
                            "Close",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
              child: InkWell(
                splashColor: Colors.amber,
                onTap: onItemTap,
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

// bottom sheet to show graph of the oxygen data recorded
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
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                    onPressed: sendDataButton,
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

// Function to navigate to the dialer screeen
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

// Send data button widget definition
  Widget sendDataButton() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              'Email Details',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  fontSize: 16),
            ),
            titlePadding: EdgeInsets.all(10.0),
            contentPadding: EdgeInsets.all(5.0),
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Enter email address',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Roboto',
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidate: true,
                        style: TextStyle(fontFamily: "Roboto", fontSize: 12.0),
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(fontStyle: FontStyle.italic),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        validator: (String value) {
                          if (value.isEmpty ||
                              EmailValidator.validate(value) != true)
                            return 'Enter correct email address';
                          else {
                            emailState = true;
                          }
                        },
                        onFieldSubmitted: _buttonState(),
                        onSaved: (String value) {
                          reccpientMail = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        disabledColor: Colors.grey,
                        splashColor: Colors.amber,
                        padding: EdgeInsets.all(5),
                        elevation: 5.0,
                        textColor: Colors.white,
                        onPressed: () {
                          if (buttonState == false)
                            return null;
                          else {
                            _sendData();
                          }
                        },
                        child: Text(
                          "Send Data",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Colors.deepPurple,
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

// Function to send data when the email is provided
  void _sendData() {
    formKey.currentState.save();
    send();
    print('Email successfully sent ');
  }

// Function to provide the notification when dangerous data is recorded
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

  Future<void> send() async {
    final Email email = Email(
      body: 'File containing data recorded from Oxygen sensor \n $data',
      subject: 'Oxygen data',
      recipients: [reccpientMail],
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print(error);
    }
  }

  _buttonState() {
    if (emailState == true) {
      buttonState = true;
    }
  }
}
