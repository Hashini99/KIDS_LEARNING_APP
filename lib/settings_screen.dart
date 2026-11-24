import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';
import 'package:kids_learning_app/widgets/parent_gate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressService>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        title: Text('Settings', style: AppTheme.heading(fontSize: 24)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Sound Effects', style: AppTheme.title(fontSize: 18)),
                  secondary: const Icon(Icons.volume_up, color: Colors.deepOrange),
                  value: progress.soundOn,
                  onChanged: (v) => progress.setSoundOn(v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text('Voice Narration', style: AppTheme.title(fontSize: 18)),
                  secondary: const Icon(Icons.record_voice_over, color: Colors.deepOrange),
                  value: progress.ttsOn,
                  onChanged: (v) => progress.setTtsOn(v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionCard(
            child: ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.redAccent),
              title: Text('Reset Progress', style: AppTheme.title(fontSize: 18, color: Colors.redAccent)),
              subtitle: const Text('Clears all stars, streaks, and badges'),
              onTap: () => _confirmReset(context),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text('Kiddo Learn · v1.0', style: AppTheme.body(fontSize: 14, color: Colors.black45)),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final approved = await ParentGate.check(context);
    if (!approved || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<ProgressService>().resetProgress();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Progress reset')));
      }
    }
  }
}
