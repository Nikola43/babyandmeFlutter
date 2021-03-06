import 'dart:async';
import 'dart:convert';

import 'package:babyandme/models/calculator.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:babyandme/utils/shared_preferences.dart';

class CalculatorService {
  final apiUrl = "https://api.babyandme.stelast.com/api/calculator/week";

  Future<Calculator> calculatorByWeek(int id) async {
    var userId = await SharedPreferencesUtil.getInt('user_id');

    final Calculator week = Calculator(id: id, userId: userId);
    Calculator week2;
    print(week.id);

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

