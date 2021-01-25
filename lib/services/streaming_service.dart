import 'dart:async';
import 'dart:convert';
import 'package:babyandme/models/streaming.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:babyandme/utils/shared_preferences.dart';

class StreamingService {
  final apiUrl = "https://api.babyandme.stelast.com/api/streaming";

  Future<Streaming> getStreamingByCode(String code) async {
    var token = await SharedPreferencesUtil.getString('token');
    Streaming streaming = Streaming(code: code);

    try {
      final response = await HttpRequestUtil.makeSecurePostRequest(apiUrl,jsonEncode(streaming), token);
      streaming = Streaming.fromJsonMap(response);
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }

    return streaming;
  }
}

