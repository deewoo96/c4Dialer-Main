import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app shell renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('C4Dialer'),
          ),
        ),
      ),
    );

    expect(find.text('C4Dialer'), findsOneWidget);
  });
}
