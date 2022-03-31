import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        setState(() {
                          Todo newTodo =
                              Todo(title: text, dateTime: DateTime.now());
                          todos.add(newTodo);
                        });
                        todoController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF00D7F3),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Você possui ${todos.length} tarefas pendentes.',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: deleteAllTodos,
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF00D7F3),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text('Limpar Tudo'),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  void onDelete(Todo todo) {
    Todo deletedTodo = todo;
    int itPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    // Se apagar vários, ele vai ficar mostrando o SnackBar com bastante delay
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(
        'Tarefa ${todo.title} foi removida com sucesso!',
        style: const TextStyle(color: Colors.black54),
      ),
      backgroundColor: Colors.orangeAccent,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.blueAccent,
        onPressed: () {
          setState(() {
            todos.insert(itPos, deletedTodo);
          });
        },
      ),
    ));
  }

  void deleteAllTodos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: const Color(0xFF00D7F3)),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              executeDeleteAll();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: const Text('Sim'),
          )
        ],
      ),
    );
  }

  void executeDeleteAll() {
    setState(() {
      todos.clear();
    });
  }
}
