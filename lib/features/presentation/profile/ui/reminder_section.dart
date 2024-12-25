import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
class ReminderSection extends StatefulWidget {
  final String userId;
  final List<String> initialReminders;
  final Function(List<String>) onRemindersUpdated;

  const ReminderSection({
    Key? key,
    required this.userId,
    required this.initialReminders,
    required this.onRemindersUpdated,
  }) : super(key: key);

  @override
  _ReminderSectionState createState() => _ReminderSectionState();
}

class _ReminderSectionState extends State<ReminderSection> {
  late List<String> _reminders;
  final TextEditingController _reminderController = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _reminders = List.from(widget.initialReminders);
  }

  Future<void> _updateReminders() async {
    setState(() => _isSaving = true);
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/user/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'reminders': _reminders}),
      );

      if (response.statusCode == 200) {
        widget.onRemindersUpdated(_reminders);
        _showSuccessSnackBar('Reminders updated successfully');
      } else {
        _showErrorSnackBar('Failed to update reminders');
      }
    } catch (e) {
      _showErrorSnackBar('Error updating reminders');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _addReminder(String reminder) {
    if (reminder.trim().isEmpty) return;
    setState(() {
      _reminders.add(reminder.trim());
      _reminderController.clear();
    });
    _updateReminders();
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
    _updateReminders();
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFFB23B3B),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Reminders',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondaryFixed,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.done : Icons.edit,
                  color: Theme.of(context).colorScheme.secondaryFixed,
                ),
                onPressed: () => setState(() => _isEditing = !_isEditing),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _reminderController,
                      decoration: InputDecoration(
                        hintText: 'Add a new reminder',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).colorScheme.secondaryFixed,
                      size: 32,
                    ),
                    onPressed: () => _addReminder(_reminderController.text),
                  ),
                ],
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reminders.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Theme.of(context).colorScheme.secondaryFixed,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _reminders[index],
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.secondaryFixed,
                        ),
                      ),
                    ),
                    if (_isEditing)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () => _removeReminder(index),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reminderController.dispose();
    super.dispose();
  }
}