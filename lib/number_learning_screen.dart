import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(NumberLearningApp());

class NumberLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Number Learning',
      debugShowCheckedModeBanner: false,
      home: NumberLearningScreen(),
    );
  }
}

class NumberLearningScreen extends StatefulWidget {
  @override
  _NumberLearningScreenState createState() => _NumberLearningScreenState();
}

class _NumberLearningScreenState extends State<NumberLearningScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int selectedNumber = 1;

  @override
  void initState() {
    super.initState();
    _configureTts();
    _speakNumber();
  }

  void _configureTts() {
    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.2);
    flutterTts.setSpeechRate(0.4);
  }

  Future<void> _speakNumber() async {
    String emojiName = getEmojiName(selectedNumber);
    String spokenText =
        '$selectedNumber ${emojiName}${selectedNumber > 1 ? 's' : ''}';
    await flutterTts.speak(spokenText);
  }

  String getEmojiForNumber(int number) {
    switch (number) {
      case 1:
        return '🐶';
      case 2:
        return '🍎';
      case 3:
        return '🌟';
      case 4:
        return '🎈';
      case 5:
        return '🐥';
      case 6:
        return '🧁';
      case 7:
        return '🚗';
      case 8:
        return '🍉';
      case 9:
        return '🐼';
      case 10:
        return '🧸';
      default:
        return '❓';
    }
  }

  String getEmojiName(int number) {
    switch (number) {
      case 1:
        return 'dog';
      case 2:
        return 'apple';
      case 3:
        return 'star';
      case 4:
        return 'balloon';
      case 5:
        return 'chick';
      case 6:
        return 'cupcake';
      case 7:
        return 'car';
      case 8:
        return 'watermelon';
      case 9:
        return 'panda';
      case 10:
        return 'teddy bear';
      default:
        return 'item';
    }
  }

  void _onNumberTap(int number) {
    setState(() {
      selectedNumber = number;
    });
    _speakNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          'Learn Numbers',
          style: GoogleFonts.baloo2(fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Tap a number!',
            style: GoogleFonts.comicNeue(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: List.generate(10, (index) {
              int num = index + 1;
              return GestureDetector(
                onTap: () => _onNumberTap(num),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor:
                      selectedNumber == num ? Colors.blueAccent : Colors.pinkAccent,
                  child: Text(
                    '$num',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.pinkAccent, width: 4),
              boxShadow: [
                BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5)),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$selectedNumber',
                  style: GoogleFonts.baloo2(
                    fontSize: 100,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                Text(
                  getEmojiName(selectedNumber),
                  style: GoogleFonts.comicNeue(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: List.generate(selectedNumber, (index) {
                    return Text(
                      getEmojiForNumber(selectedNumber),
                      style: TextStyle(fontSize: 40),
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _speakNumber,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: StadiumBorder(),
              elevation: 4,
            ),
            icon: Icon(Icons.volume_up_rounded, color: Colors.black87),
            label: Text(
              "Hear Again!",
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
