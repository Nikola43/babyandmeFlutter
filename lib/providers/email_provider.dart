import 'dart:async';
import 'package:babyandme/models/api_error.dart';
import 'package:babyandme/models/email.dart';
import 'package:dio/dio.dart';


class EmailProvider {
  var dio = Dio();

  Future<Email> getNames(String query) async {
    Email email = Email();
    ApiError apiError = ApiError();
    final params = {
      "email": query,
    };
    final response = await dio.post('http://213.32.70.214:2019/post/dir',
        queryParameters: params);
    try {
      email = Email.fromJsonMap(response.data);
      apiError = ApiError.fromJsonMap(response.data);
      print(apiError.status);
      print(apiError.reason);
    } on NoSuchMethodError catch (e) {
      ApiError apiError = ApiError.fromJsonMap(response.data);
      print(apiError);
      print('error caught: $e');
    }
    return email;
  }
}
