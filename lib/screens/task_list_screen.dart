import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_tasks/services/auth_service.dart';
import 'package:my_tasks/providers/task_provider.dart';
import 'package:my_tasks/widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  static const routeName = '/tasks';
  const TaskListScreen({super.key});

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature not available now')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              // After logout, go to login and clear stack
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            final tasks = taskProvider.tasks;

            if (tasks.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.task_alt_outlined, size: 64, color: Theme.of(context).hintColor),
                      const SizedBox(height: 12),
                      const Text(
                        'No tasks yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create tasks to see them here.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _comingSoon(context, 'Add task'),
                        child: const Text('Add task (coming soon)'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Responsive layout using LayoutBuilder:
            return LayoutBuilder(builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              if (maxWidth >= 900) {
                // Desktop: 3 columns
                return _buildGrid(tasks, crossAxisCount: 3);
              } else if (maxWidth >= 600) {
                // Tablet: 2 columns
                return _buildGrid(tasks, crossAxisCount: 2);
              } else {
                // Mobile: single-column list
                return RefreshIndicator(
                  onRefresh: () async {
                    // For now, just show a UI hint.
                    _comingSoon(context, 'Refresh');
                    await Future.delayed(const Duration(milliseconds: 400));
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final t = tasks[index];
                      return TaskCard(
                        task: t,
                        onEdit: () => _comingSoon(context, 'Edit task'),
                        onDelete: () => _comingSoon(context, 'Delete task'),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                  ),
                );
              }
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _comingSoon(context, 'Add task'),
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }

  Widget _buildGrid(List tasks, {required int crossAxisCount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: GridView.builder(
        itemCount: tasks.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemBuilder: (context, index) {
          final t = tasks[index];
          return TaskCard(
            task: t,
            onEdit: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Edit coming soon')),
            ),
            onDelete: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Delete coming soon')),
            ),
          );
        },
      ),
    );
  }
}
