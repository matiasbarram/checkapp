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
      print('Error number: ${respuesta.statusCode}');
      return [];
    }
  }

  Future<void> updateCurrentStatus() async {
    final lastAttendance = await getTodayAttendance();
    if (lastAttendance.isEmpty) {
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
    if (respuesta.statusCode == 200) {
      final List<dynamic> decodeResp = json.decode(respuesta.body);
      for (var workerInfo in decodeResp) {
        if (workerInfo['role'] != 'based') {
          workers.add(workerInfo);
        }
      }
      return workers;
    } else {
      //@todo
      return [];
    }
  }
}
