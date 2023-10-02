import 'package:flutter/material.dart';
import 'package:todo_app/widgets/checkable_todo_item.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screens/new_todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  var _order = 'asc';

  final List<Todo> _todos = [
    Todo(
      text: 'Practice Flutter',
      priority: Priority.urgent,
    ),
    Todo(
      text: 'Learn Flutter',
      priority: Priority.low,
    ),
    Todo(
      text: 'Explore other courses Explore other courses Explore other courses',
      priority: Priority.urgent,
    ),
    Todo(
      text: 'Clean',
      priority: Priority.low,
    ),
    Todo(
      text: 'Eat',
      priority: Priority.low,
    ),
  ];

  List<Todo> get _orderedTodos {
    final sortedTodos = List.of(_todos);
    sortedTodos.sort((a, b) {
      final bComesAfterA = a.text.compareTo(b.text);
      return _order == 'asc' ? bComesAfterA : -bComesAfterA;
    });

    return sortedTodos;
  }

  void _changeOrder() {
    setState(() {
      _order = _order == 'asc' ? 'desc' : 'asc';
    });
  }

  void _openAddTodoOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewTodo(onAddTodo: _addTodo),
    );
  }

  void _addTodo(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  void _removeTodo(Todo todo) {
    final todoIndex = _todos.indexOf(todo);

    setState(() {
      _todos.remove(todo);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Todo deleted.'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _todos.insert(todoIndex, todo);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No todos found. Start adding some!'),
    );

    if (_todos.isNotEmpty) {
      mainContent = SingleChildScrollView(
        child: Column(
          children: [
            // for (final todo in _orderedTodos) TodoItem(todo.text, todo.priority),
            for (final todo in _orderedTodos)
              Dismissible(
                key: ValueKey(todo),
                onDismissed: (direction) {
                  _removeTodo(todo);
                },
                child: CheckableTodoItem(
                  key: ObjectKey(todo), // ValueKey()
                  todo.text,
                  todo.priority,
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            onPressed: _openAddTodoOverlay,
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _changeOrder,
              icon: Icon(
                _order == 'asc' ? Icons.arrow_downward : Icons.arrow_upward,
              ),
              label:
                  Text('Sort ${_order == 'asc' ? 'Descending' : 'Ascending'}'),
            ),
          ),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
