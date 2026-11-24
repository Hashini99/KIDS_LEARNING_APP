import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/services/audio_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';

class ColorLearningScreen extends StatefulWidget {
  const ColorLearningScreen({super.key});

  @override
  State<ColorLearningScreen> createState() => _ColorLearningScreenState();
}

class _ColorLearningScreenState extends State<ColorLearningScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> colors = [
    {'name': 'Red', 'color': Colors.red, 'example': 'Apple'},
    {'name': 'Blue', 'color': Colors.blue, 'example': 'Sky'},
    {'name': 'Green', 'color': Colors.green, 'example': 'Grass'},
    {'name': 'Yellow', 'color': Colors.yellow, 'example': 'Banana'},
    {'name': 'Purple', 'color': Colors.purple, 'example': 'Grape'},
    {'name': 'Orange', 'color': Colors.orange, 'example': 'Carrot'},
    {'name': 'Pink', 'color': Colors.pink, 'example': 'Flower'},
    {'name': 'Brown', 'color': Colors.brown, 'example': 'Chocolate'},
  ];

  late Map<String, dynamic> currentColor;
  bool showSuccess = false;

  late AudioService _audio;
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 3));

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _audio = AudioService(context.read<ProgressService>());

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 25).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _generateNewColor();
  }

  void _generateNewColor() {
    setState(() {
      currentColor = colors[Random().nextInt(colors.length)];
      showSuccess = false;
    });
    _speakColor();
  }

  void _speakColor() {
    _audio.speak(
      "${currentColor['name']}! Like a big ${currentColor['example']}. Can you find the ${currentColor['name']} color?",
      pitch: 1.3,
      rate: 0.9,
    );
  }

  void _onColorSelected(Map<String, dynamic> selected) async {
    if (selected == currentColor) {
      setState(() => showSuccess = true);
      await context.read<ProgressService>().addStars('colors', 10);

      await _audio.playSfx('success.mp3');
      _confettiController.play();
      _bounceController.forward().then((_) => _bounceController.reverse());

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _generateNewColor();
      });
    } else {
      await _audio.playSfx('out.mp3');
      await _audio.speak("Oops! That's ${selected['name']}. Try again!");
    }
  }

  @override
  void dispose() {
    _audio.dispose();
    _confettiController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stars = context.watch<ProgressService>().starsByTopic['colors'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('🎨 Learn Colors', style: AppTheme.heading(fontSize: 26, color: Colors.white)),
        backgroundColor: AppTheme.colors,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 28),
                const SizedBox(width: 6),
                Text('$stars', style: AppTheme.title(fontSize: 22, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fun Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF3E0), Color(0xFFE3F2FD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Mascot
                  AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, -_bounceAnimation.value),
                      child: child,
                    ),
                    child: Image.asset('assets/bear.png', height: 110),
                  ),

                  const SizedBox(height: 10),

                  // Instruction
                  Text(
                    "Find the ${currentColor['name']} color!",
                    style: AppTheme.title(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),

                  Text(
                    "Like a ${currentColor['example']}",
                    style: AppTheme.body(fontSize: 22, color: Colors.black54),
                  ),

                  const SizedBox(height: 40),

                  // Big Color Display (Target)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: currentColor['color'],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 8),
                      boxShadow: [
                        BoxShadow(
                          color: currentColor['color'].withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Color Choices Grid
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: colors.map((colorOption) {
                      final bool isTarget = colorOption == currentColor;
                      return GestureDetector(
                        onTap: () => _onColorSelected(colorOption),
                        child: AnimatedScale(
                          scale: showSuccess && isTarget ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              color: colorOption['color'],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isTarget ? Colors.white : Colors.transparent,
                                width: 6,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // Success Message
                  if (showSuccess)
                    Column(
                      children: [
                        Text(
                          '🎉 Amazing! That\'s ${currentColor['name']} 🎉',
                          style: AppTheme.title(fontSize: 28, color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                        Text('+10 Stars', style: AppTheme.title(fontSize: 20, color: Colors.orange)),
                      ],
                    ),

                  const SizedBox(height: 20),
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
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 40,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
