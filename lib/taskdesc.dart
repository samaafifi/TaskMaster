import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo.dart';
import 'cubit/todo_cubit.dart';

class TaskDetailScreen extends StatefulWidget {
  final Todo? todo;

  const TaskDetailScreen({super.key, this.todo});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  DateTime? _dueDate;

  bool get isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _notesController = TextEditingController(text: widget.todo?.notes ?? '');
    _dueDate = widget.todo?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;

    final cubit = context.read<TodoCubit>();
    final newTodo = Todo(
      id: widget.todo?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      isDone: widget.todo?.isDone ?? false,
      dueDate: _dueDate,
      notes: _notesController.text.trim(),
    );

    if (isEditing) {
      cubit.updateTodo(newTodo);
    } else {
      cubit.addTodo(newTodo);
    }

    Navigator.pop(context);
  }

  void _delete() {
    context.read<TodoCubit>().deleteTodo(widget.todo!.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMaster'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TITLE', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text('DUE DATE', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_dueDate == null
                        ? 'Select date'
                        : '${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}'),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('NOTES', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _notesController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isEditing)
                  TextButton.icon(
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    label: const Text('DELETE', style: TextStyle(color: Colors.grey)),
                  )
                else
                  const SizedBox(),
                TextButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: const Text('SAVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}