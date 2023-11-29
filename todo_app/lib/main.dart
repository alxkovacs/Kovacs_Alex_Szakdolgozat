import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_list.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TodoList(),
    ),
  );
}
