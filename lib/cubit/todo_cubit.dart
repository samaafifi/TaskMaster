import 'package:flutter_bloc/flutter_bloc.dart';
import '../todo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void addTodo(Todo todo) => emit([...state, todo]);

  void updateTodo(Todo todo) {
    emit(state.map((t) => t.id == todo.id ? todo : t).toList());
  }

  void deleteTodo(String id) {
    emit(state.where((t) => t.id != id).toList());
  }

  void toggleDone(String id) {
    emit(state.map((t) => t.id == id ? t.copyWith(isDone: !t.isDone) : t).toList());
  }

  void reorder(int oldIndex, int newIndex) {
    final list = List<Todo>.from(state);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    emit(list);
  }
}