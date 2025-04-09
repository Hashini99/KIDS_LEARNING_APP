

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_learning_app/learn_english_letters.dart';
import 'package:kids_learning_app/learning_animals.dart';
import 'package:kids_learning_app/learning_color.dart';
import 'package:kids_learning_app/learning_shapes.dart';
import 'package:kids_learning_app/number_learning_screen.dart';
import 'package:kids_learning_app/story_screen.dart';

// import 'package:lottie/lottie.dart';

class LearningHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
         image: DecorationImage(
      image: AssetImage('assets/kids_bg.png'),
      fit: BoxFit.fill, 
    ),
        ),
        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Fun Animation
              // Lottie.asset('assets/animations/kids_animation.json', width: 200, height: 200),
              
              // Fun Header Text
              Text(
                'Welcome to the Learning World!',
                 style: GoogleFonts.baloo2(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
              ),
              SizedBox(height: 30),
              
              // Learn Colors Button
              AnimatedButton(
                label: 'Learn Colors',
                icon: Icons.color_lens,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ColorLearningScreen()),
                  );
                },
              ),
              // SizedBox(height: 20),
              
              // // Learn Shapes Button
              // AnimatedButton(
              //   label: 'Learn Shapes',
              //   icon: Icons.shape_line,
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => ShapeLearningScreen()),
              //     );
              //   },
              // ),
                     SizedBox(height: 20),
                 AnimatedButton(
                label: 'Learn Numbers',
                icon: Icons.numbers,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NumberLearningApp()),
                  );
                },
              ),
            SizedBox(height: 20),
              // Learn Animals Button
              AnimatedButton(
                label: 'Learn Alphabets',
                icon: Icons.book,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnAlphabetScreen()),
                  );
                },
              ),
                 SizedBox(height: 20),
              // Learn Animals Button
              AnimatedButton(
                label: 'Stories',
                icon: Icons.pets,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StoryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Animated Button Widget
class AnimatedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  AnimatedButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.6),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Comic Sans MS',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
