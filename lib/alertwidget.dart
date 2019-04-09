import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:old/alertScreen.dart';
import 'package:old/data.dart';

//import 'package:fluttertoast/fluttertoast.dart';

class AlertWidget extends StatefulWidget {
  AlertWidget({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AlertWidgetState();
  }
}

class AlertWidgetState extends State<AlertWidget> {
  // Set default date to today
  static DateTime _pickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Alerts",
          style: TextStyle(fontSize: 22.0),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Container(
            child: CalendarCarousel(
              onDayPressed: (DateTime date, List<Data> dangerous) {
                this.setState(() {
                  _pickedDate = date;
                  print(date);
                  return navToDangerousPage(_pickedDate);
                });
              },
            ),
          )),
        ],
      ),
    );
  }

//  Navigate to next page
  navToDangerousPage(DateTime date) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AlertScreen(date)));
  }

  // _showToastMessage() {
  //   return Fluttertoast.showToast(
  //       msg: "Day selected was ",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIos: 2,
  //       backgroundColor: Colors.blueAccent,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }
// Widget to return when No data was recorded for that day

}
