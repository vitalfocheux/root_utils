import 'package:test/test.dart';
import 'dart:math' as math;
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
      List<math.Point<num>> points = [
        math.Point<num>(0, 0),
        math.Point<num>(4, 0),
        math.Point<num>(4, 4),
        math.Point<num>(0, 4)
      ];
      expect(Area.shoelaceFromPoints(points), 16);
    });
  });
}
