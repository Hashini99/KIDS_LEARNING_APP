import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/services/audio_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';

class AnimalDetailScreen extends StatefulWidget {
  final List<Map<String, String>> animals;
  final int initialIndex;

  const AnimalDetailScreen({super.key, required this.animals, required this.initialIndex});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late AudioService _audio;
  late int _currentIndex;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _audio = AudioService(context.read<ProgressService>());

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _colorAnimation = ColorTween(begin: Colors.orange, end: Colors.pink).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) => _announce(_currentIndex));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audio.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _announce(int index) async {
    final animal = widget.animals[index];
    final name = animal['name']!;
    await _audio.speak('$name. ${_getAnimalText(name)}');
    if (!mounted) return;

    final progress = context.read<ProgressService>();
    final key = 'animal_$name';
    if (!progress.hasPracticedToday(key)) {
      await progress.markPracticedToday(key);
      await progress.addStars('animals', 5);
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _announce(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text('Meet the Animals!', style: AppTheme.heading(fontSize: 22, color: Colors.white)),
        backgroundColor: AppTheme.animals,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.animals.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final animal = widget.animals[index];
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Text(
                      animal['emoji']!,
                      style: TextStyle(fontSize: 180, color: index == _currentIndex ? _colorAnimation.value : null),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello! I am a ${animal['name']}!', style: AppTheme.title(fontSize: 30, color: AppTheme.animals)),
                      const SizedBox(height: 10),
                      Text(_getAnimalText(animal['name']!), style: AppTheme.body(fontSize: 22)),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _audio.speak(_getAnimalSound(animal['name']!)),
                          icon: const Icon(Icons.volume_up),
                          style: AppTheme.pillButton(AppTheme.animals),
                          label: const Text('Hear my sound!', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text('Swipe left or right to meet another animal!', style: AppTheme.body(fontSize: 14, color: Colors.black45)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getAnimalText(String animalName) {
    switch (animalName.toLowerCase()) {
      case 'lion':
        return 'I live in the jungle and love to ROAR!';
      case 'elephant':
        return 'I have big ears and a long trunk!';
      case 'tiger':
        return 'I love to sneak and roar very loudly!';
      case 'rabbit':
        return 'I hop around and love to eat carrots!';
      default:
        return 'I am a beautiful animal with special abilities!';
    }
  }

  String _getAnimalSound(String animalName) {
    switch (animalName.toLowerCase()) {
      case 'lion':
        return 'Roar!';
      case 'elephant':
        return 'Trumpet sound!';
      case 'tiger':
        return 'Grrr!';
      case 'rabbit':
        return 'Hop Hop!';
      default:
        return 'I make a fun sound!';
    }
  }
}
