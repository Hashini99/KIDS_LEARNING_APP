
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class ColorLearningScreen extends StatefulWidget {
  @override
  _ColorLearningScreenState createState() => _ColorLearningScreenState();
}

class _ColorLearningScreenState extends State<ColorLearningScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> colors = [
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Orange', 'color': Colors.orange},
  ];

  late Map<String, dynamic> targetColor;
  late List<Map<String, dynamic>> options;
  bool isCorrect = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 2));
  final FlutterTts _flutterTts = FlutterTts();

  // Panda Animation
  late AnimationController _animationController;
  late Animation<double> _pandaBounce;

  @override
  void initState() {
    super.initState();
    _generateNewChallenge();
                                               
    // Initialize Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Define bounce animation
    _pandaBounce = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _generateNewChallenge() {
    setState(() {
      targetColor = colors[Random().nextInt(colors.length)];
      options = [...colors]..shuffle();
      options = options.sublist(0, 3);
      if (!options.contains(targetColor)) {
        options[Random().nextInt(3)] = targetColor;
      }
      _speakInstruction();
    });
  }
                                                                                
  void _speakInstruction() async {
    await _flutterTts.setPitch(1.5);
    await _flutterTts.speak("Can you tap the ${targetColor['name']} circle? ");
  }

  void _onColorTapped(Map<String, dynamic> selectedColor) async {
    if (selectedColor == targetColor) {
      setState(() => isCorrect = true);
      await _audioPlayer.play(AssetSource('success.mp3'));
      _confettiController.play();

      // Start Panda Bounce
      _animationController.forward().then((_) => _animationController.reverse());

      Future.delayed(Duration(seconds: 2), () {
        setState(() => isCorrect = false);
        _generateNewChallenge();
      });
    } else {
      await _audioPlayer.play(AssetSource('out.mp3'));
      _flutterTts.speak("Oops! Try again! ");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    _flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🎨 Learn Colors!',
          style: GoogleFonts.baloo2(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, size: 30, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Animated Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // colors: [Colors.pink.shade100, Colors.blue.shade300],
                  colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Panda Mascot with Animation
                AnimatedBuilder(
                  animation: _pandaBounce,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_pandaBounce.value),
                      child: child,
                    );
                  },
                  // child: Text(
                  //   isCorrect ? '🐼🎉' : '🐼🙃',
                  //   style: TextStyle(fontSize: 100),
                  // ),
child: isCorrect
    ? Image.asset(
        'assets/happy.gif',
        height: 150,
        width: 150,
      )
    : SizedBox(height: 150, width: 150), // or a different widget


                ),

                SizedBox(height: 20),

                // Instruction text
                Text(
                  ' Tap the ${targetColor['name']} Circle!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
              
                // Color choices
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: options.map((colorOption) {
                    return GestureDetector(
                      onTap: () => _onColorTapped(colorOption),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: isCorrect ? 130 : 110,
                        width: isCorrect ? 130 : 110,
                        decoration: BoxDecoration(
                          color: colorOption['color'],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 40),

                // Reward Animation
                isCorrect
                    ? Column(
                        children: [
                          Text(
                            '🎉 Yay! You got it! 🎉',
                            style: GoogleFonts.baloo2(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          Icon(Icons.star, color: Colors.yellow, size: 60),
                        ],
                      )
                    : SizedBox(),

                SizedBox(height: 20),

                // Restart Button

Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.purpleAccent, Colors.orangeAccent],
    ),
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(color: Colors.deepPurple, blurRadius: 10, offset: Offset(2, 4)),
    ],
  ),
  child: MaterialButton(
    onPressed: _generateNewChallenge,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: Text(
      '✨ Try Again!',
      style: GoogleFonts.balooBhai2(
        fontSize: 22,
        color: Colors.white,
      ),
    ),
  ),
),



                // ElevatedButton(
                //   onPressed: _generateNewChallenge,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blueAccent,
                //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                //   child: Text(
                //     '🔄 Try Another!',
                //     style: GoogleFonts.comicNeue(
                //       fontSize: 22,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // Confetti effect
          // Positioned.fill(
          //   child: ConfettiWidget(
          //     confettiController: _confettiController,
          //     blastDirection: pi / 2,
          //     numberOfParticles: 60,
          //     shouldLoop: false,

      
          //     colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow],
          //   ),
          // ),
        ],
      ),
    );
  }
}
