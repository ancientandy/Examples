import 'dart:convert';

class Points {
  List<Point> pointList = [];

  Points();

  void add(double x, double y, double z) {
    // If the list is null then initialise it with a filled list. If not then
    // add another point to the list
    pointList.add(Point(x, y, z));
  }

  // Handle json encode and decode
  Points.fromJson(Map<String, dynamic> json)
      : pointList = List<Point>.from(json['pointList']);
  Map<String, dynamic> toJson() => {'pointList': pointList};
}

class Point {
  final double _x;
  final double _y;
  final double _z;
  Point(this._x, this._y, this._z);

  // Handle json decode and encode
  Point.fromJson(Map<String, dynamic> json)
      : _x = json['_x'],
        _y = json['_y'],
        _z = json['_z'];

  Map<String, dynamic> toJson() => {'_x': _x, '_y': _y, '_z': _z};
}
