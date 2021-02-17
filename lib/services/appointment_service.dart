import 'dart:async';
import 'dart:convert';

import 'package:babyandme/models/appointment.dart';
import 'package:babyandme/models/calculator.dart';
import 'package:babyandme/models/promo.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:babyandme/utils/shared_preferences.dart';

class AppointmentService {
  final apiUrl = "https://api.babyandme.stelast.com/api/appointment/new";

  Future<bool> sendNewAppointment(
      String name, String email, String phone, String promo_name) async {
    Appointment appointment = Appointment(
        name: name, email: email, phone: phone, promo_name: promo_name);

    try {
      final response = await HttpRequestUtil.makePostRequest(
          apiUrl, jsonEncode(appointment));

      print(response);
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }
    return true;
  }
}
