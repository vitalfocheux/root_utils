import 'dart:math';

class Vec2<T extends num> {

  T x;
  T y;

  Vec2(this.x, this.y);

  Vec2<T> operator +(Vec2<T> other) {
    return Vec2<T>(x + other.x as T, y + other.y as T);
  }

  Vec2<T> operator -(Vec2<T> other) {
    return Vec2<T>(x - other.x as T, y - other.y as T);
  }

  Vec2<T> operator *(Vec2<T> other) {
    return Vec2<T>(x * other.x as T, y * other.y as T);
  }

  Vec2<T> operator /(Vec2<T> other) {
    return Vec2<T>(x / other.x as T, y / other.y as T);
  }

  Vec2<T> operator %(Vec2<T> other) {
    return Vec2<T>(x % other.x as T, y % other.y as T);
  }

  Vec2<T> operator ~/(Vec2<T> other) {
    return Vec2<T>(x ~/ other.x as T, y ~/ other.y as T);
  }

  Vec2<T> operator -() {
    return Vec2<T>(-x as T, -y as T);
  }

  bool operator <(Vec2<T> other) {
    if(x == other.x){
      return y < other.y;
    }

    if(y == other.y){
      return x < other.x;
    }

    return x < other.x && y < other.y;
  }

  bool operator <=(Vec2<T> other) {
    return x <= other.x && y <= other.y;
  }

  bool operator <<(Vec2<T> other) {
    return x < other.x && y < other.y;
  }

  bool operator >(Vec2<T> other) {
    if(x == other.x){
      return y > other.y;
    }

    if(y == other.y){
      return x > other.x;
    }

    return x > other.x && y > other.y;
  }

  bool operator >=(Vec2<T> other) {
    return x >= other.x && y >= other.y;
  }

  bool operator >>(Vec2<T> other) {
    return x > other.x && y > other.y;
  }

  @override
  bool operator ==(Object other) {
    if(other is Vec2<T>){
      return x == other.x && y == other.y;
    }
    return false;
  }

  double distanceTo(Vec2<T> other) {
    return sqrt(pow(x - other.x as double, 2) + pow(y - other.y as double, 2));
  }

  Vec2<T> vectorTo(Vec2<T> other) {
    return other - this;
  }

  Vec2<int> toInt(){
    return Vec2<int>(x.toInt(), y.toInt());
  }

  Vec2<double> toDouble(){
    return Vec2<double>(x.toDouble(), y.toDouble());
  }

  List<T> toList(){
    return [x, y];
  }

  Vec2<T> get abs {
    return Vec2<T>(x.abs() as T, y.abs() as T);
  }

  Vec2<T> get sign {
    return Vec2<T>(x.sign as T, y.sign as T);
  }

  @override
  int get hashCode => (x, y).hashCode;

  @override
  String toString() {
    return '($x, $y)';
  }

}