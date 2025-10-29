import 'package:flutter/material.dart';
import 'package:my_tasks/l10n/app_localizations.dart';
import 'package:my_tasks/models/task.dart';

typedef OnSaveTask = Future<void> Function({
  required String title,
  required String description,
  required TaskStatus status,
});

class TaskForm extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final TaskStatus? initialStatus;
  final OnSaveTask onSave;
  final bool isSaving;

  const TaskForm({
    super.key,
    required this.onSave,
    this.initialTitle,
    this.initialDescription,
    this.initialStatus,
    this.isSaving = false,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtl;
  late final TextEditingController _descCtl;
  late TaskStatus _status;

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.initialTitle ?? '');
    _descCtl = TextEditingController(text: widget.initialDescription ?? '');
    _status = widget.initialStatus ?? TaskStatus.pending;
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSave(
      title: _titleCtl.text.trim(),
      description: _descCtl.text.trim(),
      status: _status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title (required)
            TextFormField(
              controller: _titleCtl,
              decoration: InputDecoration(
                labelText: loc.taskTitleLabel,
                border: const OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return loc.taskTitleRequired;
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Description (optional)
            TextFormField(
              controller: _descCtl,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: loc.taskDescriptionLabel,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),

            // Status selector
            DropdownButtonFormField<TaskStatus>(
              value: _status,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: loc.taskStatusLabel,
              ),
              items: [
                DropdownMenuItem(
                  value: TaskStatus.pending,
                  child: Text(loc.taskStatusPending),
                ),
                DropdownMenuItem(
                  value: TaskStatus.inProgress,
                  child: Text(loc.taskStatusInProgress),
                ),
                DropdownMenuItem(
                  value: TaskStatus.done,
                  child: Text(loc.taskStatusDone),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
            const SizedBox(height: 18),

            // Save button (caller handles actual saving)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.isSaving ? null : _handleSave,
                child: widget.isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(loc.save),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
