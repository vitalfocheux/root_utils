num pgcd(num a, num b) {
  return b == 0 ? a.abs() : pgcd(b, a % b);
}

num ppcm(num a, num b) {
  return b == 0 ? 0 : (a * b).abs() ~/ pgcd(a, b);
}

extension LcmExtension on List<num> {
  num getPGCD() {
    if(isEmpty){
      throw Exception('List is empty');
    }
    return reduce((a, b) => pgcd(a, b));
  }

  num getPPCM() {
    if(isEmpty){
      throw Exception('List is empty');
    }
    return reduce((a, b) => ppcm(a, b));
  }
}