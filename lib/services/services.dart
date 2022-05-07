import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../models/todo.dart';
import 'package:http/http.dart' as http;

class Services {
  static const String baseURL = 'https://tasksapi.vercel.app';
  static final sessionManager = SessionManager();

  static Future<List<Todo>> getTodos() async {
    var token = await SessionManager().get('token');
    var url = Uri.parse('$baseURL/api/v1/todos');
    print(token);
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    print(response.body);
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 1));
      final List<Todo> todos = todoFromJson(response.body);
      return todos;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
