import 'dart:math';

class Area {

  static double square(double side) {
    return side * side;
  }

  static double rectangle(double length, double width) {
    return length * width;
  }

  static double circle(double radius) {
    return pi * radius * radius;
  }

  static double triangle(double base, double height) {
    return 0.5 * base * height;
  }

  static double trapezoid(double base1, double base2, double height) {
    return 0.5 * (base1 + base2) * height;
  }

  static double parallelogram(double base, double height) {
    return base * height;
  }

  static double ellipse(double majorAxis, double minorAxis) {
    return pi * majorAxis * minorAxis;
  }

  /// Calcule la surface d'un polygone régulier en fonction de des coordonnées de ses sommets.
  static double shoelace(List<List<double>> points) {
    double sum = 0;
    for (int i = 0; i < points.length - 1; i++) {
      sum += points[i][0] * points[i + 1][1] - points[i + 1][0] * points[i][1];
    }
    sum += points[points.length - 1][0] * points[0][1] - points[0][0] * points[points.length - 1][1];
    return 0.5 * sum.abs();
  }

  static double shoelaceFromPoints(List<Point> points){
    double sum = 0;
    for(int i = 0; i < points.length - 1; i++){
      sum += points[i].x * points[i + 1].y - points[i + 1].x * points[i].y;
    }
    sum += points[points.length - 1].x * points[0].y - points[0].x * points[points.length - 1].y;
    return 0.5 * sum.abs();
  }

}