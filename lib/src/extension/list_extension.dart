T zeroOf<T extends num>() {
  if (T == int) {
    return 0 as T;
  } else if (T == double) {
    return 0.0 as T;
  } else if (T == num) {
    return 0 as T;
  } else {
    throw ArgumentError('Type $T is not supported');
  }
}

T oneOf<T extends num>() {
  if (T == int) {
    return 1 as T;
  } else if (T == double) {
    return 1.0 as T;
  } else if (T == num) {
    return 1 as T;
  } else {
    throw ArgumentError('Type $T is not supported');
  }
}

extension Sum<T extends num> on List<T> {
  T sum(){
    if(isEmpty){
      return zeroOf<T>();
    }
    return fold(zeroOf<T>(), (a, b) => (a + b) as T);
  }
}

extension Mul<T extends num> on List<T> {
  T mul(){
    if(isEmpty){
      return oneOf<T>();
    }
    return fold(oneOf<T>(), (a, b) => (a * b) as T);
  }
}

extension Min<T extends num> on List<T> {
  T min(){
    if(isEmpty){
      throw Exception('List is empty');
    }
    return reduce((a, b) => a < b ? a : b);
  }
}

extension Max<T extends num> on List<T> {
  T max(){
    if(isEmpty){
      throw Exception('List is empty');
    }
    return reduce((a, b) => a > b ? a : b);
  }
}