class Todo {
  String id;
  String title;
  bool isDone;
  DateTime? dueDate; //to make it optional
  String notes;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    this.dueDate,
    this.notes = '',
  });
  Todo copyWith({
    String? title,
    bool? isDone,
    DateTime? dueDate,
    String? notes,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
    );
  }
}