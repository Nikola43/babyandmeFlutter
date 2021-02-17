import 'dart:async';
import 'dart:convert';
import 'package:babyandme/models/NullInt64.dart';
import 'package:babyandme/models/NullString.dart';
import 'package:babyandme/models/signup.dart';
import 'package:babyandme/models/user.dart';
import 'package:babyandme/utils/http_request.dart';

class SignUpService {
  final apiUrl = "https://api.babyandme.stelast.com/api/user/new";

  Future<bool> signUp(String username, String password) async {
    SignUp signUp = SignUp(
        clinic_id: new NullInt64(int64: 10, valid: true),
        username: username,
        password: password,
        name: new NullString(string: " ", valid: true),
        lastname: new NullString(string: " ", valid: true),
        phone: new NullString(string: " ", valid: true),
        rol: "Cliente",
        week: 1,
        available: 1,
    );
    print(jsonEncode(signUp));

    try {
      final response = await HttpRequestUtil.makePostRequest(apiUrl, jsonEncode(signUp));
      print(response["message"]);
      if (response["message"] == "Username already in use by another user.") {
        return false;
      }

      if (response["message"] == "success") {
        print("success");
        return true;
      }

    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }

    return false;
  }
}
