import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

class Auth {
  final baseURL = 'http://10.0.2.2:5000';
  static final sessionManager = SessionManager();

  Future<dynamic> register(String name, String email, String password) async {
    try {
      var url = Uri.parse('$baseURL/api/v1/register');
      var response = await http.post(url,
          body: {'name': name, 'email': email, 'password': password});
      Map decode = jsonDecode(response.body);
      return decode;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      var url = Uri.parse('$baseURL/api/v1/login');
      var response =
          await http.post(url, body: {'email': email, 'password': password});
      Map decode = jsonDecode(response.body);
      print('try');
      return decode;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> removeSession(sessionName) async {
    await sessionManager.remove(sessionName);
  }
}
