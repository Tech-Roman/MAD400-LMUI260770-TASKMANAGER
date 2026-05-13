import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  Color getPriorityColor() {
    switch (task.priority) {
      case "High":
        return Colors.red;

      case "Medium":
        return Colors.orange;

      default:
        return Colors.green;
    }
  }

  IconData getCategoryIcon() {
    switch (task.category) {
      case "School":
        return Icons.school;

      case "Health":
        return Icons.favorite;

      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isOverdue =
        task.dueDate.isBefore(DateTime.now()) &&
            !task.isCompleted;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(
          getCategoryIcon(),
          color: getPriorityColor(),
        ),

        title: Text(
          task.title,

          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : null,

            color: isOverdue ? Colors.red : Colors.black,

            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          "${task.category} • ${task.priority}",
        ),

        trailing: Icon(
          task.isCompleted
              ? Icons.check_circle
              : Icons.circle_outlined,
          color: task.isCompleted
              ? Colors.green
              : Colors.grey,
        ),
      ),
    );
  }
}