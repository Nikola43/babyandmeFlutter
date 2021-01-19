import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

class HttpRequestUtil {
  static makePostRequest(String url, String json) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url, headers: headers, body: json);
    // int statusCode = response.statusCode;
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }

  static makeSecureGetRequest(String url, String token) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    Response response = await get(url, headers: headers);
    List<dynamic> map = jsonDecode(response.body);
    print("resp");
    print(response.body);
    // int statusCode = response.statusCode;
    return map;
  }
}
