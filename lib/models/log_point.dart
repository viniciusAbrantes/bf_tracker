import 'package:collection/collection.dart';

class LogPoint {
  final double x;
  final double y;

  LogPoint({required this.x, required this.y});
}

List<LogPoint> get logPoints {
  final data = <double>[10, 30, 23, 11, 40];
  return data
      .mapIndexed((index, element) => LogPoint(x: index.toDouble(), y: element))
      .toList();
}
