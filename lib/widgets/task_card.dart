import 'package:flutter/material.dart';
import 'package:my_tasks/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
  });

  Color _statusColor(BuildContext context) {
    switch (task.status) {
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.pending:
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _statusLabel() {
    switch (task.status) {
      case TaskStatus.inProgress:
        return 'In progress';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.pending:
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task details not available.')),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: title + actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Delegate behavior to parent via onEdit / onDelete.
                  // If callbacks are null, menu items are disabled.
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'Task actions',
                    onSelected: (value) {
                      if (value == 'edit') {
                        // call parent handler if provided
                        onEdit?.call();
                      } else if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        enabled: onEdit != null,
                        child: Text(
                          'Edit',
                          style: onEdit == null
                              ? Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).disabledColor)
                              : null,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        enabled: onDelete != null,
                        child: Text(
                          'Delete',
                          style: onDelete == null
                              ? Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).disabledColor)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 90,
                ),
                child: Text(
                  task.description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 12),

              // Footer: status chip + timestamp
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      _statusLabel(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _statusColor(context),
                  ),
                  Text(
                    '${task.createdAt.year}-${task.createdAt.month.toString().padLeft(2, '0')}-${task.createdAt.day.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
