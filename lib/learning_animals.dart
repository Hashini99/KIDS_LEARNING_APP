import 'package:flutter/material.dart';
import 'package:kids_learning_app/animal_detail_screen.dart';
import 'package:kids_learning_app/theme/app_theme.dart';

class AnimalLearningScreen extends StatelessWidget {
  const AnimalLearningScreen({super.key});

  static const List<Map<String, String>> animals = [
    {'name': 'Lion', 'emoji': '🦁'},
    {'name': 'Elephant', 'emoji': '🐘'},
    {'name': 'Cat', 'emoji': '🐱'},
    {'name': 'Dog', 'emoji': '🐶'},
    {'name': 'Tiger', 'emoji': '🐯'},
    {'name': 'Monkey', 'emoji': '🐒'},
    {'name': 'Bear', 'emoji': '🐻'},
    {'name': 'Cow', 'emoji': '🐄'},
    {'name': 'Horse', 'emoji': '🐎'},
    {'name': 'Bird', 'emoji': '🦜'},
    {'name': 'Fish', 'emoji': '🐟'},
    {'name': 'Duck', 'emoji': '🦆'},
    {'name': 'Frog', 'emoji': '🐸'},
    {'name': 'Rabbit', 'emoji': '🐰'},
    {'name': 'Koala', 'emoji': '🐨'},
    {'name': 'Snake', 'emoji': '🐍'},
    {'name': 'Panda', 'emoji': '🐼'},
    {'name': 'Giraffe', 'emoji': '🦒'},
    {'name': 'Wolf', 'emoji': '🐺'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Animals', style: AppTheme.heading(fontSize: 26, color: Colors.white)),
        backgroundColor: AppTheme.animals,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: animals.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimalDetailScreen(animals: animals, initialIndex: index),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                decoration: BoxDecoration(
                  color: AppTheme.animals,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(animals[index]['emoji']!, style: const TextStyle(fontSize: 60)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
