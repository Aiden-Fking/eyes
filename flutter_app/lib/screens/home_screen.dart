import 'package:flutter/material.dart';
import '../models/training_task.dart';
import '../widgets/task_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double progress = 0;
  String status = '尚未开始，建议训练 15 分钟。';

  final tasks = const [
    TrainingTask(title: '立体视小火箭', emoji: '🚀', minutes: 5),
    TrainingTask(title: '弱视追踪赛', emoji: '🎯', minutes: 5),
    TrainingTask(title: '远近调节跳跳乐', emoji: '🌈', minutes: 5),
  ];

  void startTask(TrainingTask task, int step) {
    setState(() {
      progress = (step / tasks.length).clamp(0, 1);
      status = step >= tasks.length
          ? '已完成：${task.title}。太棒了，今天训练完成！'
          : '正在训练：${task.title}，继续加油！';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👀 Eyes 训练营')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('今天也来保护眼睛吧！', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (var i = 0; i < tasks.length; i++) ...[
              TaskButton(
                task: tasks[i],
                color: [Colors.blue, Colors.orange, Colors.green][i],
                onTap: () => startTask(tasks[i], i + 1),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, minHeight: 16, borderRadius: BorderRadius.circular(100)),
            const SizedBox(height: 8),
            Text(status),
            const SizedBox(height: 16),
            const Text(
              '本应用用于视觉训练辅助与习惯管理，不能替代专业医生诊断。',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}
