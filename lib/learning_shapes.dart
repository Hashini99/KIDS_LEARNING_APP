import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/services/audio_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';

class ShapeLearningScreen extends StatefulWidget {
  const ShapeLearningScreen({super.key});

  @override
  State<ShapeLearningScreen> createState() => _ShapeLearningScreenState();
}

class _ShapeLearningScreenState extends State<ShapeLearningScreen> {
  static const List<Map<String, dynamic>> _shapes = [
    {'name': 'Square', 'color': Colors.red},
    {'name': 'Rectangle', 'color': Colors.blue},
    {'name': 'Circle', 'color': Colors.yellow},
    {'name': 'Triangle', 'color': Colors.green},
    {'name': 'Ellipse', 'color': Colors.purple},
  ];

  late AudioService _audio;
  String? _matchedShape;
  String? _wrongTarget;

  @override
  void initState() {
    super.initState();
    _audio = AudioService(context.read<ProgressService>());
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  void _onCorrectDrop(String shape) async {
    setState(() {
      _matchedShape = shape;
      _wrongTarget = null;
    });
    await context.read<ProgressService>().addStars('shapes', 10);
    await _audio.playSfx('success.mp3');
    await _audio.speak('Great job! That\'s a $shape!');
  }

  void _onWrongDrop(String targetShape) async {
    setState(() => _wrongTarget = targetShape);
    await _audio.playSfx('out.mp3');
  }

  void _reset() {
    setState(() {
      _matchedShape = null;
      _wrongTarget = null;
    });
  }

  Widget _buildDraggable(String shape, Color color) {
    return Draggable<String>(
      data: shape,
      feedback: Material(color: Colors.transparent, child: _shapeWidget(shape, color.withOpacity(0.7))),
      childWhenDragging: Opacity(opacity: 0.3, child: _shapeWidget(shape, color)),
      child: _shapeWidget(shape, color),
    );
  }

  Widget _shapeWidget(String shape, Color color) {
    switch (shape) {
      case 'Square':
        return Container(height: 70, width: 70, color: color);
      case 'Rectangle':
        return Container(height: 55, width: 85, color: color);
      case 'Circle':
        return Container(height: 70, width: 70, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
      case 'Triangle':
        return CustomPaint(size: const Size(70, 70), painter: TrianglePainter(color));
      case 'Ellipse':
        return Container(height: 55, width: 85, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)));
      default:
        return const SizedBox();
    }
  }

  Widget _dropTarget(String shape, Color color) {
    final isMatched = _matchedShape == shape;
    final isWrong = _wrongTarget == shape;
    return DragTarget<String>(
      onAccept: (data) => data == shape ? _onCorrectDrop(shape) : _onWrongDrop(shape),
      builder: (context, candidateData, rejectedData) => AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: shape == 'Rectangle' || shape == 'Ellipse' ? 70 : 80,
        width: shape == 'Rectangle' || shape == 'Ellipse' ? 100 : 80,
        decoration: BoxDecoration(
          color: isMatched ? color : (isWrong ? Colors.redAccent.withOpacity(0.4) : Colors.white.withOpacity(0.6)),
          shape: shape == 'Circle' ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: shape == 'Circle' ? null : BorderRadius.circular(12),
          border: Border.all(color: color, width: 3),
        ),
        child: isMatched ? const Icon(Icons.check, color: Colors.white, size: 30) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stars = context.watch<ProgressService>().starsByTopic['shapes'] ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Learn Shapes', style: AppTheme.heading(fontSize: 26, color: Colors.white)),
        backgroundColor: AppTheme.shapes,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text('Drag each shape to its matching outline!', style: AppTheme.title(fontSize: 20), textAlign: TextAlign.center),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: _shapes.map((s) => _buildDraggable(s['name'] as String, s['color'] as Color)).toList(),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: _shapes.map((s) => _dropTarget(s['name'] as String, s['color'] as Color)).toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _reset,
                style: AppTheme.pillButton(AppTheme.shapes),
                child: const Text('Try Again!', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
