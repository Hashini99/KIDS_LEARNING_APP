

import 'package:flutter/material.dart';
import 'package:kids_learning_app/learning_home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LearningScreen(),
    );
  }
}

class LearningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning with Fun!'),
        centerTitle: true,
      ),
      body: LearningHome(),
    );
  }
}
