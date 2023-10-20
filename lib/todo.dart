class Todo {
  final int id;
  final String title;
  final int done;
  Todo({
    required this.id,
    required this.title,
    required this.done,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      title: map['title'] as String,
      done: map['done'] as int,
    );
  }
}
