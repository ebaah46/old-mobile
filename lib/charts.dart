import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class Chart extends StatefulWidget {
  final List<double> oxyData;
  Chart({Key key, this.oxyData}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Oxygen Data Graph",
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
          alignment: Alignment.center,
          height: 250.0,
          width: 400.0,
          decoration: BoxDecoration(
              color: Color.fromRGBO(200, 210, 220, 13.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              shape: BoxShape.rectangle),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  " Data in ",
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
              Padding(
                padding: const EdgeInsets.only(left: 160.0, top: 30.0),
                child: RaisedButton(
                  child: new Icon(
                    Icons.file_download,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ));
  }
}
