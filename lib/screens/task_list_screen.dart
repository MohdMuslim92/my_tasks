import 'package:flutter/material.dart';
import 'package:my_tasks/l10n/app_localizations.dart';
import 'package:my_tasks/widgets/theme_toggle.dart';
import 'package:provider/provider.dart';
import 'package:my_tasks/services/auth_service.dart';
import 'package:my_tasks/providers/task_provider.dart';
import 'package:my_tasks/widgets/task_card.dart';
import 'package:my_tasks/screens/add_edit_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  static const routeName = '/tasks';
  const TaskListScreen({super.key});

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.deleteTaskTitle),
        content: Text(loc.deleteTaskContent),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(loc.cancel)),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(loc.delete)),
        ],
      ),
    );

    if (confirmed == true) {
      await Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
      _showSnack(context, loc.taskDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tasksTitle),
        actions: [
          const ThemeToggle(),
          IconButton(
            tooltip: loc.logoutTooltip,
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
                      Text(loc.noTasksYet,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(loc.createTasksHint, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
                        ),
                        child: Text(loc.addTask),
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
                return _buildGrid(tasks, crossAxisCount: 3, context: context);
              } else if (maxWidth >= 600) {
                // Tablet: 2 columns
                return _buildGrid(tasks, crossAxisCount: 2, context: context);
              } else {
                // Mobile: single-column list
                return RefreshIndicator(
                  // In-memory provider is instant; this is just UI affordance.
                  onRefresh: () async => _showSnack(context, loc.refreshMessage),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final t = tasks[index];
                      return TaskCard(
                        task: t,
                        onEdit: () {
                          Navigator.of(context).pushNamed(
                            AddEditTaskScreen.routeName,
                            arguments: t.id,
                          );
                        },
                        onDelete: () => _confirmDelete(context, t.id),
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
        onPressed: () {
          Navigator.of(context).pushNamed(AddEditTaskScreen.routeName);
        },
        icon: const Icon(Icons.add),
        label: Text(loc.addTask),
      ),
    );
  }

  Widget _buildGrid(List tasks, {required int crossAxisCount, required BuildContext context}) {
    final loc = AppLocalizations.of(context)!;
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
            onEdit: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AddEditTaskScreen(taskId: t.id)));
            },
            onDelete: () => _confirmDelete(context, t.id),
          );
        },
      ),
    );
  }
}
