import 'dart:async';
import 'dart:convert';
import 'package:babyandme/models/success.dart';
import 'package:babyandme/utils/http_request.dart';

class RecoveryEmail {
  String username;

  RecoveryEmail({
    this.username
  });

  RecoveryEmail.fromJsonMap(Map<String, dynamic> json) {
    username = json['username'];
  }

  Map<String, dynamic> toJson() => {
    'username': username,
  };
}


class RecoveryPasswordService {
  final apiUrl = "https://api.babyandme.stelast.es/api/user/recovery";

  Future<Success> recoveryPassword(String username) async {
    Success ok;

    RecoveryEmail recoveryEmail = new RecoveryEmail(username: username);

    try {
      final response =
      await HttpRequestUtil.makePostRequest(apiUrl, jsonEncode(recoveryEmail));
      ok = Success.fromJsonMap(response);
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }

    return ok;
  }
}
