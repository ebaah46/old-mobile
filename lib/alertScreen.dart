import 'package:flutter/material.dart';
import 'package:old/data.dart';
import 'package:old/listScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:isolate/isolate.dart';
import 'package:flutter/foundation.dart';
//import 'package:scheduled_notifications/scheduled_notifications.dart';

// This is the implementation of the fetch dangerous data  method
Future<List<Data>> fetchDangerousData(http.Client client) async {
  // fetch data from url using particular date

  //final DateTime myDate = DateTime.now();
  final response =
      await http.get("https://old-backend.herokuapp.com/old/data/dangerous/");

  // parse the fetched data
  return parseData(response.body);
}

// Fetch dangerous data in background

Future<List<Data>> fetchInBackground(http.Client client) async {
  final runner = await IsolateRunner.spawn();
  return runner
      .run(fetchDangerousData, client)
      .whenComplete(() => runner.close());
}

// This is the implementation of the parse data function to convert the Json response to the type Data
List<Data> parseData(String responseBody) {
  List<Data> myData = new List<Data>();
  // Using the convert class in the dart package to decode the json response
  List parsedData = json.decode(responseBody.toString());
  for (int i = 0; i < parsedData.length; i++) {
    myData.add(Data.fromJson(parsedData[i]));
  }
  return myData;
}

class AlertScreen extends StatefulWidget {
  final DateTime date;
  AlertScreen(
    this.date, {
    Key key,
  }) : super(key: key);

  @override
  AlertScreenState createState() {
    return new AlertScreenState();
  }
}

class AlertScreenState extends State<AlertScreen> {
  String _appBarTitle = "Data Status";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
        ),
        body: Container(
            child: FutureBuilder<List<Data>>(
          future: fetchInBackground(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // handle the future response

              // if the future response has an error, return the error
              if (snapshot.hasError) {
                print(snapshot.error);
                return _errorInData();
              }
              // If the future response was successful, render the return list using a List screen class
              if (snapshot.hasData) {
                print(snapshot.data);

                List<Data> filteredData = List();
                snapshot.data.forEach((data) {
                  if (data.now == widget.date.toString().split(' ')[0]) {
                    filteredData.add(data);
                    print('match data printing');
                    print(data);
                  }
                });
                print('filtered data');
                print(filteredData);
                if (filteredData.isNotEmpty) {
                  print('data');

                  // Center(child: CircularProgressIndicator());
                  return ListScreen.alertConstructor(
                      // pass the snapshot data that was returned from the future to the list screen constructor as a list of type "Data"
                      widget.date,
                      filteredData);
                } else {
                  print('no data');

                  return _noData();
                }
              } else {}
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )));
  }

  Widget _noData() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 200, 5, 50),
      child: Center(
        heightFactor: 40.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.redAccent,
              size: 35.0,
            ),
            Center(
              child: Text(
                "No dangerous data was recorded for this day",
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 18.0, fontFamily: "Arial"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _errorInData() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 200, 5, 50),
      child: Center(
        heightFactor: 40.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.redAccent,
              size: 35.0,
            ),
            Center(
              child: Text(
                "An error occured while fetching data",
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 17.0, fontFamily: "Arial"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
