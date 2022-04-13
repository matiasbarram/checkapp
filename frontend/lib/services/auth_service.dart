import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'api.asiendosoftware.xyz';
  final storage = FlutterSecureStorage();
  final String _cookieName = 'mysession';

  //final String token = '';

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    final url = Uri.https(_baseUrl, 'login');
    final respuesta = await http.post(url, body: authData);
    final Map<String, dynamic> decodeResp = json.decode(respuesta.body);

    _updateCookie(respuesta);

    return decodeResp;
  }

  void _updateCookie(http.Response respuesta) {
    String? rawCookie = respuesta.headers['set-cookie'];
    print(rawCookie);
    if (rawCookie != null) {
      //headers['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      print(rawCookie);
      final cookies = rawCookie.split(';');
      for (final cookie in cookies) {
        _setCookie(cookie);
      }
    } else {
      //set cookie
    }
  }

  void _setCookie(String rawCookie) async {
    if (rawCookie.isNotEmpty) {
      int idx = rawCookie.indexOf("=");
      List keyValue = [
        rawCookie.substring(0, idx).trim(),
        rawCookie.substring(idx + 1).trim()
      ];
      if (keyValue.length == 2) {
        //DO sominthing
        print(keyValue);
        var key = keyValue[0];
        var value = keyValue[1];
        if (key == _cookieName) {
          print('Guardando key...');
          await storage.write(key: key, value: value);
        }
      }
    }
  }

  Future<String> readToken() async {
    return await storage.read(key: 'mysession') ?? '';
  }

  Future<void> logout() async {
    await storage.delete(key: 'mysession');
  }
}
