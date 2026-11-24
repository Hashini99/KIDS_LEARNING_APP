import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:kids_learning_app/learn_english_letters.dart';
import 'package:kids_learning_app/learning_animals.dart';
import 'package:kids_learning_app/learning_color.dart';
import 'package:kids_learning_app/learning_shapes.dart';
import 'package:kids_learning_app/number_learning_screen.dart';
import 'package:kids_learning_app/story_screen.dart';
import 'package:kids_learning_app/progress_screen.dart';
import 'package:kids_learning_app/settings_screen.dart';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';
import 'package:kids_learning_app/widgets/parent_gate.dart';

class LearningHome extends StatefulWidget {
  const LearningHome({super.key});

  @override
  State<LearningHome> createState() => _LearningHomeState();
}

class _LearningHomeState extends State<LearningHome> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _openStories(BuildContext context) async {
    final approved = await ParentGate.check(context);
    if (approved && context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => StoryScreen()));
    }
  }

  Future<void> _openSettings(BuildContext context) async {
    final approved = await ParentGate.check(context);
    if (approved && context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressService>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Kiddo Learn', style: AppTheme.heading(fontSize: 28)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            tooltip: 'My Progress',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Settings',
            onPressed: () => _openSettings(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 28),
                const SizedBox(width: 4),
                Text('${progress.totalStars}', style: AppTheme.title(fontSize: 20, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/kids_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // Welcome + Mascot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/bear.png', width: 70, height: 70),
                      const SizedBox(width: 12),
                      Text('Hi Little Friend! 👋', style: AppTheme.heading(fontSize: 26)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Buttons Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1.1,
                      children: [
                        _buildMenuCard(
                          title: 'Learn Colors',
                          icon: Icons.color_lens,
                          color: AppTheme.colors,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ColorLearningScreen())),
                        ),
                        _buildMenuCard(
                          title: 'Learn Numbers',
                          icon: Icons.numbers,
                          color: AppTheme.numbers,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NumberLearningScreen())),
                        ),
                        _buildMenuCard(
                          title: 'Learn Alphabets',
                          icon: Icons.abc,
                          color: AppTheme.letters,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LearnAlphabetScreen())),
                        ),
                        _buildMenuCard(
                          title: 'Stories',
                          icon: Icons.menu_book,
                          color: AppTheme.stories,
                          isLocked: true,
                          onTap: () => _openStories(context),
                        ),
                        _buildMenuCard(
                          title: 'Shapes',
                          icon: Icons.category,
                          color: AppTheme.shapes,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShapeLearningScreen())),
                        ),
                        _buildMenuCard(
                          title: 'Animals',
                          icon: Icons.pets,
                          color: AppTheme.animals,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnimalLearningScreen())),
                        ),
                      ],
                    ),
                  ),

                  // Daily Streak Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
                        const SizedBox(width: 8),
                        Text(
                          '${progress.currentStreak} Day Streak 🔥',
                          style: AppTheme.title(fontSize: 20, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.card(color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTheme.title(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            if (isLocked)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.lock, color: Colors.white70, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
