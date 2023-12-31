import 'package:test/test.dart';
import 'package:sql/todo.dart';

void main() {
  group('Todo', () {
    test('should convert to and from a map', () {
      final todo = Todo(
        id: 1,
        title: 'Buy groceries',
        done: 0,
      );

      final todoMap = {"id": 1, "title": "Buy groceries", "done": 0};

      final newTodo = Todo.fromMap(todoMap);

      expect(newTodo.id, equals(todo.id));
      expect(newTodo.title, equals(todo.title));
      expect(newTodo.done, equals(todo.done));
    });
  });
}
