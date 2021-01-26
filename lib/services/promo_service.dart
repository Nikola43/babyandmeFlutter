import 'dart:async';
import 'dart:convert';

import 'package:babyandme/models/calculator.dart';
import 'package:babyandme/models/promo.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:babyandme/utils/shared_preferences.dart';

class PromoService {
  final apiUrl = "https://api.babyandme.stelast.com/api/user_promo/2/";

  Future<List<Promo>> getPromosByWeek() async {
    var token = await SharedPreferencesUtil.getString('token');
    var week = await SharedPreferencesUtil.getInt('week');
    List<Promo> promos = [];
    try {
      final response = await HttpRequestUtil.makeSecureGetRequest(
          apiUrl + week.toString(), token);
      print(response);
      for (int i = 0; i < response.length; i++) {
        final promo = Promo.fromJsonMap(response[i]);
        promos.add(promo);
      }
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }

    return promos;
  }
}
