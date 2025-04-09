
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
  List<Offset?> points = []; // Points for drawing the number

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

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      points.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    points.add(null); // End the drawing stroke
  }

  void _clearDrawing() {
    setState(() {
      points.clear();
    });
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
          // Scrollable content area (Number selection, buttons, etc.)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                        SizedBox(height: 20),
                        Text(
                          'Write the number below!',
                          style: GoogleFonts.comicNeue(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _clearDrawing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text(
                      'Clear Drawing',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fixed drawing area at the bottom of the screen
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.pinkAccent, width: 2),
              boxShadow: [
                BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5)),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                size: Size(300, 150), // Fixed size for the drawing area
                painter: NumberDrawingPainter(points),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NumberDrawingPainter extends CustomPainter {
  final List<Offset?> points;
  NumberDrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawCircle(points[i]!, 5.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
