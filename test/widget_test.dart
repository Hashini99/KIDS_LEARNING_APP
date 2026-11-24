import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:kids_learning_app/main.dart';

void main() {
  testWidgets('Home screen shows title and all six learning cards', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MyApp());
    await tester.pump();

    expect(find.text('Kiddo Learn'), findsOneWidget);
    expect(find.text('Learn Colors'), findsOneWidget);
    expect(find.text('Learn Numbers'), findsOneWidget);
    expect(find.text('Learn Alphabets'), findsOneWidget);
    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('Shapes'), findsOneWidget);
    expect(find.text('Animals'), findsOneWidget);
  });
}
