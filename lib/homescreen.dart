import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo.dart';
import 'taskdesc.dart';
import 'calendar_screen.dart';
import 'cubit/todo_cubit.dart';

class HomeScreen extends StatelessWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  Future<void> _openDetail(BuildContext context, {Todo? todo}) async {
    final cubit = context.read<TodoCubit>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(todo: todo)),
    );

    if (result == null) return;

    if (result == 'delete') {
      cubit.deleteTodo(todo!.id);
    } else if (result is Todo) {
      final exists = cubit.state.any((t) => t.id == result.id);
      exists ? cubit.updateTodo(result) : cubit.addTodo(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: BlocBuilder<TodoCubit, List<Todo>>(
          builder: (context, todos) {
            final remaining = todos.where((t) => !t.isDone).length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hello, Jordan', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text('You have $remaining tasks remaining for today.',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: todos.length,
                    onReorder: (oldIndex, newIndex) =>
                        context.read<TodoCubit>().reorder(oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Dismissible(
                        key: ValueKey(todo.id), // required by both Dismissible & ReorderableListView
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => context.read<TodoCubit>().deleteTodo(todo.id),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Checkbox(
                            value: todo.isDone,
                            onChanged: (_) => context.read<TodoCubit>().toggleDone(todo.id),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.isDone ? TextDecoration.lineThrough : null,
                              color: todo.isDone ? Colors.grey : Colors.black,
                            ),
                          ),
                          onTap: () => _openDetail(context, todo: todo),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDetail(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}