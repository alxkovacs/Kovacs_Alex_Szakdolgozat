import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Priority { urgent, normal, low }

class Todo {
  Todo({
    required this.text,
    required this.priority,
  }) : id = uuid.v4();

  final String id;
  final String text;
  final Priority priority;
}
