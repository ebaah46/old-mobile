import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class Graph extends StatefulWidget {
  final List<double> oxyData;
  Graph({Key key, this.oxyData}) : super(key: key);
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      alignment: Alignment.center,
      height: 160.0,
      width: 400.0,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          shape: BoxShape.rectangle),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              " Graph of Oxygen data ",
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
                colors: [Colors.deepPurple[800], Colors.deepPurple[200]]),
          ),
        ],
      ),
    );
  }
}
