import 'package:flutter/material.dart';

import './first.dart';
import './alertwidget.dart';
import './homewidget.dart';
import './aboutwidget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final _widgetOption = [
    Text("Home"),
    Text("Logs"),
    Text("Alert"),
    Text("About")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: _widgetOption.elementAt(_selectedIndex),
        // ),
        body: Center(
          child: _buildChild(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  "Home",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
                title: Text('Logs',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_alert),
                title: Text('Alert',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            BottomNavigationBarItem(
                icon: Icon(Icons.info),
                title: Text('About',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }

  Widget _buildChild() {
    if (_widgetOption.elementAt(_selectedIndex) == _widgetOption.elementAt(0)) {
      return FirstScreen();
    } else if (_widgetOption.elementAt(_selectedIndex) ==
        _widgetOption.elementAt(1)) {
      return HomeWidget();
    } else if (_widgetOption.elementAt(_selectedIndex) ==
        _widgetOption.elementAt(2)) {
      return AlertWidget();
    } else {
      return AboutWidget();
    }
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}
