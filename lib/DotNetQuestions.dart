import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class Dotnetquestions {
  static String ques = '';
  static int previous_question_number = 0;
  static Map<String, String> questionAndAnswer = Map<String, String>();
  Dotnetquestions() {
    _init();
  }
  Future _init() async {
    String path = 'assets/Questions.txt';
    String content = await getFileData(path);
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(content);
    lines.forEach((l) => addToMap(l));
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void addToMap(String line) {
    int currentquestion_number = 0;
    if (_isQuestion(line)) {
      currentquestion_number = int.parse(line.split('.')[0]);
      if (previous_question_number + 1 != currentquestion_number) {
        questionAndAnswer[ques] = questionAndAnswer[ques].toString() + line;
        return;
      }
      ques = line.replaceAll(line.split('.')[0] + '.', '');
      questionAndAnswer[ques] = '';
      previous_question_number = int.parse(line.split('.')[0]);
    } else {
      questionAndAnswer[ques] = questionAndAnswer[ques].toString() + line;
    }
  }

  Map<dynamic, String?> getQuestionAnswers(String searchKeyword) {
    String result = '';
    final filteredMap = new Map.fromIterable(
        questionAndAnswer.keys
            .where((k) => k.toUpperCase().contains(searchKeyword)),
        key: (k) => k,
        value: (k) => questionAndAnswer[k]);
    //filteredMap.forEach((k, v) => result = ('key: $k, value: $v'));
    return filteredMap;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s) != null;
  }

  bool _isQuestion(String line) {
    try {
      if (line.contains('.') && isNumeric(line.split('.')[0])) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
