import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_firebase/main.dart';

void main() {
  testWidgets('MyApp renders the configured home page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(home: Scaffold(body: Text('Tela de teste'))),
    );

    expect(find.text('Tela de teste'), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.debugShowCheckedModeBanner, isFalse);
  });
}
