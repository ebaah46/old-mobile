import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:isolate/isolate_runner.dart';
import 'package:old/data.dart';
import 'aboutwidget.dart' as about;

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

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

String load = "Okay";
int rating = 1;
int mqCounter = 0;
bool flag = false;
List level = ["40%", "60%", "80%"];
List status = ["LOW", "OKAY", "GREAT"];
List mqStates = ["GOOD", "BAD"];

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  Animation containerAnim, circleAnim;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    handleResponse();
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    containerAnim = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(curve: Curves.bounceInOut, parent: controller));
    circleAnim = Tween(begin: 1.0, end: 0).animate(CurvedAnimation(
        curve: Interval(0.2, 1.0, curve: Curves.bounceInOut),
        parent: controller));
  }

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;
    controller.forward();
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Home",
                  style: TextStyle(
                    fontSize: 22.0,
                  )),
            ),
            body: Stack(
              overflow: Overflow.clip,
              fit: StackFit.passthrough,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage("assets/images/lab2.jpeg"),
                        fit: BoxFit.fitHeight),
                  ),
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                    child: Container(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Container(
                        transform: Matrix4.translationValues(
                            0.0, containerAnim.value * devHeight, 0.0),
                        height: 220.0,
                        width: 358.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            color: Colors.teal.withOpacity(0.3),
                            shape: BoxShape.rectangle),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 60.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            flag == false
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                    child:
                                                        CircularProgressIndicator())
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          "O2:",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(load,
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .white))
                                                      ],
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 140,
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    about.AboutWidgetState
                                                        .navToDialerScreen();
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                          height: 20.0,
                                                          width: 20.0,
                                                          child: Icon(
                                                              Icons.call,
                                                              color:
                                                                  Colors.white,
                                                              size: 18.0)),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text("Emegency",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontSize: 18.0,
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            flag == false
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 3),
                                                    child:
                                                        CircularProgressIndicator())
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                            left: 5),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("MQ:",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .white)),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(
                                                            mqStates[mqCounter],
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontFamily:
                                                                    "Roboto",
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 140,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                about.AboutWidgetState
                                                    .safetyThresholds();
                                              },
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      height: 20.0,
                                                      width: 20.0,
                                                      child: Icon(Icons.help,
                                                          color: Colors.white,
                                                          size: 18.0)),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text("Safety Tips",
                                                      style: TextStyle(
                                                          fontFamily: "Roboto",
                                                          fontSize: 18.0,
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.white,
                                                    size: 22.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text("Fisheries Lab 1",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontFamily: "Roboto",
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 120,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                about.AboutWidgetState.faq();
                                              },
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.security,
                                                    color: Colors.white,
                                                    size: 20.0,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text("FAQ",
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontFamily: "Roboto",
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  top: 10.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 0.0),
                        child: Icon(
                          Icons.location_on,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Text(
                          "Lab 1",
                          style: TextStyle(
                              fontSize: 25.0,
                              fontStyle: FontStyle.normal,
                              fontFamily: "Roboto",
                              color: Colors.white),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 220.0, right: 50.0, top: 10.0),
                            child: Container(
                              height: 25,
                              width: 30,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/app_icon.jpeg"))),
                            ),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 165.0),
                            child: Text(
                              "Air Quality",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Stack(
                      overflow: Overflow.visible,
                      fit: StackFit.passthrough,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                  child: Center(
                                    child: Container(
                                      height: 125,
                                      width: 125,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              style: BorderStyle.solid,
                                              color: Colors.white)),
                                      child: Center(
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: Column(
                                            children: <Widget>[
                                              flag == false
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          5.0, 30.0, 5.0, 0.0),
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.amber,
                                                      )))
                                                  : Column(children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8.0,
                                                                8.0,
                                                                8.0,
                                                                0.0),
                                                        child: Text(
                                                          "Air Quality",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 12.0),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8.0,
                                                                5.0,
                                                                8.0,
                                                                0.0),
                                                        child: Text(
                                                          level[rating],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30.0),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5.0,
                                                                0.0,
                                                                5.0,
                                                                8.0),
                                                        child: Text(
                                                          status[rating],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.0),
                                                        ),
                                                      ),
                                                    ]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  transform: Matrix4.translationValues(
                                      0.0, circleAnim.value * devHeight, 0.0),
                                  height: 150.0,
                                  width: 150.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.teal.withOpacity(0.3))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future handleResponse() async {
    List<Data> response = await fetchInBackground(http.Client());
    if (response.isNotEmpty)
      setState(() {
        flag = true;
      });
    if (response.elementAt(response.length - 1).mqState == 1) {
      setState(() {
        mqCounter = 1;
      });
    } else {
      setState(() {
        mqCounter = 0;
      });
    }
    if (response.elementAt(0).oxyVal <= 19.5 ||
        response.elementAt(0).oxyVal > 21.5)
      setState(() {
        rating = 0;
      });
    else if (response.elementAt(0).oxyVal <= 20.4)
      setState(() {
        rating = 1;
      });
    else {
      setState(() {
        rating = 2;
      });
    }
    String oxyData = response.elementAt(response.length - 1).oxyVal.toString();
    setState(() {
      load = oxyData;
    });
  }
}
