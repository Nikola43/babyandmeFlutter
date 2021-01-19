import 'dart:async';
import 'dart:convert';

import 'package:babyandme/models/calculator.dart';
import 'package:babyandme/utils/http_request.dart';

class CalculatorService {
  final apiUrl = "https://ecodadys.app/api/api/calculator/week";

  Future<Calculator> calculatorByWeek(int id, int user_id) async {
    final Calculator week = Calculator(id: 16, userId: 3);
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
