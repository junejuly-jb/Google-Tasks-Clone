import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../models/todo.dart';
import 'package:http/http.dart' as http;

class Services {
  static const String baseURL = 'https://tasksapi.vercel.app';
  static final sessionManager = SessionManager();

  static Future<List<Todo>> getTodos() async {
    var token = await SessionManager().get('token');
    var url = Uri.parse('$baseURL/api/v1/todos');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final List<Todo> todos = todoFromJson(response.body);
      return todos;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future postTodo(String task, String details) async {
    var url = Uri.parse('$baseURL/api/v1/add-todo');
    var token = await SessionManager().get('token');
    final response = await http.post(url,
        body: {'todo': task, 'details': details},
        headers: {'Authorization': 'Bearer $token'});
    Map res = await json.decode(response.body);
    return res;
  }

  static Future deleteTodo(String id) async {
    var url = Uri.parse('$baseURL/api/v1/delete-todo/$id');
    var token = await SessionManager().get('token');
    final response = await http.delete(url, headers: {'Authorization': 'Bearer $token'});
    Map res = await json.decode(response.body);
    return res;
  }

  static Future todoToggler(String? id, bool? flag) async {
    var request = '';
    if(flag != null){
      request = flag ? 'unmark-todo' : 'mark-todo';
    }
    var url = Uri.parse('$baseURL/api/v1/$request/$id');
    var token = await SessionManager().get('token');
    final response = await http.put(url, headers: {'Authorization': 'Bearer $token'});
    Map res = await json.decode(response.body);
    return res;
  }

  static Future updateTodo(String? id, String todo, String details) async {
    var url = Uri.parse('$baseURL/api/v1/update-todo/$id');
    var token = await SessionManager().get('token');
    final response = await http.put(url,
      body: {'todo': todo, 'details': details},
      headers: {'Authorization': 'Bearer $token'}
    );
    Map res = await json.decode(response.body);
    return res;
  }
}
