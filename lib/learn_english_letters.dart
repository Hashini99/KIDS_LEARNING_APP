import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/services/audio_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';

class LearnAlphabetScreen extends StatefulWidget {
  const LearnAlphabetScreen({super.key});

  @override
  State<LearnAlphabetScreen> createState() => _LearnAlphabetScreenState();
}

class _LearnAlphabetScreenState extends State<LearnAlphabetScreen> {
  late AudioService _audio;
  String selectedLetter = 'A';
  List<Offset?> points = [];
  late Path path;

  final Map<String, String> letterToWord = {
    'A': 'Apple 🍎',
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
    _audio = AudioService(context.read<ProgressService>());
    path = Path();
    _speakLetter();
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  Future<void> _speakLetter() async {
    final word = letterToWord[selectedLetter] ?? '';
    final pureWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
    await _audio.speak('$selectedLetter for $pureWord', pitch: 1.3, rate: 0.45);
  }

  void _onLetterTap(String letter) async {
    setState(() {
      selectedLetter = letter;
      points.clear();
      path = Path();
    });
    _speakLetter();

    final progress = context.read<ProgressService>();
    final key = 'letter_$letter';
    if (!progress.hasPracticedToday(key)) {
      await progress.markPracticedToday(key);
      await progress.addStars('letters', 5);
    }
  }

  void _clearDrawing() {
    setState(() {
      points.clear();
      path = Path();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stars = context.watch<ProgressService>().starsByTopic['letters'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: AppTheme.letters,
        title: Text('Learn Alphabets', style: AppTheme.heading(fontSize: 26, color: Colors.white)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              const Icon(Icons.star, color: Colors.yellow, size: 24),
              const SizedBox(width: 4),
              Text('$stars', style: AppTheme.title(fontSize: 18, color: Colors.white)),
            ]),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: GridView.count(
              crossAxisCount: 6,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: letterToWord.keys.map((letter) {
                return GestureDetector(
                  onTap: () => _onLetterTap(letter),
                  child: CircleAvatar(
                    backgroundColor: selectedLetter == letter ? AppTheme.letters : Colors.orangeAccent,
                    child: Text(letter, style: const TextStyle(fontSize: 22, color: Colors.white)),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orangeAccent, width: 4),
              boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(selectedLetter, style: AppTheme.heading(fontSize: 40, color: AppTheme.letters)),
                    Text(letterToWord[selectedLetter]?.split(' ').last ?? '', style: const TextStyle(fontSize: 50)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  letterToWord[selectedLetter] ?? '',
                  style: AppTheme.body(fontSize: 24, weight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition);
                path.lineTo(details.localPosition.dx, details.localPosition.dy);
              });
            },
            onPanEnd: (_) {
              setState(() {
                points.add(null);
                path = Path();
              });
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.orangeAccent, width: 2)),
              child: CustomPaint(painter: LetterPainter(points)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _speakLetter,
                icon: const Icon(Icons.volume_up, color: Colors.white),
                label: const Text('Say it again!', style: TextStyle(fontSize: 20)),
                style: AppTheme.pillButton(AppTheme.letters),
              ),
              ElevatedButton(
                onPressed: _clearDrawing,
                style: AppTheme.pillButton(Colors.redAccent),
                child: const Text('Clear', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
