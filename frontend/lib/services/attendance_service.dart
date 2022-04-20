import 'dart:convert';

import 'package:checkapp/models/models.dart';
import 'package:checkapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../helpers/date_time_helper.dart';

class AttendanceService extends ChangeNotifier {
  final String _eventTypeCheckIn = 'CHECK_IN';
  final String _eventTypeCheckOut = 'CHECK_OUT';

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
    print('Respuesta:  ${respuesta.body}');
    final Map<String, dynamic> decodeResp = json.decode(respuesta.body);
    return decodeResp;
  }

  Future<void> updateCurrentStatus() async {
    final lastAttendance = await getLastAttendance();
    if (lastAttendance['event_type'] == _eventTypeCheckIn) {
      final outputDate = apiFomrmatToTime(lastAttendance['event_time']);
      entrada = outputDate;
    } else if (lastAttendance['event_type'] == _eventTypeCheckOut) {
      final outputDate = apiFomrmatToTime(lastAttendance['event_time']);
      salida = outputDate;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> postNewAttendance(
      int companyid, String eventType, String userlocation) async {
    final _cookie = await storage.read(key: 'mysession');
    Map<String, String> headers = {'Cookie': 'mysession=$_cookie'};

    final Map<String, dynamic> attendanceData = {
      //'comments': 'PENDING',
      'user_id': 2.toString(),
      'company_id': companyid.toString(),
      'device_secret_key': "PENDING",
      'event_type': eventType,
      'location': userlocation,
      //'user_id': user.id,
    };
    final url = Uri.https(_baseUrl, '${_baseAPI}private/attendance');
    print(url);
    final respuesta =
        await http.post(url, body: attendanceData, headers: headers);
    print('Respuesta del postAttendance:  ${respuesta.body}');
    final Map<String, dynamic> decodeResp = json.decode(respuesta.body);

    return decodeResp;
  }
}
