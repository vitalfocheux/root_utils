import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:colorize/colorize.dart';
import 'localstorage.dart';
import 'plumbing.dart';

class AOCD {
  static const String baseUrl = 'https://adventofcode.com';

  final int year;
  final int day;
  late String cookie;
  late Cache cache;
  late String raw;
  bool isExample = false;

  AOCD._(this.year, this.day, this.cookie, this.cache, this.raw, this.isExample);

  static Future<AOCD> create(int year, int day, {bool delete_cache = false, bool delete_cookie = false, bool is_example = false}) async {
    String cookie = Cookie(delete_cookie: delete_cookie).toString();
    Cache cache = Cache(year, day, delete_cache: delete_cache);
    String raw = await getRaw(cookie, cache, year, day);
    return AOCD._(year, day, cookie, cache, raw, is_example);
  }

  // AOCD(this.year, this.day, {bool deleteCache = false, bool deleteCookie = false}) {
  //   cookie = Cookie(delete_cookie: deleteCookie).toString();
  //   cache = Cache(year, day, delete_cache: deleteCache);
  //   raw = getRaw();
  //   // colorize.autoReset = true;
  // }

  void setExample(String rawExample, {bool store = false}) {
    if (!rawExample.endsWith('\n')) {
      rawExample += '\n';
    }
    raw = rawExample;
    isExample = true;
    if (store) {
      cache.example = rawExample;
    }
    var colorized_text = Colorize('Using Example:\n\n')..red();
    // print(colorized_text + rawExample);
    print(colorized_text.toString() + rawExample);
  }

  void getExample() async {
    String? example = cache.example;
    if (example == null) {
      final puzzlePage = await http.get(Uri.parse(puzzleUrl), headers: {'Cookie': 'session=$cookie'});
      example = parseExampleFromWebsite(puzzlePage.body);
      if (example == null) {
        print('ERROR parsing example');
        return;
      }
    }
    setExample(example, store: true);
  }

  static Future<String> getRaw(String cookie, Cache cache, int year, int day) async {
    String? raw = cache.input;
    if (raw == null) {
      raw = await download(cookie, year, day);
      if (raw.contains('<title>500 Internal Server Error</title>')) {
        throw ArgumentError('Invalid Input - Wrong Cookie?');
      }
      if (raw.contains("Please don't repeatedly request this endpoint")) {
        throw ArgumentError('Invalid Input - Please try again later');
      }
      if (raw.contains('Please log in to get your puzzle input.')) {
        print('Cookie invalid or expired - try again after re-setting cookie');
        cookie = Cookie(delete_cookie: true).toString();
        exit(1);
      }
      cache.input = raw;
    }
    return raw;
  }

  static Future<String> download(String cookie, int year, int day) async {
    final response = await http.get(Uri.parse('$baseUrl/$year/day/$day/input'), headers: {'Cookie': 'session=$cookie'});
    return response.body;
  }

  void open() {
    Process.run('start', [puzzleUrl], runInShell: true);
  }

  int get length => slist.length;

  String get puzzleUrl => '$baseUrl/$year/day/$day';

  String get inputUrl => '$puzzleUrl/input';

  String get answerUrl => '$puzzleUrl/answer';

  String get asStr => raw.trimRight();

  int get asInt => int.parse(asStr);

  // List Parsing
  List<String> get slist => asStr.split('\n');

  List<int> get ilist => slist.map(int.parse).toList();

  List<String> slistSplitAt(String sep) => asStr.split(sep);

  List<int> ilistSplitAt(String sep) => slistSplitAt(sep).map(int.parse).toList();

  // Set Parsing
  Set<String> get sset {
    final ret = slist.toSet();
    if (ret.length < length) {
      print(Colorize('WARNING - Set is smaller than list because of duplicate entries')..yellow());
    }
    return ret;
  }

  Set<int> get iset {
    final ret = ilist.toSet();
    if (ret.length < length) {
      print(Colorize('WARNING - Set is smaller than list because of duplicate entries')..yellow());
    }
    return ret;
  }

  Set<String> ssetSplitAt(String sep) {
    final ret = slistSplitAt(sep).toSet();
    if (ret.length < length) {
      print(Colorize('WARNING - Set is smaller than list because of duplicate entries')..yellow());
    }
    return ret;
  }

  Set<int> isetSplitAt(String sep) {
    final ret = ilistSplitAt(sep).toSet();
    if (ret.length < length) {
      print(Colorize('WARNING - Set is smaller than list because of duplicate entries')..yellow());
    }
    return ret;
  }

  // Grid Parsing
  Map<Point, String> get sgrid => _parseAsGrid<String>(sep: null, t: (e) => e);

  Map<Point, int> get igrid => _parseAsGrid<int>(sep: null, t: int.parse);

  Map<Point, String> sgridSplitAt(String sep) => _parseAsGrid<String>(sep: sep, t: (e) => e);

  Map<Point, int> igridSplitAt(String sep) => _parseAsGrid<int>(sep: sep, t: int.parse);

  // Map<Point, T> mgrid<T>(Map<String, T> mapping) => _parseAsGrid<T>(sep: null, mapping: mapping);

  Map<Point, T> mgrid<T>(Map<String, T> mapping) => _parseAsGrid<T>(t: (e) => mapping[e]!);

  // Map<Point, T> mgridSplitAt<T>(Map<String, T> mapping, String sep) => _parseAsGrid<T>(sep: sep, mapping: mapping);

  Map<Point, T> mgridSplitAt<T>(Map<String, T> mapping, String sep) => _parseAsGrid<T>(sep: sep, t: (e) => mapping[e]!);

  Map<Point, T> _parseAsGrid<T>({String? sep, required T Function(String) t, Map<String, T>? mapping}) {
    final grid = <Point, T>{};
    for (var y = 0; y < slist.length; y++) {
      var line = slist[y];
      if (sep != null) {
        line = line.split(sep).join();
      }
      for (var x = 0; x < line.length; x++) {
        final element = line[x];
        grid[Point(x, y)] = mapping != null ? mapping[element]! : t(element);
      }
    }
    return grid;
  }

  int get gridWidth => slist[0].length;

  int get gridHeight => slist.length;

  Point get gridDimensions => Point(gridWidth, gridHeight);

  // Key-Value Parsing
  Map<K, V> dictSplitAt<K, V>(String sep, {K Function(String)? keyType, V Function(String)? valueType}) =>
      keyValueSplitAt<K, V>(sep, keyType: keyType, valueType: valueType);

  Map<K, V> keyValueSplitAt<K, V>(String sep, {K Function(String)? keyType, V Function(String)? valueType}) =>
      _parseAsKeyValue<K, V>(sep, keyType: keyType, valueType: valueType);

  Map<K, V> _parseAsKeyValue<K, V>(String sep, {K Function(String)? keyType, V Function(String)? valueType}) {
    final d = <K, V>{};
    for (var line in slist) {
      final parts = line.split(sep);
      final k = keyType != null ? keyType(parts[0]) : parts[0] as K;
      final v = valueType != null ? valueType(parts[1]) : parts[1] as V;
      d[k] = v;
    }
    return d;
  }

  // Literal Parsing
  dynamic get literal => jsonDecode(asStr);

  List<dynamic> get literalList => slist.map(jsonDecode).toList();

  // Submitting answer
  void _submit(int part, dynamic answer) async {
    final answerStr = answer.toString();

    if (isExample) {
      print(Colorize('$year-$day P$part with EXAMPLE INPUT: $answerStr')..cyan());
      return;
    } else {
      print(Colorize('SUBMITTING ANSWER for $year-$day Part $part: $answerStr')..cyan());
    }

    final sol = cache.solution(part);
    if (sol != null) {
      print(Colorize('SOLUTION CACHED')..yellow());
      print('Your answer is ${answerStr == sol ? Colorize('correct').green() : Colorize('incorrect ($sol)').red()}');
      return;
    }

    // submitAnswer(answerUrl, baseUrl, puzzleUrl, cookie, part, answerStr);
    submitAnswer2(cookie, part, answerStr);

    // if (cache.answers(part).contains(answerStr)) {
    //   print(Colorize('WRONG ANSWER SKIPPED: Already submitted earlier')..yellow());
    //   return;
    // }

    // final response = await http.post(
    //   Uri.parse(answerUrl),
    //   headers: {
    //     'Content-Type': 'application/x-www-form-urlencoded',
    //     'origin': baseUrl,
    //     'referer': puzzleUrl,
    //     'Cookie': 'session=$cookie',
    //   },
    //   body: {'level': part.toString(), 'answer': answerStr},
    //   // cookies: {'session': cookie},
    // );

    // print(response.statusCode);
    // print('answerUrl: $answerUrl\norigin: $baseUrl\nreferer: $puzzleUrl\ncookie: $cookie\nlevel: $part\nanswer: $answerStr\nresponse: ${response.body}');

    // final parsedResult = parseResultWebsite(response.body);
    // print(parsedResult ?? response.body);
    // if (parsedResult == null) {
    //   print(Colorize('Invalid parsing result')..red());
    //   return;
    // } else if (parsedResult == 'ALREADY SOLVED') {
    //   print('Collecting correct answer from website');
    //   final puzzlePage = await http.get(Uri.parse(puzzleUrl), headers: {'Cookie': 'session=$cookie'});
    //   final sol = parseSolutionFromWebsite(puzzlePage.body, part);
    //   if (sol == null) {
    //     print(Colorize('Cannot read Solution from puzzle page')..red());
    //     return;
    //   }
    //   cache.add_answer(part, sol, is_solution: true);
    //   print('Your answer is ${answerStr == sol ? Colorize('correct').green() : Colorize('incorrect ($sol)').red()}');
    // } else if (parsedResult.startsWith('SUCCESS')) {
    //   cache.add_answer(part, answerStr, is_solution: true);
    // } else if (!parsedResult.startsWith('ERROR:')) {
    //   cache.add_answer(part, answerStr);
    // }
  }

  Future<void> submitAnswer(String answerUrl, String baseUrl, String puzzleUrl, String cookie, int part, String answerStr) async {
    if (cache.answers(part).contains(answerStr)) {
      print(Colorize('WRONG ANSWER SKIPPED: Already submitted earlier')..yellow());
      return;
    }

    final response = await http.post(
      Uri.parse(answerUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'origin': baseUrl,
        'referer': puzzleUrl,
        'Cookie': 'session=$cookie',
      },
      body: {'level': part.toString(), 'answer': answerStr},
    );

    print('Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 302) {
      final redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        final absoluteRedirectUrl = Uri.parse(baseUrl).resolveUri(Uri.parse(redirectUrl)).toString();
        final redirectResponse = await http.get(
          Uri.parse(absoluteRedirectUrl),
          headers: {
            'Cookie': 'session=$cookie',
          },
        );
        // print('Redirect Status Code: ${redirectResponse.statusCode}');
        // print('Redirect Response Body: ${redirectResponse.body}');
        final parsedResult = parseResultWebsite(redirectResponse.body);
        print(parsedResult ?? redirectResponse.body);
        print('parsedResult: $parsedResult');
        if (parsedResult == null) {
          print(Colorize('Invalid parsing result')..red());
          return;
        } else if (parsedResult == 'ALREADY SOLVED') {
          print('Collecting correct answer from website');
          final puzzlePage = await http.get(Uri.parse(puzzleUrl), headers: {'Cookie': 'session=$cookie'});
          final sol = parseSolutionFromWebsite(puzzlePage.body, part);
          if (sol == null) {
            print(Colorize('Cannot read Solution from puzzle page')..red());
            return;
          }
          cache.add_answer(part, sol, is_solution: true);
          print('Your answer is ${answerStr == sol ? Colorize('correct').green() : Colorize('incorrect ($sol)').red()}');
        } else if (parsedResult.startsWith('SUCCESS')) {
          cache.add_answer(part, answerStr, is_solution: true);
        }
      } else {
        print('No location header found for redirection.');
      }
    } else {
      final parsedResult = parseResultWebsite(response.body);
      print(parsedResult ?? response.body);
      if (parsedResult == null) {
        print(Colorize('Invalid parsing result')..red());
        return;
      } else if (parsedResult == 'ALREADY SOLVED') {
        print('Collecting correct answer from website');
        final puzzlePage = await http.get(Uri.parse(puzzleUrl), headers: {'Cookie': 'session=$cookie'});
        final sol = parseSolutionFromWebsite(puzzlePage.body, part);
        if (sol == null) {
          print(Colorize('Cannot read Solution from puzzle page')..red());
          return;
        }
        cache.add_answer(part, sol, is_solution: true);
        print('Your answer is ${answerStr == sol ? Colorize('correct').green() : Colorize('incorrect ($sol)').red()}');
      } else if (parsedResult.startsWith('SUCCESS')) {
        cache.add_answer(part, answerStr, is_solution: true);
      }
    }
  }


  Future<void> submitAnswer2(String sessionCookie, int part, String answer) async {
  // URL de l'Advent of Code pour soumettre une réponse
  var url = Uri.parse('https://adventofcode.com/${this.year}/day/${this.day}/answer');

  // Headers nécessaires pour l'envoi, notamment le cookie de session
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Cookie': 'session=$sessionCookie',
  };

  // Corps de la requête, avec la réponse à soumettre
  var body = 'level=$part&answer=$answer';

  try {
    // Envoi de la requête POST
    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Vérification du statut de la réponse
    if (response.statusCode == 200) {
      print('Réponse soumise avec succès.');
      print('Contenu de la réponse: ${response.body}');
    } else {
      print('Erreur lors de la soumission. Code de statut: ${response.statusCode}');
      print('Contenu de la réponse: ${response.body}');
    }
  } catch (e) {
    print('Erreur : $e');
  }
}

  void p1(dynamic answer) {
    _submit(1, answer);
  }

  void p2(dynamic answer) {
    _submit(2, answer);
  }
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}