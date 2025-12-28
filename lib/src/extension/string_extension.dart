extension BasicParsing on String {

  int toInt(){
    return int.parse(this).toInt();
  }

  double toDouble(){
    return double.parse(replaceAll(",", "."));
  }

  bool toBool(){
    if(toLowerCase() == "true"){
      return true;
    }
    try{
      return toDouble() != 0;
    }catch(e){
      return false;
    }
  }

  bool isInt(){
    try{
      int.parse(this);
      return true;
    }catch(e){
      return false;
    }
  }

  bool isDouble(){
    try{
      double.parse(this);
      return true;
    }catch(e){
      return false;
    }
  }

}

extension Find on String {

  /// Retourne le premier entier trouvé dans la chaine
  int findInt(){
    RegExp exp = RegExp(r"(-?[0-9]+)");

    var matches = exp.allMatches(this).map((e) => e.group(0)!);

    if (matches.isNotEmpty) {
      return matches.first.toInt();
    }

    throw Exception("No int found");
  }

  /// Retourne une liste de tous les entiers trouver dans une string
  List<int> findIntList(){
    RegExp exp = RegExp(r"(-?[0-9]+)");

    return exp.allMatches(this).map((e) => e.group(0)!.toInt()).toList();
  }

  /// Retourne le premier double trouvé dans la chaine
  double findDouble() {
    RegExp exp = RegExp(r"(-?[0-9]*[.,]?[0-9]+)");

    var matches = exp.allMatches(this).map((e) => e.group(0)!);

    if (matches.isNotEmpty) {
      return matches.first.toDouble();
    }

    throw Exception("No double found");
  }

  /// Retourne une liste de tous les doubles trouver dans une string
  List<double> findDoubleList(){
    RegExp exp = RegExp(r"(-?[0-9]*[.,]?[0-9]+)");

    return exp.allMatches(this).map((e) => e.group(0)!.toDouble()).toList();
  }

  int findDigit(){
    RegExp exp = RegExp(r"([0-9])");

    var matches = exp.allMatches(this).map((e) => e.group(0)!);

    if (matches.isNotEmpty) {
      return matches.first.toInt();
    }

    throw Exception("No digit found");
  }

  List<int> findDigitList(){
    RegExp exp = RegExp(r"([0-9])");

    return exp.allMatches(this).map((e) => e.group(0)!.toInt()).toList();
  }

}

extension Utils on String {
  String reverse() {
    return split('').reversed.join();
  }

  bool isPalindrome() {
    String firstHalf = substring(0, length ~/ 2);
    String secondHalf = substring((length + 1) ~/ 2).reverse();
    return firstHalf == secondHalf;
  }
}