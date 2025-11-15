int pgcd(int a, int b) {
  return b == 0 ? a.abs() : pgcd(b, a % b);
}

int ppcm(int a, int b) {
  return b == 0 ? 0 : (a * b).abs() ~/ pgcd(a, b);
}

extension LcmExtension on List<int> {
  int getPGCD() {
    if(isEmpty){
      throw Exception('List is empty');
    }
    return reduce((a, b) => pgcd(a, b));
  }

  int getPPCM() {
    if(isEmpty){
      throw Exception('List is empty');
    }
    return reduce((a, b) => ppcm(a, b));
  }
}