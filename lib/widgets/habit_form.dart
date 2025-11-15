import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../services/habit_service.dart';
import '../models/habit.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class HabitForm extends StatefulWidget {
  final String userId;
  final Habit? editing;
  const HabitForm({Key? key, required this.userId, this.editing})
      : super(key: key);

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_task_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'New Habit',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .moveX(begin: -20, end: 0, duration: 400.ms),
              const SizedBox(height: 32),
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'title',
                      decoration: const InputDecoration(
                        labelText: 'Habit Title',
                        hintText: 'e.g., Exercise daily',
                        prefixIcon: Icon(Icons.title_rounded),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: 'Please enter a habit title',
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .moveY(begin: 20, end: 0, duration: 400.ms),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      name: 'notes',
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Add any additional notes...',
                        prefixIcon: Icon(Icons.note_rounded),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 400.ms)
                        .moveY(begin: 20, end: 0, duration: 400.ms),
                    const SizedBox(height: 20),
                    FormBuilderDropdown(
                      name: 'frequency',
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        prefixIcon: Icon(Icons.repeat_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'daily',
                          child: Row(
                            children: [
                              Icon(Icons.today_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Daily'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'weekly',
                          child: Row(
                            children: [
                              Icon(Icons.calendar_view_week_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Weekly'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'custom',
                          child: Row(
                            children: [
                              Icon(Icons.schedule_rounded, size: 20),
                              SizedBox(width: 12),
                              Text('Custom'),
                            ],
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms)
                        .moveY(begin: 20, end: 0, duration: 400.ms),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _busy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.check_circle_rounded, size: 22),
                        label: Text(
                          _busy ? 'Creating...' : 'Create Habit',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: _busy
                            ? null
                            : () async {
                                if (_formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  setState(() => _busy = true);
                                  final navigator = Navigator.of(context);
                                  final habitService = Provider.of<HabitService>(context, listen: false);
                                  final values = _formKey.currentState!.value;
                                  try {
                                    final habit = Habit(
                                      userId: widget.userId,
                                      title: values['title'],
                                      notes: values['notes'] ?? '',
                                      frequency: values['frequency'] ?? 'daily',
                                    );
                                    debugPrint('Creating habit: ${habit.title} for user: ${widget.userId}');
                                    final id = await habitService.createHabit(habit);
                                    debugPrint('Habit created with ID: $id');
                                    if (!mounted) return;
                                    setState(() => _busy = false);
                                    navigator.pop();
                                  } catch (e) {
                                    debugPrint('Error creating habit: $e');
                                    if (!mounted) return;
                                    setState(() => _busy = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error creating habit: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 400.ms)
                        .moveY(begin: 20, end: 0, duration: 400.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).moveY(begin: 50, end: 0, duration: 400.ms);
  }
}
