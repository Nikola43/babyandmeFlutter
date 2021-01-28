import 'dart:async';
import 'dart:convert';

import 'package:babyandme/models/calculator.dart';
import 'package:babyandme/models/heartbeat.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:babyandme/utils/shared_preferences.dart';

class HeartbeatService {
  final apiUrl = "https://api.babyandme.stelast.com/api/heartbeat/";

  Future<Heartbeat> getHeartbeat() async {
    int userId = await SharedPreferencesUtil.getInt('user_id');
    String token = await SharedPreferencesUtil.getString('token');
    Heartbeat heartbeat;

    try {
      final response = await HttpRequestUtil.makeSecureGetRequest(
          apiUrl + userId.toString(), token);
      heartbeat = Heartbeat.fromJsonMap(response);
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }

    return heartbeat;
  }
}
