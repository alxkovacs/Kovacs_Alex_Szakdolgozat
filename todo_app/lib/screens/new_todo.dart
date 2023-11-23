import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class NewTodo extends StatefulWidget {
  const NewTodo({super.key, required this.onAddTodo});

  final void Function(Todo todo) onAddTodo;

  @override
  State<StatefulWidget> createState() {
    return _NewTodoState();
  }
}

class _NewTodoState extends State<NewTodo> {
  final _todoNameController = TextEditingController();
  Priority _selectedPriority = Priority.urgent;

  void _submitTodoData() {
    if (_todoNameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content:
              const Text('Please make sure a valid Todo Name was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddTodo(
      Todo(
        text: _todoNameController.text,
        priority: _selectedPriority,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _todoNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _todoNameController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Todo Name'),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedPriority,
                items: Priority.values
                    .map(
                      (priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(
                          priority.name.capitalize(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      return;
                    }
                    _selectedPriority = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitTodoData,
                child: const Text('Save Todo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
