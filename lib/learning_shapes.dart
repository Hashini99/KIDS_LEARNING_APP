import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:lottie/lottie.dart';

class ShapeLearningScreen extends StatefulWidget {
  @override
  _ShapeLearningScreenState createState() => _ShapeLearningScreenState();
}

class _ShapeLearningScreenState extends State<ShapeLearningScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _targetShape;
  bool _showSuccessAnimation = false;
  bool _showTryAgain = false;

  // Play sound for feedback
  void _playSound(String soundType) async {
    await _audioPlayer.play(AssetSource('$soundType.mp3'));
  }

  void _onDrop(String shape) {
    setState(() {
      _targetShape = shape;
      _showSuccessAnimation = true;
      _showTryAgain = false;
    });
    _playSound('success');
  }

  void _onTryAgain() {
    setState(() {
      _showTryAgain = true;
      _showSuccessAnimation = false;
    });
    _playSound('out');
  }

  void _reset() {
    setState(() {
      _targetShape = null;
      _showSuccessAnimation = false;
      _showTryAgain = false;
    });
  }

  Widget _buildShape(String shape, Color color) {
    return Draggable<String>(
      data: shape,
      child: _shapeWidget(shape, color),
      feedback: Material(
        color: Colors.transparent,
        child: _shapeWidget(shape, color.withOpacity(0.7)),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _shapeWidget(shape, color)),
    );
  }

  Widget _shapeWidget(String shape, Color color) {
    switch (shape) {
      case 'Square':
        return Container(height: 100, width: 100, color: color);
      case 'Rectangle':
        return Container(height: 80, width: 120, color: color);
      case 'Circle':
        return Container(height: 100, width: 100, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
      case 'Triangle':
        return CustomPaint(size: Size(100, 100), painter: TrianglePainter(color));
      case 'Ellipse':
        return Container(height: 80, width: 120, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)));
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(title: Text('Learn Shapes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)), backgroundColor: Colors.deepPurple),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Drag the Shape to the Correct Place!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildShape('Square', Colors.red),
            SizedBox(width: 20),
            _buildShape('Circle', Colors.yellow),
            SizedBox(width: 20),
            _buildShape('Triangle', Colors.green),
          ]),
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            DragTarget<String>(
              onAccept: (data) {
                data == 'Square' ? _onDrop(data) : _onTryAgain();
              },
              builder: (context, candidateData, rejectedData) => _dropTarget('Square', Colors.red),
            ),
            SizedBox(width: 20),
            DragTarget<String>(
              onAccept: (data) {
                data == 'Circle' ? _onDrop(data) : _onTryAgain();
              },
              builder: (context, candidateData, rejectedData) => _dropTarget('Circle', Colors.yellow),
            ),
            SizedBox(width: 20),
            DragTarget<String>(
              onAccept: (data) {
                data == 'Triangle' ? _onDrop(data) : _onTryAgain();
              },
              builder: (context, candidateData, rejectedData) => _dropTarget('Triangle', Colors.green),
            ),
          ]),
          SizedBox(height: 30),
          // if (_showTryAgain) Lottie.asset('assets/animations/sad_face.json', width: 100, height: 100),
          // if (_showSuccessAnimation) Lottie.asset('assets/animations/fireworks.json', width: 200, height: 200),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _reset, child: Text("Try Again!", style: TextStyle(fontSize: 24))),
        ],
      ),
    );
  }

 Widget _dropTarget(String shape, Color color) {
  return AnimatedContainer(
    duration: Duration(seconds: 1),
    height: 120,
    width: 120,
    decoration: BoxDecoration(
      color: _targetShape == shape ? color : Colors.grey,
      shape: shape == 'Circle' ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: shape == 'Circle' ? null : BorderRadius.circular(10), // Fix: Remove borderRadius for circles
    ),
  );
}

}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color..style = PaintingStyle.fill;
    Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
