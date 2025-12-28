import 'dart:math';
import 'package:root_utils/root_utils.dart';

extension Utils on num {

  bool isPalindrome(){
    return toString().isPalindrome();
  }

  int reverse(){
    return toString().reverse().toInt();
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

  bool isPrime(){
    if(this < 2){
      return false;
    }
    for(int i = 2; i <= sqrt(this); i++){
      if(this % i == 0){
        return false;
      }
    }
    return true;
  }

  bool isBetween(num min, num max, {bool inclusive = true}){
    if(inclusive){
      return this >= min && this <= max;
    } else {
      return this > min && this < max;
    }
  }
}