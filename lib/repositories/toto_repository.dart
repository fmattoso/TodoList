import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

import 'dart:convert';

const todoListKey = 'todo_list';

class TodoRepository {
  // Usando late estou dizendo que vou utilizar esta variavel depois que ela
  // for inicializada.
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}