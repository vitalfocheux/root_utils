import 'dart:math';
import 'string_extension.dart';

extension BigPrime on BigInt {
  bool isPrime() {
    if (this < BigInt.from(2)) {
      return false;
    }
    for (BigInt i = BigInt.from(2); i * i <= this; i = i + BigInt.one) {
      if (this % i == BigInt.zero) {
        return false;
      }
    }
    return true;
  }

  List<BigInt> primeFactor(){
    List<BigInt> res = [];
    BigInt i = BigInt.from(2);
    BigInt n = this;
    while(n > BigInt.one){
      while(n % i == BigInt.zero){
        res.add(i);
        n = n ~/ i;
      }
      i = i + BigInt.one;
    }
    return res;
  }

  static BigInt nthPrime(num n){
    if(n < 1){
      throw ArgumentError('n doit être supérieur ou égal à 1');
    }
    int count = 0;
    BigInt num = BigInt.from(2);
    while(true){
      if(num.isPrime()){
        count++;
        if(count == n){
          return num;
        }
      }
      num = num + BigInt.one;
    }
  }
}

extension Prime on num {
  bool isPrime() {
    if (this < 2) {
      return false;
    }
    for (int i = 2; i <= sqrt(this); i++) {
      if (this % i == 0) {
        return false;
      }
    }
    return true;
  }

  List<int> primeFactor(){
    List<int> res = [];
    int i = 2;
    int n = toInt();
    while(n > 1){
      while(n % i == 0){
        res.add(i);
        n = n ~/ i;
      }
      i++;
    }
    return res;
  }

  static int nthPrime(num n){
    if(n < 1){
      throw ArgumentError('n doit être supérieur ou égal à 1');
    }
    int count = 0;
    int num = 2;
    while(true){
      if(num.isPrime()){
        count++;
        if(count == n){
          return num;
        }
      }
      num++;
    }
  }
}

extension NumericUtils on num {

  bool isPalindrome(){
    return toString().isPalindrome();
  }

  int reverse(){
    return toString().reverse().toInt();
  }

  /// Retourne le nombre de chiffres du nombre
  int get length {
    return toString().length;
  }

  /// Vérifie si le nombre est constitué de la concaténation de deux fois le même nombre
  /// Ex: 1212, 3434, 5656, 7878
  bool isSelfConcatDivisible(){
    String s = toString();
    if(s.length % 2 != 0){
      return false;
    }
    String firstHalf = s.substring(0, s.length ~/ 2);
    String secondHalf = s.substring(s.length ~/ 2);
    if(firstHalf != secondHalf){
      return false;
    }
    int n = int.parse(s);
    int half = int.parse(firstHalf);
    return n % half == 0;
  } 


  bool isBetween(num min, num max, {bool inclusive = true}){
    if(inclusive){
      return this >= min && this <= max;
    } else {
      return this > min && this < max;
    }
  }

  List<int> getDivisors(){
    List<int> divisors = [];
    for(int i = 1; i * i <= this; i++){
      if(this % i == 0){
        divisors.add(i);
        if(i != this ~/ i){
          divisors.add(this ~/ i);
        }
      }
    }
    return divisors..sort();
  }
}