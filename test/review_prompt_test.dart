import 'package:c4dialer_v2/Utils/review_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows after five launches and stays dismissed when reviewed',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => ReviewPrompt.maybeShow(context),
              child: const Text('Open review prompt'),
            ),
          ),
        ),
      ),
    );

    for (var launch = 0; launch < 5; launch++) {
      await tester.tap(find.text('Open review prompt'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Enjoying C4Dialer?'), findsOneWidget);

    await tester.tap(find.text("I've already reviewed"));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open review prompt'));
    await tester.pumpAndSettle();
    expect(find.text('Enjoying C4Dialer?'), findsNothing);
  }, variant: const TargetPlatformVariant({TargetPlatform.android}));
}
