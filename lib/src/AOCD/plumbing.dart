import 'dart:core';

String? parseResultWebsite(String raw) {
  if (!raw.startsWith('<!DOCTYPE html>')) {
    return 'ERROR: No HTML Received';
  }
  final reMain = RegExp(r'<main>\n<article><p>(.*)</p></article>\n</main>', dotAll: true);
  // final reMain = RegExp(r'<main>([\s\S]*?)</main>', dotAll: true);
  print("raw: $raw");
  print("reMain: $reMain");
  final mainPart = reMain.firstMatch(raw);

  if (mainPart == null) {
    print('No match found');
    return 'ERROR: No main part in website';
  }else{
    print('mainPart: ${mainPart.group(0)}');
  }

  final mainText = mainPart.group(1)!;

  if (mainText.startsWith("That's the right answer")) {
    return 'SUCCESS - Answer accepted';
  }

  if (mainText.startsWith('You gave an answer too recently')) {
    final time = RegExp(r'(?:(\d+)m )?(?:(\d+)s)').firstMatch(mainText);
    final minutes = time?.group(1) ?? '0';
    final seconds = time?.group(2) ?? '0';
    return 'ERROR: Cooldown ${minutes}m ${seconds}s';
  }

  if (mainText.startsWith("That's not the right answer")) {
    final reason = RegExp(r'your answer is too (\w*)').firstMatch(mainText);
    return 'WRONG ANSWER:${reason != null ? ' - Too ${reason.group(1)}' : ''}';
  }

  if (mainText.startsWith("You don't seem to be solving the right level")) {
    return 'ALREADY SOLVED';
  }

  return null;
}

String? parseSolutionFromWebsite(String raw, int part) {
  if (!raw.startsWith('<!DOCTYPE html>')) {
    print('No HTML Received');
    return null;
  }

  final reAnswer = RegExp(r'<p>Your puzzle answer was <code>(.*?)</code>.</p>');
  final answers = reAnswer.allMatches(raw).map((match) => match.group(1)!).toList();

  if (answers.length < part) {
    print('Unable to find solution for part $part on Website');
    return null;
  }

  return answers[part - 1];
}

String? parseExampleFromWebsite(String raw) {
  if (!raw.startsWith('<!DOCTYPE html>')) {
    print('No HTML Received');
    return null;
  }

  final reExample = RegExp(r'[eE]xample:</p>\n<pre><code>(.*?)</code></pre>', dotAll: true);
  final example = reExample.allMatches(raw).map((match) => match.group(1)!).toList();

  if (example.length > 1) {
    print('ERROR: Multiple Examples found');
    return null;
  }

  return example.isNotEmpty ? example[0] : null;
}