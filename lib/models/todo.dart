// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

List<Todo> todoFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
    Todo({
      required this.id,
      required this.todo,
      required this.flag,
    });

    final String id;
    final String todo;
    final bool flag;

    factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["_id"],
        todo: json["todo"],
        flag: json["flag"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "todo": todo,
        "flag": flag,
    };
}
