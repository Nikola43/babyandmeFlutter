import 'dart:async';
import 'dart:convert';

import 'package:babyandme/models/NullString.dart';
import 'package:babyandme/models/login.dart';
import 'package:babyandme/models/user.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:universal_io/io.dart';



class LoginService {
  final apiUrl = "https://api.babyandme.stelast.com/api/user/login";

  Future<User> login(String username, String password) async {
    User user;
    String playerId = await SharedPreferencesUtil.getString("one_signal_token");

    if (playerId == null) {
      playerId = " ";
    }

    print(playerId);
    print(Platform.operatingSystem);
    Login login = Login(
        username: username,
        password: password,
        firebaseToken: NullString(string: playerId, valid: true),
        deviceType: NullString(string: Platform.operatingSystem, valid: true));

    try {
      final response =
          await HttpRequestUtil.makePostRequest(apiUrl, jsonEncode(login));
      user = User.fromJsonMap(response);
      print(response);
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }
    return user;
  }
}
