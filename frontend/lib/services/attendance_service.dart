import 'dart:convert';
import 'package:checkapp/models/wokers_model.dart';
import 'package:checkapp/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../helpers/date_time_helper.dart';

class AttendanceService extends ChangeNotifier {
  final String _eventTypeCheckIn = 'CHECK_IN';
  final String _eventTypeCheckOut = 'CHECK_OUT';

  String entrada = 'PENDIENTE';
  String salida = 'PENDIENTE';
  String horaEsperada = 'PENDIENTE';
  String entradaEsperada = 'PENDIENTE';
  String salidaEsperada = 'PENDIENTE';
  String status = 'Calculando...';
  Color statusColor = AppTheme.textPending;
  Color checkInColor = AppTheme.textPending;
  Color checkOutColor = AppTheme.textPending;
  final storage = const FlutterSecureStorage();
  bool freeDay = false;

  final String _baseUrl = 'api.asiendosoftware.xyz';
  final String _baseAPI = '/api/v1/';

  Future<Map<String, dynamic>> getLastAttendance() async {
    final _cookie = await storage.read(key: 'mysession');
    Map<String, String> headers = {'Cookie': 'mysession=$_cookie'};
    final url = Uri.https(_baseUrl, '${_baseAPI}private/attendance/last');
    print(url);
    final respuesta = await http.get(url, headers: headers);
    final Map<String, dynamic> decodeResp = json.decode(respuesta.body);
    return decodeResp;
  }

  Future<List<dynamic>> getTodayAttendance() async {
    final _cookie = await storage.read(key: 'mysession');
    Map<String, String> headers = {'Cookie': 'mysession=$_cookie'};
    final url = Uri.https(_baseUrl, '${_baseAPI}private/attendance/today');
    print(url);
    final respuesta = await http.get(url, headers: headers);
    if (respuesta.statusCode == 200) {
      print('Respuesta today attendance:  ${respuesta.body}');
      final decodeResp = json.decode(respuesta.body);
      return decodeResp;
    } else {
      return [];
    }
  }

  Future<String> getProfileById() async {
    final _cookie = await storage.read(key: 'mysession');
    final String? userInfo = await storage.read(key: 'userInfo');
    if (userInfo != null) {
      Map<String, dynamic> userInfoDecode = json.decode(userInfo);
      final int userId = userInfoDecode['id'];
      Map<String, String> headers = {'Cookie': 'mysession=$_cookie'};
      final url = Uri.https(_baseUrl, '${_baseAPI}private/users/image/$userId');
      print(url);
      final respuesta = await http.get(url, headers: headers);
      final decodeResp = json.decode(respuesta.body);
      print(decodeResp);
    }
    return 'a';
    //return decodeResp;
  }

  Future<void> updateCurrentStatus() async {
    final lastAttendance = await getTodayAttendance();
    if (lastAttendance.isEmpty) {
      entradaEsperada = '';
      salidaEsperada = '';
      entrada = 'LIBRE';
      salida = 'LIBRE';
      freeDay = true;
    } else {
      for (var attendance in lastAttendance) {
        if (attendance['event_type'] == _eventTypeCheckIn) {
          entradaEsperada = formatTimetoTime(attendance['expected_time']);
          if (attendance['pending'] == false) {
            checkInColor = _calculateColor(attendance['comments']);
            entrada = formatDateTimetoTime(attendance['event_time']);
          }
        }
        if (attendance['event_type'] == _eventTypeCheckOut) {
          salidaEsperada = formatTimetoTime(attendance['expected_time']);
          if (attendance['pending'] == false) {
            salida = formatDateTimetoTime(attendance['event_time']);
            checkOutColor = _calculateColor(attendance['comments']);
          }
        }
      }
    }
    notifyListeners();
  }

  Future<String> postNewAttendance(
      int companyid, String eventType, String userlocation) async {
    final _cookie = await storage.read(key: 'mysession');
    Map<String, String> headers = {'Cookie': 'mysession=$_cookie'};

    final Map<String, dynamic> attendanceData = {
      'user_id': 2.toString(), //SACAR
      'company_id': companyid.toString(),
      'device_secret_key': "PENDING",
      'event_type': eventType,
      'location': userlocation,
    };
    final url = Uri.https(_baseUrl, '${_baseAPI}private/attendance');
    print(url);
    final respuesta =
        await http.post(url, body: attendanceData, headers: headers);
    print('Respuesta del postAttendance:  ${respuesta.body}');
    final Map<String, dynamic> decodeResp = json.decode(respuesta.body);
    String answerMsg = _updateStatusAttendance(decodeResp);
    return answerMsg;
  }

  String _updateStatusAttendance(Map<String, dynamic> answer) {
    if (answer.containsKey('error')) {
      print(answer['error']);
      String msgAnswer = answer['error']['message'];
      return msgAnswer;
    } else {
      //Checkin
      if (answer['attendance']['event_type'] == _eventTypeCheckIn) {
        entrada = formatDateTimetoTime(answer['attendance']['event_time']);
        checkInColor = _calculateColor(answer['attendance']['comments']);
        notifyListeners();
        return 'OK';
      }
      //Checkout
      else if (answer['attendance']['event_type'] == _eventTypeCheckOut) {
        salida = formatDateTimetoTime(answer['attendance']['event_time']);
        checkOutColor = _calculateColor(answer['attendance']['comments']);
        notifyListeners();
        return 'OK';
      }
      //Error
      else {
        print('NO SABO QUE PASÓ');
        return 'ERROR DE NOSABO';
      }
    }
  }

  Future<String> setFuturePostInfo(String todo) async {
    List<dynamic> info = await getTodayAttendance();
    for (var attendance in info) {
      if (attendance['event_type'] == todo && attendance['pending'] == true) {
        horaEsperada = attendance['expected_time'];
        _setStatus(attendance['comments'], attendance['event_type']);
        ;
        notifyListeners();
        return 'DONE';
      }
    }
    return 'ERROR!';
  }

  void _setStatus(String comment, String todo) {
    Color newColor;
    if (comment == 'LATE') {
      newColor = Colors.red;
      status = 'TARDE';
    } else if (comment == 'EARLY LEAVE') {
      newColor = Colors.yellow;
      status = 'SALIDA TEMPRANA';
    } else if (comment == 'ON TIME') {
      newColor = Colors.green;
      status = 'A TIEMPO';
    } else if (comment == 'LATE ARRIVAL') {
      newColor = Colors.red;
      status = 'TARDE';
    } else {
      newColor = AppTheme.textPrimColor;
    }
    statusColor = newColor;
    notifyListeners();
  }

  Color _calculateColor(String comment) {
    Color newColor;
    if (comment == 'LATE') {
      newColor = Colors.red;
    } else if (comment == 'EARLY LEAVE') {
      newColor = Colors.yellow;
    } else if (comment == 'ON TIME') {
      newColor = Colors.green;
    } else if (comment == 'LATE ARRIVAL') {
      newColor = Colors.red;
    } else {
      newColor = AppTheme.textPrimColor;
    }
    return newColor;
  }

  Future<List<dynamic>> getCompanyWorkers() async {
    final _cookie = await storage.read(key: 'mysession');
    List<dynamic> workers = [];
    Map<String, String> headers = {'Cookie': 'mysession=$_cookie'};
    final url =
        Uri.https(_baseUrl, '${_baseAPI}private/attendance/company/monthly');
    final respuesta = await http.get(url, headers: headers);
    final List<dynamic> decodeResp = json.decode(respuesta.body);
    //String test ='[  {    "user_id": 15,    "rut": "37",    "role": "cringe",    "picture": "https://www.api.asiendosoftware.xyz/api/v1/open/users/image/15",    "attendances": [      {        "attendance_id": 227,        "event_type": "CHECK_IN",        "expected_time": "09:00:00",        "pending": false,        "event_time": "2022-04-20 09:01:06",        "comments": "LATE ARRIVAL",        "time_diff": "00:01:06"      },      {        "attendance_id": 228,        "event_type": "CHECK_OUT",        "expected_time": "17:30:00",        "pending": false,        "event_time": "2022-04-20 17:41:06",        "comments": "ON TIME",        "time_diff": "00:11:06"      }    ]  },  {    "user_id": 2,    "rut": "",    "role": "based",    "picture": "https://www.api.asiendosoftware.xyz/api/v1/open/users/image/2",    "attendances": [      {        "attendance_id": 233,        "event_type": "CHECK_IN",        "expected_time": "09:00:00",        "pending": false,        "event_time": "2022-05-05 18:28:46",        "comments": "LATE ARRIVAL",        "time_diff": "09:28:46"      },      {        "attendance_id": 234,        "event_type": "CHECK_OUT",        "expected_time": "17:30:00",        "pending": false,        "event_time": "2022-05-05 18:29:49",        "comments": "ON TIME",        "time_diff": "00:59:49"      },      {        "attendance_id": 235,        "event_type": "CHECK_IN",        "expected_time": "09:00:00",        "pending": true,        "event_time": "2022-05-06 00:00:00",        "comments": "ON TIME",        "time_diff": "09:00:00"      },      {        "attendance_id": 236,        "event_type": "CHECK_OUT",        "expected_time": "17:30:00",        "pending": true,        "event_time": "2022-05-06 00:00:00",        "comments": "EARLY LEAVE",        "time_diff": "17:30:00"      }    ]  },  {    "user_id": 6,    "rut": "59",    "role": "cringe",    "picture": "https://www.api.asiendosoftware.xyz/api/v1/open/users/image/6",    "attendances": [      {        "attendance_id": 183,        "event_type": "CHECK_IN",        "expected_time": "06:00:00",        "pending": false,        "event_time": "2022-04-10 06:34:12",        "comments": "LATE ARRIVAL",        "time_diff": "00:34:12"      },      {        "attendance_id": 184,        "event_type": "CHECK_OUT",        "expected_time": "19:00:00",        "pending": false,        "event_time": "2022-04-10 18:58:39",        "comments": "ON TIME",        "time_diff": "00:01:21"      }    ]  }]';
    for (var workerInfo in decodeResp) {
      workers.add(workerInfo);
    }
    //print(workers);
    return workers;
    //return 'a';
  }
}
