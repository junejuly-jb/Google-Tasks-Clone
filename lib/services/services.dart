import '../models/todo.dart';
import 'package:http/http.dart' as http;

class Services {
  static const String baseURL = 'http://10.0.2.2:5000';

  static Future<List<Todo>> getTodos() async {
    var url = Uri.parse('$baseURL/api/v1/todos');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 2));
      final List<Todo> todos = todoFromJson(response.body);
      return todos;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
