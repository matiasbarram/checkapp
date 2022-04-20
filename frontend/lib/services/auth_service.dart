// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final String _baseUrl = 'api.asiendosoftware.xyz';
  final String _baseAPI = '/api/v1/';
  final String _cookieName = 'mysession';

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    final url = Uri.https(_baseUrl, '${_baseAPI}login');
    print(url);
    final respuesta = await http.post(url, body: authData);
    print('Respuesta:  $respuesta');
    print('haciendo el post...');
    final Map<String, dynamic> decodeResp = json.decode(respuesta.body);

    if (!decodeResp.containsKey('error')) {
      await _updateCookie(respuesta);
    }
    return decodeResp;
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
            if (key == _cookieName) {
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
    final val = await storage.read(key: 'mysession') ?? 'no-key';
    print('Valor de la key actual: ' + val);
    return val;
  }

  Future<void> logout() async {
    print('Borrando keys...');
    await storage.delete(key: 'mysession');
    checkKeys();
  }

  Future<void> checkKeys() async {
    Map<String, String> allValues = await storage.readAll();
    print('Todas las claves  guardadas son: ' + allValues.toString());
  }
}
