import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_learning_app/learn_english_letters.dart';
import 'package:kids_learning_app/learning_animals.dart';
import 'package:kids_learning_app/learning_color.dart';
import 'package:kids_learning_app/learning_shapes.dart';
import 'package:kids_learning_app/number_learning_screen.dart';
import 'package:kids_learning_app/story_screen.dart';

class LearningHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Kids Learning',
          style: GoogleFonts.baloo2(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/kids_bg.png'),
            fit: BoxFit.cover, 
          ),
        ),
     child: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Text(
      //   'Welcome to the Learning World!',
      //   style: GoogleFonts.baloo2(
      //     fontSize: 28,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //   ),
      // ),
      SizedBox(height: 30),
      SizedBox(
        width: 250,
        child: AnimatedButton(
          label: 'Learn Colors',
          icon: Icons.color_lens,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ColorLearningScreen()),
            );
          },
        ),
      ),
      SizedBox(height: 20),
      SizedBox(
        width: 250,
        child: AnimatedButton(
          label: 'Learn Numbers',
          icon: Icons.numbers,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NumberLearningApp()),
            );
          },
        ),
      ),
      SizedBox(height: 20),
      SizedBox(
        width: 250,
        child: AnimatedButton(
          label: 'Learn Alphabets',
          icon: Icons.book,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LearnAlphabetScreen()),
            );
          },
        ),
      ),
    ],
  ),
),

      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const AnimatedButton({
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
