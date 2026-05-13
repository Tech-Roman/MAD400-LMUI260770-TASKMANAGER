import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  String filter = "All";
  String searchText = "";

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  List<Task> getFilteredTasks() {
    List<Task> filtered = tasks;

    if (filter == "Pending") {
      filtered = tasks.where((task) => !task.isCompleted).toList();
    }

    if (filter == "Completed") {
      filtered = tasks.where((task) => task.isCompleted).toList();
    }

    filtered = filtered.where((task) {
      return task.title.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return filtered;
  }

  void sortByDate() {
    setState(() {
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  void sortByPriority() {
    Map<String, int> priorityMap = {
      "High": 1,
      "Medium": 2,
      "Low": 3,
    };

    setState(() {
      tasks.sort((a, b) => priorityMap[a.priority]!.compareTo(priorityMap[b.priority]!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = MediaQuery.of(context).size.height;
        final bool isTablet = screenWidth > 600;
        final bool isDesktop = screenWidth > 900;

        int completed = tasks.where((task) => task.isCompleted).length;
        int pending = tasks.length - completed;
        double progress = tasks.isEmpty ? 0 : completed / tasks.length;
        List<Task> filteredTasks = getFilteredTasks();

        return Scaffold(
          body: Column(
            children: [
              // Hero Section
              Container(
                width: double.infinity,
                height: isDesktop ? 200 : screenHeight * 0.25,
                decoration: const BoxDecoration(
                  color: Color(0xFF228B22),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Task Manager",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.sort, color: Colors.white),
                                      onPressed: () => _showSortOptions(context),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_forever, color: Colors.white),
                                      onPressed: () => _showClearAllDialog(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatText("Total: ${tasks.length}"),
                                _buildStatText("Done: $completed"),
                                _buildStatText("Pending: $pending"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 40 : 20.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          children: [
                            // Search & Filters Row
                            if (isTablet)
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _buildBlogBlock(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          hintText: "Search tasks...",
                                          prefixIcon: Icon(Icons.search, color: Color(0xFF228B22)),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          setState(() => searchText = value);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: 2,
                                    child: _buildBlogBlock(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            _buildFilterChip("All"),
                                            const SizedBox(width: 8),
                                            _buildFilterChip("Pending"),
                                            const SizedBox(width: 8),
                                            _buildFilterChip("Completed"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  _buildBlogBlock(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        hintText: "Search tasks...",
                                        prefixIcon: Icon(Icons.search, color: Color(0xFF228B22)),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        setState(() => searchText = value);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  _buildBlogBlock(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildFilterChip("All"),
                                        const SizedBox(width: 8),
                                        _buildFilterChip("Pending"),
                                        const SizedBox(width: 8),
                                        _buildFilterChip("Completed"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 20),

                            // Task List / Grid
                            if (filteredTasks.isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Text("No tasks available",
                                    style: TextStyle(color: Colors.grey)),
                              )
                            else if (isTablet)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 400,
                                  mainAxisExtent: 100,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                itemCount: filteredTasks.length,
                                itemBuilder: (context, index) {
                                  final task = filteredTasks[index];
                                  return TaskCard(
                                    task: task,
                                    onTap: () => _navigateToDetail(context, task),
                                  );
                                },
                              )
                            else
                              ...filteredTasks.map((task) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    background: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 20),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    onDismissed: (_) {
                                      setState(() => tasks.remove(task));
                                    },
                                    child: TaskCard(
                                      task: task,
                                      onTap: () => _navigateToDetail(context, task),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF228B22),
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () => showAddTaskSheet(context),
          ),
        );
      },
    );
  }

  Widget _buildStatText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildBlogBlock({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = filter == label;
    return GestureDetector(
      onTap: () => setState(() => filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF228B22) : const Color(0xFF228B22).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF228B22),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          task: task,
          onDelete: () {
            setState(() {
              tasks.remove(task);
            });
          },
          onToggle: () {
            setState(() {
              task.isCompleted = !task.isCompleted;
            });
          },
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("Sort by Due Date"),
            onTap: () {
              sortByDate();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.priority_high),
            title: const Text("Sort by Priority"),
            onTap: () {
              sortByPriority();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Clear All"),
        content: const Text("Delete all tasks?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => tasks.clear());
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void showAddTaskSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String category = "School";
    String priority = "Low";
    DateTime? dueDate;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Create New Task",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF228B22),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSoftInput(
                          controller: titleController,
                          hint: "Task Name",
                          icon: Icons.edit_note,
                          validator: (value) =>
                          (value == null || value.isEmpty) ? "Task name is required" : null,
                        ),
                        const SizedBox(height: 15),
                        _buildSoftInput(
                          controller: descriptionController,
                          hint: "Description",
                          icon: Icons.description_outlined,
                          maxLines: 3,
                          validator: (value) =>
                          (value == null || value.isEmpty) ? "Description is required" : null,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSoftActionBox(
                                label: dueDate == null
                                    ? "Select Date"
                                    : dueDate!.toString().split(' ')[0],
                                icon: Icons.calendar_today,
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setModalState(() => dueDate = picked);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildSoftDropdown(
                                value: priority,
                                items: ["Low", "Medium", "High"],
                                label: "Priority",
                                icon: Icons.flag_outlined,
                                onChanged: (val) => setModalState(() => priority = val!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildSoftDropdown(
                          value: category,
                          items: ["School", "Personal", "Work", "Health"],
                          label: "Purpose",
                          icon: Icons.category_outlined,
                          onChanged: (val) => setModalState(() => category = val!),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                child: const Text("Cancel",
                                    style: TextStyle(
                                        color: Colors.grey, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (dueDate == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Please select a due date")),
                                      );
                                      return;
                                    }
                                    addTask(Task(
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      category: category,
                                      priority: priority,
                                      dueDate: dueDate!,
                                    ));
                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF228B22),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 2,
                                ),
                                child: const Text("Create Task",
                                    style: TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSoftInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF228B22).withValues(alpha: 0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSoftActionBox({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF228B22).withValues(alpha: 0.7)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoftDropdown({
    required String value,
    required List<String> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: const Color(0xFF228B22).withValues(alpha: 0.7)),
          prefixIcon: Icon(icon, color: const Color(0xFF228B22).withValues(alpha: 0.7)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
