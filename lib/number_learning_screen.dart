import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/services/audio_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';

class NumberLearningScreen extends StatefulWidget {
  const NumberLearningScreen({super.key});

  @override
  State<NumberLearningScreen> createState() => _NumberLearningScreenState();
}

class _NumberLearningScreenState extends State<NumberLearningScreen> {
  late AudioService _audio;
  int selectedNumber = 1;
  List<Offset?> points = [];

  @override
  void initState() {
    super.initState();
    _audio = AudioService(context.read<ProgressService>());
    _speakNumber();
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  Future<void> _speakNumber() async {
    final emojiName = getEmojiName(selectedNumber);
    final spokenText = '$selectedNumber $emojiName${selectedNumber > 1 ? 's' : ''}';
    await _audio.speak(spokenText, pitch: 1.2, rate: 0.4);
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

  void _onNumberTap(int number) async {
    setState(() {
      selectedNumber = number;
      points.clear();
    });
    _speakNumber();

    final progress = context.read<ProgressService>();
    final key = 'number_$number';
    if (!progress.hasPracticedToday(key)) {
      await progress.markPracticedToday(key);
      await progress.addStars('numbers', 5);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() => points.add(details.localPosition));
  }

  void _onPanEnd(DragEndDetails details) {
    points.add(null);
  }

  void _clearDrawing() {
    setState(() => points.clear());
  }

  @override
  Widget build(BuildContext context) {
    final stars = context.watch<ProgressService>().starsByTopic['numbers'] ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.numbers,
        title: Text('Learn Numbers', style: AppTheme.heading(fontSize: 26, color: Colors.white)),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text('Tap a number!', style: AppTheme.body(fontSize: 24, weight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: List.generate(10, (index) {
                      final num = index + 1;
                      return GestureDetector(
                        onTap: () => _onNumberTap(num),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: selectedNumber == num ? Colors.deepPurpleAccent : AppTheme.numbers,
                          child: Text('$num', style: const TextStyle(fontSize: 22, color: Colors.white)),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppTheme.numbers, width: 4),
                      boxShadow: [BoxShadow(color: AppTheme.numbers.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      children: [
                        Text('$selectedNumber', style: AppTheme.heading(fontSize: 100, color: Colors.deepPurpleAccent)),
                        Text(getEmojiName(selectedNumber), style: AppTheme.body(fontSize: 28, weight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: List.generate(selectedNumber, (index) => Text(getEmojiForNumber(selectedNumber), style: const TextStyle(fontSize: 40))),
                        ),
                        const SizedBox(height: 20),
                        Text('Write the number below!', style: AppTheme.body(fontSize: 18, weight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _speakNumber,
                    style: AppTheme.pillButton(Colors.amber.shade700),
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Hear Again!', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _clearDrawing,
                    style: AppTheme.pillButton(Colors.redAccent),
                    child: const Text('Clear Drawing', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.numbers, width: 2),
              boxShadow: [BoxShadow(color: AppTheme.numbers.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(size: const Size(300, 150), painter: NumberDrawingPainter(points)),
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
