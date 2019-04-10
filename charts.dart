import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class Chart extends StatefulWidget {
  final List<double> oxyData;
  Chart({Key key, this.oxyData}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  // List<double> mydata = [
  //   10.0,
  //   20.0,
  //   12.5,
  //   16.5,
  //   10.0,
  //   12.0,
  //   10.5,
  //   9.0,
  //   10.8,
  //   13.5,
  //   12.0,
  //   18.0
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(200, 210, 220, 13.0),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Oxygen Data Graph",
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
          alignment: Alignment.center,
          height: 200.0,
          width: 400.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              shape: BoxShape.rectangle),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  " Data in April",
                  style: TextStyle(fontSize: 18.0, color: Colors.lightBlue),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              new Sparkline(
                data: widget.oxyData, //widget.oxyData,
                fillMode: FillMode.below,
                pointsMode: PointsMode.all,
                pointSize: 5.0,
                pointColor: Colors.black,
                fillGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.amber[800], Colors.amber[200]]),
              ),
            ],
          ),
        ));
  }
}
