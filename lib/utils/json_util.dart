import 'dart:convert';
import 'package:flutter/services.dart';

class JsonUtil {
  static Future<String> loadFromAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  static readJsonString(String path) async {
    String data = await rootBundle.loadString(path);
    return data;
  }

  static Future<List<String>> readJson(String path) async {
    List<String> p = [];
    var data = await readJsonString(path);
    data = json.decode(data);
    print(data);

    var plength = (data as Map<String, dynamic>).length;
    print(plength);

    for (int i = 0; i < plength; i++) {
      p.add(data["p" + i.toString()]);
    }
    return p;
  }
}
