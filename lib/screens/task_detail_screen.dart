import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final Function onDelete;
  final Function onToggle;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = MediaQuery.of(context).size.height;
        final bool isWide = screenWidth > 700;
        final double heroHeight = isWide ? 250 : screenHeight * 0.4;
        const Color primaryColor = Color(0xFF228B22);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // HERO SECTION
                Container(
                  width: double.infinity,
                  height: heroHeight,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.task_alt,
                              color: Colors.white,
                              size: 60,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                task.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Chip(
                              label: Text(
                                task.isCompleted ? "Completed" : "Pending",
                                style: TextStyle(
                                  color: task.isCompleted ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // BLOG SECTIONS
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _buildBlogSection(
                                    title: "Description",
                                    content: task.description,
                                    icon: Icons.description_rounded,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: _buildBlogSection(
                                    title: "Task Details",
                                    content: "Category: ${task.category}\n"
                                        "Priority: ${task.priority}\n"
                                        "Due Date: ${task.dueDate.toString().split(' ')[0]}",
                                    icon: Icons.info_outline_rounded,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                _buildBlogSection(
                                  title: "Description",
                                  content: task.description,
                                  icon: Icons.description_rounded,
                                ),
                                const SizedBox(height: 16),
                                _buildBlogSection(
                                  title: "Task Details",
                                  content: "Category: ${task.category}\n"
                                      "Priority: ${task.priority}\n"
                                      "Due Date: ${task.dueDate.toString().split(' ')[0]}",
                                  icon: Icons.info_outline_rounded,
                                ),
                              ],
                            ),

                          const SizedBox(height: 30),

                          // BUTTONS
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 300),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        onToggle();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        task.isCompleted ? "Undo" : "Complete",
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 300),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade400,
                                      ),
                                      onPressed: () {
                                        _showDeleteDialog(context);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back from detail screen
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF228B22).withValues(alpha: 0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF228B22).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF228B22), size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF228B22),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
