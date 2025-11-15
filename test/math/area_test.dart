import 'package:test/test.dart';
import 'dart:math';
import 'package:root_utils/root_utils.dart';


void main() {
  group('Shoelace', (){
    test('area', (){
      List<List<double>> points = [
        [0, 0],
        [4, 0],
        [4, 4],
        [0, 4]
      ];
      expect(Area.shoelace(points), 16);
    });

    test('area from Points', (){
      List<Point> points = [
        Point(0, 0),
        Point(4, 0),
        Point(4, 4),
        Point(0, 4)
      ];
      expect(Area.shoelaceFromPoints(points), 16);
    });
  });
}
