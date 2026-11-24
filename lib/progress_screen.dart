import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const Map<String, Color> _topicColors = {
    'colors': AppTheme.colors,
    'numbers': AppTheme.numbers,
    'letters': AppTheme.letters,
    'shapes': AppTheme.shapes,
    'animals': AppTheme.animals,
    'stories': AppTheme.stories,
  };

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressService>();
    final maxStars = progress.starsByTopic.values.fold<int>(1, (max, v) => v > max ? v : max);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        title: Text('My Progress', style: AppTheme.heading(fontSize: 24)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 32),
              const SizedBox(width: 8),
              Text('${progress.totalStars} total stars', style: AppTheme.title(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_fire_department, color: Colors.orange, size: 26),
              const SizedBox(width: 6),
              Text('${progress.currentStreak} day streak (best ${progress.longestStreak})',
                  style: AppTheme.body(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 28),
          Text('Stars by topic', style: AppTheme.title(fontSize: 20)),
          const SizedBox(height: 12),
          ...ProgressService.topics.map((topic) {
            final stars = progress.starsByTopic[topic] ?? 0;
            final color = _topicColors[topic] ?? Colors.grey;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ProgressService.topicLabels[topic] ?? topic, style: AppTheme.body(fontSize: 16, weight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: stars / maxStars,
                      minHeight: 14,
                      backgroundColor: color.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('$stars stars', style: AppTheme.body(fontSize: 13, color: Colors.black54)),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          Text('Badges', style: AppTheme.title(fontSize: 20)),
          const SizedBox(height: 12),
          if (progress.badges.isEmpty)
            Text('Keep playing to earn your first badge!', style: AppTheme.body(fontSize: 15, color: Colors.black54))
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: progress.badges.map((badgeId) {
                return Chip(
                  label: Text(ProgressService.badgeLabels[badgeId] ?? badgeId, style: AppTheme.body(fontSize: 15)),
                  backgroundColor: Colors.amber.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
