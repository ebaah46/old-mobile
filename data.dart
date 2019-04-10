// Class to hold sample data

class Data {
  int mqState;
  double oxyVal;
  String now;
  int id;
  Data({this.oxyVal, this.mqState, this.now, this.id});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        mqState: json['mqState'] as int,
        oxyVal: json['oxyVal'] as double,
        now: json['now'] as String,
        id: json['id'] as int);
  }
}
