import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:babyandme/models/NullString.dart';
import 'package:babyandme/models/login.dart';
import 'package:babyandme/models/user.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:universal_io/io.dart';



class LoginService {
  final apiUrl = "https://api.babyandme.stelast.com/api/user/login";

  Future<User> login(String username, String password) async {
    User user;
    Login login = Login(
        username: username,
        password: password,
        firebaseToken: NullString(string: " ", valid: true),
        deviceType: NullString(string: " ", valid: true));

    //Platform.operatingSystem

    //login.deviceType.string = Platform.isIOS ? "ios" : "android";
    login.deviceType.string = "android";

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
