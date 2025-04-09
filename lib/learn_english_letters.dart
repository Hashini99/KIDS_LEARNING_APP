import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnAlphabetScreen extends StatefulWidget {
  @override
  _LearnAlphabetScreenState createState() => _LearnAlphabetScreenState();
}

class _LearnAlphabetScreenState extends State<LearnAlphabetScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLetter = 'A';
  List<Offset?> points = [];

  final Map<String, String> letterToWord = {
    'A': 'Ant 🐜',
    'B': 'Bee 🐝',
    'C': 'Cat 🐱',
    'D': 'Dog 🐶',
    'E': 'Elephant 🐘',
    'F': 'Fish 🐟',
    'G': 'Giraffe 🦒',
    'H': 'Hat 🎩',
    'I': 'Ice cream 🍦',
    'J': 'Jelly 🍬',
    'K': 'Kite 🪁',
    'L': 'Lion 🦁',
    'M': 'Monkey 🐵',
    'N': 'Nest 🪺',
    'O': 'Owl 🦉',
    'P': 'Penguin 🐧',
    'Q': 'Queen 👑',
    'R': 'Rabbit 🐰',
    'S': 'Sun ☀️',
    'T': 'Tiger 🐯',
    'U': 'Umbrella ☂️',
    'V': 'Violin 🎻',
    'W': 'Whale 🐳',
    'X': 'Xylophone 🎼',
    'Y': 'Yoyo 🪀',
    'Z': 'Zebra 🦓',
  };

  @override
  void initState() {
    super.initState();
    _configureTts();
    _speakLetter();
  }

  void _configureTts() {
    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.3);
    flutterTts.setSpeechRate(0.45);
  }

  Future<void> _speakLetter() async {
    final word = letterToWord[selectedLetter] ?? '';
    final pureWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
    await flutterTts.speak('$selectedLetter for $pureWord');
  }

  void _onLetterTap(String letter) {
    setState(() {
      selectedLetter = letter;
      points.clear();
    });
    _speakLetter();
  }

  void _clearDrawing() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'Learn Alphabets',
          style: GoogleFonts.fredoka(fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Tap a Letter!',
            style: GoogleFonts.comicNeue(fontSize: 24),
          ),
          SizedBox(height: 8),
          Expanded(
            child: GridView.count(
              crossAxisCount: 6,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: letterToWord.keys.map((letter) {
                return GestureDetector(
                  onTap: () => _onLetterTap(letter),
                  child: CircleAvatar(
                    backgroundColor: selectedLetter == letter
                        ? Colors.deepOrangeAccent
                        : Colors.orangeAccent,
                    child: Text(
                      letter,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      
          Container(
  margin: EdgeInsets.symmetric(horizontal: 30),
  padding: EdgeInsets.all(4),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.orangeAccent, width: 4),
    boxShadow: [
      BoxShadow(
        color: Colors.deepOrange.withOpacity(0.2),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        
          Column(
            children: [
              Text(
                selectedLetter,  
                style: GoogleFonts.fredoka(
                  fontSize: 50,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ],
          ),
 
          Column(
            children: [
              Text(
                selectedLetter == 'A' ? '🍎' : '', 
                style: TextStyle(fontSize: 40),
              ),
            ],
          ),
 
          Column(
            children: [
              Text(
                letterToWord[selectedLetter] ?? '',  
                style: GoogleFonts.comicNeue(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
),

          SizedBox(height: 20),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition);
              });
            },
            onPanEnd: (_) {
              setState(() {
                points.add(null); // End the current stroke
              });
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orangeAccent, width: 2),
              ),
              child: CustomPaint(
                painter: LetterPainter(points),
              ),
            ),
          ),
          SizedBox(height: 20),
         

          Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
  children: [
    // First button: "Say it again!"
    ElevatedButton.icon(
      onPressed: _speakLetter,
      icon: Icon(Icons.volume_up, color: Colors.white),
      label: Text(
        'Say it again!',
        style: TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
    ),
    
    // Second button: "Clear"
    ElevatedButton(
      onPressed: _clearDrawing,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: Text(
        'Clear',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  ],
),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class LetterPainter extends CustomPainter {
  final List<Offset?> points;
  LetterPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawCircle(points[i]!, 3.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
