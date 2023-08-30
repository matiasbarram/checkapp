// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../helpers/variables.dart' as variables;

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final String _apiURL = variables.apiURL;
  final String __cookieName = variables.cookieName;

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    final url = Uri.parse(_apiURL + '/login');
    print(url);

    try {
      final respuesta = await http.post(url, body: authData);
      print('Respuesta:  ${respuesta.body}');
      final Map<String, dynamic> decodeResp = json.decode(respuesta.body);

      if (!decodeResp.containsKey('error') && decodeResp.isNotEmpty) {
        await _userInfoCookie(decodeResp);
        await _updateCookie(respuesta);
      } else {
        throw "Error or empty";
      }
      return decodeResp;
    } catch (error) {
      print('Error: $error');
      return {};
    }
  }

  Future<void> _userInfoCookie(Map<String, dynamic> respuesta) async {
    print(respuesta);
    final int id = respuesta['user']['Id'];
    final String userName = respuesta['user']['Name'];
    final String userRol = respuesta['user']['Role'];
    final Map<String, dynamic> userInfo = {
      'name': userName,
      'rol': userRol,
      'id': id
    };
    await storage.write(key: 'userInfo', value: json.encode(userInfo));
  }

  Future<void> _updateCookie(http.Response respuesta) async {
    String? rawCookie = respuesta.headers['set-cookie'];
    if (rawCookie != null && rawCookie.isNotEmpty) {
      final cookies = rawCookie.split(';');
      for (final cookie in cookies) {
        if (cookie.isNotEmpty) {
          int idx = cookie.indexOf("=");
          List keyValue = [
            cookie.substring(0, idx).trim(),
            cookie.substring(idx + 1).trim()
          ];
          if (keyValue.length == 2) {
            //DO sominthing
            print(keyValue);
            var key = keyValue[0];
            var value = keyValue[1];
            if (key == __cookieName) {
              print('Guardando key...  ' + key + '   ' + value);
              await storage.write(key: key, value: value);
              await checkKeys();
            }
          }
        }
      }
    }
  }

  Future<String> readToken() async {
    const String noToken = 'no-key';
    final val = await storage.read(key: 'mysession') ?? noToken;
    return val;
  }

  Future<void> logout() async {
    print('Borrando keys...');
    //await storage.delete(key: 'mysession');
    await storage.deleteAll();
    checkKeys();
  }

  Future<void> checkKeys() async {
    Map<String, String> allValues = await storage.readAll();
    print('Todas las claves  guardadas son: ' + allValues.toString());
  }

  Future<String> logedUserRol() async {
    final String? info = await storage.read(key: 'userInfo');
    if (info != null) {
      Map<String, dynamic> userInfo = json.decode(info);
      final String role = userInfo['rol'];
      print("User role: " + role);
      return role;
    }
    return 'error';
  }
}
