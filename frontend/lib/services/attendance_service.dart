import 'dart:convert';

import 'package:checkapp/models/models.dart';
import 'package:checkapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../helpers/date_time_conversor.dart';

class AttendanceService extends ChangeNotifier {
  final String _eventTypeCheckIn = 'CHECK_IN';

  String entrada = 'PENDIENTE';
  String salida = 'PENDIENTE';
  final storage = const FlutterSecureStorage();

  final String _baseUrl = 'api.asiendosoftware.xyz';
  final String _baseAPI = '/api/v1/';

  Future<Map<String, dynamic>> getLastAttendance() async {
    final _cookie = await storage.read(key: 'mysession');
    Map<String, String> headers = {'Cookie': 'mysession=$_cookie'};
    print(headers);
    final url = Uri.https(_baseUrl, '${_baseAPI}private/attendance/last');
    print(url);
    final respuesta = await http.get(url, headers: headers);
    print('Respuesta:  $respuesta');
    print('haciendo el get de lastAttendance...');
    final Map<String, dynamic> decodeResp = json.decode(respuesta.body);
    return decodeResp;
  }

  Future<void> updateCurrentStatus() async {
    final lastAttendance = await getLastAttendance();
    if (lastAttendance['event_type'] == _eventTypeCheckIn) {
      final outputDate = apiFomrmatToTime(lastAttendance['event_time']);
      entrada = outputDate;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> postNewAttendance(
      CompanyModel company, UserModel user, String eventType) async {
    final Map<String, dynamic> attendanceData = {
      'comments': 'PENDING',
      'company_id': company.id,
      'device_secret_key': "PENDING",
      'event_type': eventType,
      'location': user.location,
      'user_id': user.id,
    };
    final url = Uri.https(_baseUrl, '${_baseAPI}private/attendance');
    print(url);
    final respuesta = await http.post(url, body: attendanceData);
    print('Respuesta:  $respuesta');
    print('haciendo el post de la atención...');
    final Map<String, dynamic> decodeResp = json.decode(respuesta.body);

    return decodeResp;
  }
}
