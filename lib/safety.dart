import 'package:flutter/material.dart';

class SafetyScreen extends StatefulWidget {
  @override
  _SafetyScreenState createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  List states = [
    'Oxygen is Low',
    'Oxygen is High',
    'False MqState',
    'True MqState'
  ];
  List _functions = [_lowOxygen(), _highOxygen(), _falseMq(), _trueMq()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Safety Tips',
            style: TextStyle(fontSize: 22),
          ),
        ),
        body: PageView(
          pageSnapping: false,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[_mainTips(), _gridBody()],
        ));
  }

  Widget _header(int state) {
    return Container(
        height: 50,
        width: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(5))),
        child: Center(
          child: Text(states[state],
              style: TextStyle(fontFamily: 'Roboto', fontSize: 18)),
        ));
  }

  Widget _gridBody() {
    return GridView.count(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      mainAxisSpacing: 0,
      crossAxisSpacing: 10,
      crossAxisCount: 2,
      children: List.generate(4, (state) {
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          margin: EdgeInsets.all(10),
          child: _tileCard(state),
        );
      }),
    );
  }

  Widget _tileCard(int index) {
    return InkWell(
      splashColor: Colors.amber,
      onTap: () {
        _functions[index];
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _header(index),
            Center(
              child: Text('What you should do when an alarm is raised',
                  style: TextStyle()),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _mainTips() {
  return Material(
      type: MaterialType.canvas,
      child: Column(
        children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'General Safety Tips',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text('Tip 1',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Always use volatile and flammable solvents in an area with good ventilation or in a fume hood. Never use ether or other highly flammable solvents in a room with open flames or other ignition sources present',
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                    ),
                  ),
                ),
                Text('Tip 2',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Do not depend on your sense of smell alone to know when hazardous vapors are present. The odor of some chemicals is so strong that they can be detected at levels far below hazardous concentrations.',
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                    ),
                  ),
                ),
                Text('Tip 3',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'The odor threshold for compounds such as Chloroform and Benzene exceed acceptable exposure limits. Therefore, if you can smell it, you may have been overexposed, increase ventilation immediately',
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ));
}

_trueMq() {}

_lowOxygen() {}

_highOxygen() {}

_falseMq() {}
