import 'package:flutter/material.dart';
import 'package:kids_learning_app/animal_detail_screen.dart';


class AnimalLearningScreen extends StatelessWidget {
  // List of animals with emojis
  final List<Map<String, String>> animals = [
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
        title: Text(
          'Learn Animals',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: animals.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to animal detail screen when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimalDetailScreen(animal: animals[index]),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.elasticOut,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    animals[index]['emoji']!,
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
