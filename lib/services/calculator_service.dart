import 'dart:async';
import 'dart:convert';

import 'package:babyandme/models/calculator.dart';
import 'package:babyandme/utils/http_request.dart';

class CalculatorService {
  final apiUrl = "https://api.babyandme.stelast.com/api/calculator/week";

  Future<Calculator> calculatorByWeek(int id, int user_id) async {
    final Calculator week = Calculator(id: id, userId: user_id);
    Calculator week2;

    try {
      final response =
          await HttpRequestUtil.makePostRequest(apiUrl, jsonEncode(week));
      week2 = Calculator.fromJsonMap(response);
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }

    return week2;
  }
}
