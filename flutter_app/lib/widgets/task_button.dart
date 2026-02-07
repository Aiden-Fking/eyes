import 'package:flutter/material.dart';
import '../models/training_task.dart';

class TaskButton extends StatelessWidget {
  final TrainingTask task;
  final VoidCallback onTap;
  final Color color;

  const TaskButton({
    super.key,
    required this.task,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onTap,
        child: Text('${task.emoji} ${task.title}'),
      ),
    );
  }
}
