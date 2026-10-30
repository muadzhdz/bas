import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bas/main.dart';

void main() {
  testWidgets('AuthPage menampilkan field NPM, Password dan tombol Login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Login'), findsWidgets);
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    expect(find.text('Boash Academic System'), findsWidgets);
  });
}
