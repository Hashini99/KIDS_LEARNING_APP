import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/learning_home.dart';
import 'package:kids_learning_app/services/progress_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressService()..load(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LearningHome(),
      ),
    );
  }
}
