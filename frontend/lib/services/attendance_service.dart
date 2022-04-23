import 'dart:convert';
import 'dart:ui';
import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../helpers/date_time_helper.dart';

class AttendanceService extends ChangeNotifier {
  final String _eventTypeCheckIn = 'CHECK_IN';
  final String _eventTypeCheckOut = 'CHECK_OUT';

  String entrada = 'PENDIENTE';
  String salida = 'PENDIENTE';
  String horaEsperada = 'PENDIENTE';
  String status = 'Calculando...';
  Color statusColor = AppTheme.textPending;
  Color checkInColor = AppTheme.textPending;
  Color checkOutColor = AppTheme.textPending;
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

  Future<List<dynamic>> getTodayAttendance() async {
    final _cookie = await storage.read(key: 'mysession');
    Map<String, String> headers = {'Cookie': 'mysession=$_cookie'};
    print(headers);
    final url = Uri.https(_baseUrl, '${_baseAPI}private/attendance/today');
    print(url);
    final respuesta = await http.get(url, headers: headers);
    print('Respuesta today attendance:  ${respuesta.body}');
    final List<dynamic> decodeResp = json.decode(respuesta.body);
    return decodeResp;
  }

  Future<void> updateCurrentStatus() async {
    final lastAttendance = await getTodayAttendance();
    print(lastAttendance);
    for (var attendance in lastAttendance) {
      if (attendance['event_type'] == _eventTypeCheckIn) {
        if (attendance['pending'] == false) {
          entrada = formatTime(attendance['event_time']);
          _setColorByStatus('TARDE', attendance['event_type']);
        }
      }
      if (attendance['event_type'] == _eventTypeCheckOut) {
        if (attendance['pending'] == false) {
          salida = formatTime(attendance['event_time']);
          checkInColor = _setColorByStatus('ANTES', attendance['event_type']);
        }
      }
    }
    notifyListeners();
  }

  Future<void> postNewAttendance(
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
    updateStatusAttendance(decodeResp);
  }

  updateStatusAttendance(Map<String, dynamic> answer) {
    //Checkin
    if (answer['attendance']['event_type'] == _eventTypeCheckIn) {
      entrada = formatTime(answer['attendance']['event_time']);
    }
    //Checkout
    else if (answer['attendance']['event_type'] == _eventTypeCheckOut) {
      salida = formatTime(answer['attendance']['event_time']);
    }
    //Error
    else {
      print('NO SABO QUE PASÓ');
    }
    notifyListeners();
  }

  Future<String> setFuturePostInfo(String todo) async {
    List<dynamic> info = await getTodayAttendance();
    final String now = getCurrentTime();
    for (var attendance in info) {
      if (attendance['event_type'] == todo && attendance['pending'] == true) {
        print('Encontré la info buscada -> $attendance');
        horaEsperada = attendance['expected_time'];
        status = _setStatus(now, horaEsperada, attendance['event_type']);
        notifyListeners();
        return 'DONE';
      }
    }
    return 'ERROR!';
  }

  String _setStatus(String now, String esperado, String eventType) {
    int margin = 20;
    DateTime nowDate = DateFormat("hh:mm:ss").parse(now);
    DateTime esperadoDate = DateFormat("hh:mm:ss").parse(esperado);

    Duration dif = nowDate.difference(esperadoDate);
    Color newColor;
    int difMinutes = dif.inMinutes.toInt();
    if ((difMinutes > 0 && (difMinutes).abs() > margin)) {
      status = 'TARDE';
      newColor = Colors.red;
      statusColor = Colors.red;
    } else if (difMinutes < 0 && (difMinutes).abs() > margin) {
      status = 'ANTES';
      newColor = Colors.yellow;
      statusColor = Colors.yellow;
    } else if ((difMinutes > 0 && (difMinutes).abs() < margin) ||
        (difMinutes < 0 && (difMinutes).abs() < margin)) {
      status = 'A tiempo';
      newColor = Colors.green;
      statusColor = Colors.green;
    } else {
      newColor = AppTheme.textPrimColor;
    }
    if (eventType == _eventTypeCheckIn) {
      checkInColor = newColor;
    }

    return status;
  }

  _setColorByStatus(String status, String eventType) {
    if (eventType == _eventTypeCheckIn) {
      if (status == 'TARDE') {
        checkInColor = Colors.red;
      } else if (status == 'A tiempo') {
        checkInColor = Colors.green;
      } else if (status == 'ANTES') {
        checkInColor = Colors.yellow;
      }
    } else if (eventType == _eventTypeCheckOut) {
      if (status == 'TARDE') {
        checkOutColor = Colors.red;
      } else if (status == 'A tiempo') {
        checkOutColor = Colors.green;
      } else if (status == 'ANTES') {
        checkOutColor = Colors.yellow;
      }
    }
  }
}
