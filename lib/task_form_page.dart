import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'task_model.dart';

class TaskFormPage extends StatefulWidget {
  final int? taskIndex;
  final Task? task;

  TaskFormPage({this.taskIndex, this.task});

  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  void _saveTask() {
    final taskBox = Hive.box<Task>('tasks');
    final newTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    if (widget.taskIndex != null) {
      taskBox.putAt(widget.taskIndex!, newTask); // Edit data
    } else {
      taskBox.add(newTask); // Tambah data baru
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskIndex != null ? 'Edit Tugas' : 'Tambah Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
