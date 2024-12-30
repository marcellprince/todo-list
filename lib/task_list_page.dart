import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_model.dart';
import 'task_form_page.dart';

class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> tasks, _) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks.getAt(index);

              return ListTile(
                title: Text(task?.title ?? ''),
                subtitle: Text(task?.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: task?.isCompleted ?? false,
                      onChanged: (value) {
                        task?.isCompleted = value!;
                        taskBox.putAt(index, task!);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        taskBox.deleteAt(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskFormPage(
                              taskIndex: index,
                              task: task,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormPage()),
          );
        },
      ),
    );
  }
}
