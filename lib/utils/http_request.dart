import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

class HttpRequestUtil {
  static makePostRequest(String url, String json) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.acceptCharsetHeader: "UTF-8",
    };

    /*
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json; charset=UTF-8",
    };
    */
    Response response = await post(url, headers: headers, body: json);
    // int statusCode = response.statusCode;
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }

  static makeSecurePostRequest(String url, String json, String token) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.acceptCharsetHeader: "UTF-8",
    };

    /*
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json; charset=UTF-8",
    };
    */
    Response response = await post(url, headers: headers, body: json);
    // int statusCode = response.statusCode;
    Map<String, dynamic> map = jsonDecode(response.body);
    return map;
  }

  static makeSecureGetRequest(String url, String token) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    Response response = await get(url, headers: headers);
    Map<String, dynamic> map = jsonDecode(response.body);
    print("resp");
    print(response.body);
    // int statusCode = response.statusCode;
    return map;
  }
}
