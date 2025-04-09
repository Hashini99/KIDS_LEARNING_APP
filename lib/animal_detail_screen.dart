import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class AnimalDetailScreen extends StatefulWidget {
  final Map<String, String> animal;

  AnimalDetailScreen({required this.animal});

  @override
  _AnimalDetailScreenState createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _scaleAnimation;
  late Animation _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat the animation for a continuous effect

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _colorAnimation = ColorTween(begin: Colors.orange, end: Colors.pink).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(
          'Meet the ${widget.animal['name']}!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fun Animated Animal Emoji with increased size
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: Text(
                        widget.animal['emoji']!,
                        style: TextStyle(
                          fontSize: 200,  // Increased size for visibility
                          color: _colorAnimation.value,
                        ),
                        key: ValueKey<String>(widget.animal['name']!),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Fun, Simple Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello! I am a ${widget.animal['name']}!',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _getAnimalText(widget.animal['name']!),
                      style: TextStyle(fontSize: 22, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 20),
                    // Fun Playful Button
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(_getAnimalSound(widget.animal['name']!)),
                          backgroundColor: Colors.orange,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Let\'s See More About Me!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Swipe Interaction for Next Animal
                    _AnimalSwipeWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Return dynamic text based on animal type
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

  // Return playful sound/interaction text based on animal type
  String _getAnimalSound(String animalName) {
    switch (animalName.toLowerCase()) {
      case 'lion':
        return 'Roar! 🦁';
      case 'elephant':
        return 'Trumpet sound! 🐘';
      case 'tiger':
        return 'Grrr! 🐅';
      case 'rabbit':
        return 'Hop Hop! 🐰';
      default:
        return 'I make a fun sound!';
    }
  }
}

class _AnimalSwipeWidget extends StatefulWidget {
  @override
  __AnimalSwipeWidgetState createState() => __AnimalSwipeWidgetState();
}

class __AnimalSwipeWidgetState extends State<_AnimalSwipeWidget> {
  // This will simulate the swipe functionality
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 0) {
          // Swipe left to go to next animal
          _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        } else {
          // Swipe right to go to previous animal
          _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: [
          // Example of two pages with animals, more can be added
          _AnimalDetailCard(animalName: 'Lion', animalEmoji: '🦁'),
          _AnimalDetailCard(animalName: 'Elephant', animalEmoji: '🐘'),
        ],
      ),
    );
  }
}

class _AnimalDetailCard extends StatelessWidget {
  final String animalName;
  final String animalEmoji;

  _AnimalDetailCard({required this.animalName, required this.animalEmoji});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            animalName,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            animalEmoji,
            style: TextStyle(fontSize: 150),
          ),
          SizedBox(height: 20),
          Text(
            'Swipe left or right to see more animals!',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
