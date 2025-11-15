import 'dart:io';
import 'package:path/path.dart' as path;

String get_aoc_path() {
  String homePath = '';
  if (Platform.isWindows) {
    homePath = Platform.environment['USERPROFILE'] ?? '';
  } else {
    homePath = Platform.environment['HOME'] ?? '';
  }
  String aoc_folder = '$homePath/.aoc';
  Directory directory = Directory(aoc_folder);
  if(!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  return aoc_folder;
}

class Cookie {

  String? cookie;

  Cookie({bool delete_cookie = false}) {
    if(delete_cookie){
      this.delete_cookie();
      print('Cookie deleted');
    }
    cookie = load_cookie();
    if(cookie == null || cookie!.isEmpty) {
      stdout.write('Please enter your AOC session cookie >');
      cookie = stdin.readLineSync();
      if(cookie!.contains(' ') || cookie!.length <= 80 || cookie!.length >= 150){
        throw ArgumentError('This does not look like a valid cookie');
      }

      save_cookie();
    }

    if(cookie == null || cookie!.isEmpty) {
      throw ArgumentError('No cookie found');
    }
  }

  @override
  String toString() {
    return cookie!;
  }

  void delete_cookie() {
    cookie = '';
    save_cookie();
  }

  String? load_cookie(){
    final cookie_file = File(path.join(get_aoc_path(), '.cookie'));
    if(!cookie_file.existsSync()) {
      cookie_file.createSync(recursive: true);
    }
    final cookie = cookie_file.readAsStringSync().trim();
    if(cookie.isEmpty) {
      return null;
    }
    return cookie;
  }

  void save_cookie() {
    final cookie_file = File(path.join(get_aoc_path(), '.cookie'));
    cookie_file.writeAsStringSync(cookie!);
  }


}

class Cache {

  final int year, day;

  Cache(this.year, this.day, {bool delete_cache = false}) {
    if(delete_cache){
      delete_files();
    }
  }

  Directory get folder {
    final cache_folder = Directory(path.join(get_aoc_path(), '.cache'));

    if(!cache_folder.existsSync()){
      cache_folder.createSync(recursive: true);
    }

    return cache_folder;
  }

  File get inputPath {
    return File(path.join(folder.path, '$year-$day-input.txt'));
  }

  String? get input {
    if(!inputPath.existsSync()) {
      return null;
    }
    return inputPath.readAsStringSync();
  }

  set input(String? raw) {
    inputPath.writeAsStringSync(raw ?? '');
  }

  File get examplePath {
    return File(path.join(folder.path, '$year-$day-example.txt'));
  }

  String? get example {
    if(!examplePath.existsSync()) {
      return null;
    }
    return examplePath.readAsStringSync();
  }

  set example(String? raw) {
    examplePath.writeAsStringSync(raw ?? '');
  }

  File get answersPath {
    return File(path.join(folder.path, '$year-$day-answers.txt'));
  }

  Set<String> answers(int part) {
    if(!answersPath.existsSync()) {
      return {};
    }
    final parts = answersPath.readAsStringSync().split('---');
    if(parts.length != 2){
      delete_files();
      print('Cache file invalid - deleting old cache file');
      return {};
    }
    if(parts[part - 1].isEmpty) {
      return {};
    }
    return parts[part - 1].split('\n').toSet();
  }

  void add_answer(int part, String answer, {bool is_solution = false}) {
    if(!answersPath.existsSync()) {
      answersPath.writeAsStringSync('---');
    }
    final parts = [answers(1), answers(2)];
    if(is_solution) {
      parts[part - 1] = {'S:$answer'};
    }else{
      parts[part - 1].add(answer);
    }
    answersPath.writeAsStringSync('${parts[0].join('\n')}\n---\n${parts[1].join('\n').trim()}');
  }

  String? solution(int part) {
    final answersList = answers(part).toList();
    if(answersList.length == 1 && answersList[0].startsWith('S:')){
      return answersList[0].substring(2);
    }
    return null;
  }

  void delete_files(){
    if(answersPath.existsSync()) {
      answersPath.deleteSync();
    }
    if(inputPath.existsSync()) {
      inputPath.deleteSync();
    }
    if(examplePath.existsSync()) {
      examplePath.deleteSync();
    }
  }

}

void main() {
  String homePath = get_aoc_path();
  print('Home Directory: $homePath');
}